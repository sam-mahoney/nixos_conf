{ config, pkgs, ... }:

{
  # === Hostname ===
  # Identifies this machine on the network
  networking.hostName = "helios";

  # === Network Manager ===
  # Provides GUI and CLI tools for network configuration
  # Handles WiFi, Ethernet, VPN, and mobile broadband
  networking.networkmanager.enable = true;

  # === Proxy Configuration ===
  # Uncomment and configure if behind a corporate proxy
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
}
