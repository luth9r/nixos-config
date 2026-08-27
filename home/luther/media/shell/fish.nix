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

      # Enable zoxide if available
      if type -q zoxide
        zoxide init fish | source
      end

      # Fulltext code/content search launcher (search.sh)
      function __run_search
        set -l script "$HOME/.config/hypr/scripts/search.sh"
        if test -f "$script"
          set -l target (bash "$script")
          if test -n "$target"
            commandline -i (string escape "$target")
          end
          commandline -f repaint
        end
      end

      # File finder by name launcher (find-files.sh)
      function __run_find_files
        set -l script "$HOME/.config/hypr/scripts/find-files.sh"
        if test -f "$script"
          set -l target (bash "$script")
          if test -n "$target"
            commandline -i (string escape "$target")
          end
          commandline -f repaint
        end
      end

      # Keybindings using Alt combinations (Alt+F for grep, Alt+P for find)
      function fish_user_key_bindings
        # Search code/text: Alt + F (US) / Alt + А (RU, UA)
        bind \ef __run_search
        bind \eF __run_search
        bind \eа __run_search
        bind \eА __run_search
        bind alt-f __run_search
        bind alt-а __run_search
        bind alt-А __run_search

        # Find files: Alt + P (US) / Alt + З (RU, UA)
        bind \ep __run_find_files
        bind \eP __run_find_files
        bind \eз __run_find_files
        bind \eЗ __run_find_files
        bind alt-p __run_find_files
        bind alt-з __run_find_files
        bind alt-З __run_find_files
      end
    '';

    shellAliases = {
      # Modern NixOS nh shortcuts (fully dynamic for any user)
      nr = "nh os switch";
      nrt = "nh os test";
      nrb = "nh os boot";
      nc = "nh clean all --keep 3";
      nfu = "nix flake update $FLAKE";

      # Standalone search aliases
      search = "~/.config/hypr/scripts/search.sh";
      findf = "~/.config/hypr/scripts/find-files.sh";

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
