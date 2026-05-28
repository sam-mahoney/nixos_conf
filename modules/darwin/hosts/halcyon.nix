{ ... }:

let
  host = "halcyon";
in
{
  imports = [
    ../system.nix
  ];

  networking = {
    computerName = host;
    hostName = host;
    localHostName = host;
  };
}
