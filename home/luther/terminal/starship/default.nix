{ ... }:

{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = false;
      format = ''
        $cmd_duration$directory$git_branch$git_status
          $character'';

      directory = {
        style = "bold cyan";
        truncation_length = 4;
        truncate_to_repo = true;
        format = "[$path]($style)";
      };

      git_branch = {
        style = "bold purple";
        symbol = "󰘬";
        truncation_length = 15;
        truncation_symbol = "";
        format = " 󰜥 [](bold purple)[$symbol $branch(:$remote_branch)](fg:black bg:purple)[](bold purple) ";
      };

      git_status = {
        style = "bold red";
        format = "([\\[$all_status$ahead_behind\\]]($style) )";
      };

      cmd_duration = {
        min_time = 2000;
        style = "dimmed yellow";
        format = "[$duration]($style) ";
      };

      character = {
        success_symbol = "[ ](bold green)";
        error_symbol = "[ ](bold red)";
      };

      package = {
        disabled = true;
      };
    };
  };
}
