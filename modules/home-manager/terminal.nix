{ config, pkgs, ... }:

{
  # === Kitty Terminal Emulator ===
  # GPU-accelerated terminal with image protocol support
  # Required for default Hyprland configuration
  programs.kitty.enable = true;

  # === Alacritty Terminal Emulator ===
  # Fast, GPU-accelerated terminal written in Rust
  # https://alacritty.org/
  programs.alacritty = {
    enable = true;
    
    settings = {
      # Set TERM variable for proper color support
      env.TERM = "xterm-256color";
      
      # Copy to clipboard on selection
      selection.save_to_clipboard = true;
    };
  };

  # === Starship Prompt ===
  # Cross-shell prompt with Git integration and rich context
  # https://starship.rs/
  programs.starship = {
    enable = true;
    # Configuration can be added here or in ~/.config/starship.toml
  };
}
