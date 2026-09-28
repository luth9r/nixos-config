{ ... }:

{
  programs.zap = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

    settings = {
      add_newline = false;
      format = ''
        $cmd_duration$directory$git_branch$git_status
          $character'';

      directory = {
        style = "bold cyan";
        truncation_length = 4;
        truncate_to_repo = true;
        format = "[$path]($style) ";
      };

      git_branch = {
        style = "bold purple";
        symbol = "󰘬 ";
        truncation_length = 15;
        truncation_symbol = "";
        format = "on [$symbol$branch]($style) ";
      };

      git_status = {
        style = "bold red";
        format = "([\\[$all_status$ahead_behind\\]]($style) )";
      };

      cmd_duration = {
        min_time = 2000;
        style = "dimmed yellow";
        format = "took [$duration]($style) ";
      };

      character = {
        format = "$symbol ";
        success_symbol = "[ ](bold green)";
        error_symbol = "[ ](bold red)";
      };
    };
  };
}
