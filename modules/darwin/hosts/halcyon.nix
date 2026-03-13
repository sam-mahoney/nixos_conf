{ ... }:

{
  imports = [
    ../system.nix
  ];

  networking = {
    computerName = "halcyon";
    hostName = "halcyon";
    localHostName = "halcyon";
  };
}
