{ config, pkgs, ... }:

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

  # === SSH Client Configuration ===
  # Automatically adds keys to the agent on first use
  # After entering your passphrase once, it's cached for the session
  programs.ssh = {
    enable = true;

    # Opt out of legacy default config — we set everything explicitly
    enableDefaultConfig = false;

    matchBlocks = {
      # Personal GitHub — uses personal SSH key
      "github.com-personal" = {
        host = "github.com";
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/helios_personal_ed25519";
        identitiesOnly = true;
        addKeysToAgent = "yes";
      };

      # Work SSH — uses work SSH key for Cydar repos
      "github.com-work" = {
        host = "github.com-work";
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/helios_ed25519";
        identitiesOnly = true;
        addKeysToAgent = "yes";
      };

      # Default catch-all for any other SSH host
      # Both keys are offered so either can match
      "*" = {
        identityFile = [
          "~/.ssh/helios_personal_ed25519"
          "~/.ssh/helios_ed25519"
        ];
        addKeysToAgent = "yes";
      };
    };
  };

  # === Pre-load SSH keys at login ===
  # Adds both keys to the agent on session start so you only enter
  # passphrases once (at login) rather than on first use of each key.
  systemd.user.services.ssh-add-keys = {
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
