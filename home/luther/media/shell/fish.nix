{ pkgs, vars, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting ""

      # Flake path configured directly from vars.nix
      set -l configured_flake "$HOME/${vars.flakeDir or "nixos-config"}"

      if test -d "$configured_flake"
        set -gx FLAKE "$configured_flake"
        set -gx NH_FLAKE "$configured_flake"
      else if test -d "$HOME/nixos-config"
        set -gx FLAKE "$HOME/nixos-config"
        set -gx NH_FLAKE "$HOME/nixos-config"
      else if test -d "$HOME/dotfiles"
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
            if test -z (commandline)
              # Open directly in system default app / editor
              xdg-open "$target" >/dev/null 2>&1 &
              disown
            else
              # If user already typed something in terminal, insert path
              commandline -i (string escape "$target")
            end
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
            if test -z (commandline)
              # Open directly in system default app / editor
              xdg-open "$target" >/dev/null 2>&1 &
              disown
            else
              # If user already typed something in terminal, insert path
              commandline -i (string escape "$target")
            end
          end
          commandline -f repaint
        end
      end

      # Smart Nix Cleanup with optional generations count (default 3)
      function nc
        set -l keep_count 3
        if test (count $argv) -gt 0
          set keep_count $argv[1]
        end
        echo "Cleaning Nix store and profiles (keeping $keep_count generations)..."
        nh clean all --keep $keep_count
      end

      # Clean bootloader entries & old system generations only
      function ncb
        set -l keep_count 1
        if test (count $argv) -gt 0
          set keep_count $argv[1]
        end
        echo "Cleaning boot generations (keeping $keep_count latest)..."
        nh clean all --keep $keep_count --no-direnv
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
