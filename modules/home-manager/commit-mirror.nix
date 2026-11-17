{ config, pkgs, lib, osConfig ? null, ... }:

let
  isHelios = (osConfig.networking.hostName or "") == "helios";
  mirrorDir = "${config.home.homeDirectory}/swag/commit_mirror";
in
lib.mkIf isHelios {
  systemd.user.services.commit-mirror = {
    Unit = {
      Description = "Mirror work commit timestamps to personal GitHub";
      After = [ "ssh-agent.service" ];
    };

    Service = {
      Type = "oneshot";
      Environment = "SSH_AUTH_SOCK=%t/ssh-agent";
      ExecStart = pkgs.writeShellScript "commit-mirror" ''
        export PATH=${lib.makeBinPath [ pkgs.git pkgs.openssh pkgs.python3 ]}
        exec python3 ${mirrorDir}/mirror_commits.py --fetch
      '';
    };
  };

  systemd.user.timers.commit-mirror = {
    Unit = {
      Description = "Mirror work commit timestamps every Thursday at 15:00";
    };

    Timer = {
      OnCalendar = "Thu 15:00";
      Persistent = true;
      Unit = "commit-mirror.service";
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
