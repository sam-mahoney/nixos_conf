{ ... }:

let
  host = "halcyon";
in
{
  imports = [
    ../../modules/darwin/system.nix
    ../../modules/darwin/llama-cpp.nix
  ];

  networking = {
    computerName = host;
    hostName = host;
    localHostName = host;
  };
}
