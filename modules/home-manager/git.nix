{ config, pkgs, lib, osConfig ? null, ... }:

let
  hostName = osConfig.networking.hostName or "";
  isHelios = pkgs.stdenv.isLinux && hostName == "helios";
in
{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Sam Mahoney";
        email = "mahoney@cmui.co.uk";
      };

      core.sshCommand = lib.mkIf isHelios "ssh -i ~/.ssh/helios_personal_ed25519 -o IdentitiesOnly=yes";
    };

    includes = lib.optionals isHelios [
      {
        condition = "gitdir:~/cydar/";
        contents = {
          user = {
            name = "Sam Mahoney";
            email = "sam.mahoney@cydar.co.uk";
          };
          core.sshCommand = "ssh -i ~/.ssh/helios_ed25519 -o IdentitiesOnly=yes";
        };
      }
    ];
  };
  
  services.ssh-agent.enable = true;

  programs.ssh = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "*" = {
        addKeysToAgent = "yes";
      };
    };
  };

  # Helios-only: ssh-add the two named identity files on login so the
  # passphrase prompt happens once per session, not per key use.
  systemd.user.services.ssh-add-keys = lib.mkIf isHelios {
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
