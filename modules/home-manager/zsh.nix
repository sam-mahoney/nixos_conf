{ ... }:

let
  p = (import ../theme.nix).palette;
in
{
  programs.starship = {
    enable = true;
    settings = {
      format = "$directory$git_branch$git_status$status$character";
      directory = {
        truncation_length = 3;
        style = "bold ${p.gray1}";
      };
      git_branch.style = p.gray3;
      git_status.style = p.gray4;
      status = {
        disabled = false;
        format = "[$status](bold ${p.red})";
      };
      character = {
        success_symbol = "[❯](bold ${p.fg_bright})";
        error_symbol = "[❯](bold ${p.red})";
      };
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.zsh = {
    enable = true;

    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -la";
      ".." = "cd ..";
      "..." = "cd ../..";
      gs = "git status";
      gd = "git diff";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline --graph";
      ta = "tmux attach -t main || tmux new -s main";
    };

    history = {
      size = 50000;
      save = 50000;
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      extended = true;
      share = true;
    };

    enableCompletion = true;
    completionInit = ''
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      zstyle ':completion:*' menu select
      zstyle ':completion:*' list-colors "$${(s.:.)LS_COLORS}"
      zstyle ':completion:*' group-name ""
      zstyle ':completion:*:descriptions' format '%F{blue}-- %d --%f'
      zstyle ':completion:*:warnings' format '%F{red}-- no matches --%f'
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path "$HOME/.zsh/cache"
      zstyle ':completion:*:*:kill:*' menu yes select
      zstyle ':completion:*:kill:*' force-list always
    '';

    autosuggestion = {
      enable = true;
      strategy = [ "history" "completion" ];
    };
    syntaxHighlighting.enable = true;

    initContent = ''
      setopt AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT EXTENDED_GLOB
      unsetopt NOMATCH  # needed for nix flake refs like .#helios

      bindkey '^[[A' history-search-backward
      bindkey '^[[B' history-search-forward

      if command -v fzf &> /dev/null; then
        source <(fzf --zsh 2>/dev/null || true)
      fi
    '';
  };

  programs.bash.enable = true;

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [ "--height=40%" "--layout=reverse" "--border" ];
  };
}
