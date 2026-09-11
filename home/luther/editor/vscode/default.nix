{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      usernamehw.errorlens
      streetsidesoftware.code-spell-checker
      jnoortheen.nix-ide
      gruntfuggly.todo-tree
    ];
  };

  home.packages = with pkgs; [
    nil # Nix Language Server used by nix-ide
  ];

  xdg.configFile."Code/User/settings.json".source = ./settings.json;
}
