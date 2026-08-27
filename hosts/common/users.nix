{ pkgs, vars, ... }:

{
  # Enable fish shell globally
  programs.fish.enable = true;

  # User accounts
  users.users.${vars.username} = {
    isNormalUser = true;
    description = vars.name;
    shell = pkgs.${vars.shell};
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "input"
    ];
  };
}
