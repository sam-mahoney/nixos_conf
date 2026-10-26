{ ... }:

let
  host = "halcyon";
in
{
  imports = [
    ../system.nix
    ../llama-cpp.nix
  ];

  networking = {
    computerName = host;
    hostName = host;
    localHostName = host;
  };
}
