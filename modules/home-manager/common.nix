{ pkgs, user, ... }:

{
  imports = [
    ./packages.nix
    ./alacritty.nix
    ./zsh.nix
    ./tmux.nix
    ./neovim.nix
    ./git.nix
    ./opencode.nix
  ];

  home.username = user;
  home.homeDirectory =
    if pkgs.stdenv.isDarwin then "/Users/${user}" else "/home/${user}";
  home.stateVersion = "25.11";

  programs.firefox.enable = true;

  home.file.".steampipe/config/aws.spc".text = ''
    connection "default" {
      plugin = "aws"
    }

    connection "dev" {
      plugin  = "aws"
      profile = "dev"
    }
  '';
}
