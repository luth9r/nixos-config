{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting ""
      # Dynamically set dotfiles flake path from user's current HOME directory
      if test -d "$HOME/dotfiles"
        set -gx FLAKE "$HOME/dotfiles"
        set -gx NH_FLAKE "$HOME/dotfiles"
      end
      # Enable zoxide and starship if available
      if type -q zoxide
        zoxide init fish | source
      end
    '';
    shellAliases = {
      # Modern NixOS nh shortcuts (fully dynamic for any user)
      nr = "nh os switch";
      nrt = "nh os test";
      nrb = "nh os boot";
      nc = "nh clean all --keep 3";
      nfu = "nix flake update $FLAKE";

      # Performance mode runner
      perf = "gamemoderun";

      # Legacy fallback
      nrs = "sudo nixos-rebuild switch --flake $FLAKE#nixos";

      # Modern CLI replacements
      ls = "eza --icons";
      ll = "eza -l --icons --git";
      la = "eza -la --icons --git";
      tree = "eza --tree --icons";
      cat = "bat";
      grep = "rg";
      find = "fd";
      top = "btop";

      # Git shortcuts
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline --graph";

      # Quick wallpaper switcher
      chwall = "~/.config/hypr/scripts/change-wall.sh";
    };
  };
}
