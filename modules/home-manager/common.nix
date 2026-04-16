{ ... }:

{
  imports = [
    ./packages.nix
    ./alacritty.nix
    ./zsh.nix
    ./tmux.nix
    ./neovim.nix
    ./git.nix
    ./opencode.nix
    ./peon-ping.nix
    ./tor-browser.nix
  ];

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
