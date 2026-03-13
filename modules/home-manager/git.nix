{ config, pkgs, lib, ... }:

{
  # Git version control configuration
  # https://git-scm.com/docs/git-config
  
  programs.git = {
    enable = true;
    
    # === Default Identity ===
    # Used for all repositories unless overridden
    settings = {
      user = {
        name = "Sam Mahoney";
        email = "mahoney@cmui.co.uk";  # Personal email by default
      };
      
      # Use personal SSH key by default
      core.sshCommand = "ssh -i ~/.ssh/helios_personal_ed25519";
    };
  
    # === Conditional Includes ===
    # Override settings based on repository location
    includes = [
      {
        # === Work Configuration ===
        # Use work identity and SSH key for Cydar repositories
        condition = "gitdir:~/cydar/";
        contents = {
          user = {
            name = "Sam Mahoney";
            email = "sam.mahoney@cydar.co.uk";  # Work email
          };
          # Use work SSH key
          core.sshCommand = "ssh -i ~/.ssh/helios_ed25519";
        };
      }
    ];
  };
  
  # === SSH Agent Service ===
  # Manages SSH keys and handles authentication
  # Automatically starts with user session
  services.ssh-agent.enable = true;

  programs.ssh = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;

    # Opt out of legacy default config — we set everything explicitly
    enableDefaultConfig = false;

    matchBlocks = {
      # Personal GitHub — plain github.com uses personal key
      # This matches remote URLs like git@github.com:sam-mahoney/...
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/helios_personal_ed25519";
        identitiesOnly = true;
        addKeysToAgent = "yes";
      };

      # Work GitHub — use "github.com-work" as the host alias
      # Work repos use remote URLs like git@github.com-work:cydar/...
      "github.com-work" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/helios_ed25519";
        identitiesOnly = true;
        addKeysToAgent = "yes";
      };

      # Default catch-all for any other SSH host (e.g. servers)
      "*" = {
        addKeysToAgent = "yes";
      };
    };
  };

  # === Pre-load SSH keys at login ===
  # Adds both keys to the agent on session start so you only enter
  # passphrases once (at login) rather than on first use of each key.
  systemd.user.services.ssh-add-keys = lib.mkIf pkgs.stdenv.isLinux {
    Unit = {
      Description = "Pre-load SSH keys into agent";
      After = [ "ssh-agent.service" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = let
        script = pkgs.writeShellScript "ssh-add-keys" ''
          ${pkgs.openssh}/bin/ssh-add ~/.ssh/helios_personal_ed25519 2>/dev/null || true
          ${pkgs.openssh}/bin/ssh-add ~/.ssh/helios_ed25519 2>/dev/null || true
        '';
      in "${script}";
      Environment = "SSH_AUTH_SOCK=%t/ssh-agent";
    };
    Install.WantedBy = [ "default.target" ];
  };
}
