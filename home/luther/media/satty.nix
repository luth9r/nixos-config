{ vars, ... }:

{
  # Full Declarative Satty Configuration parameterized with vars.nix
  xdg.configFile."satty/config.toml".text = ''
    [general]
    fullscreen = false
    early-exit = true
    initial-tool = "brush"
    copy-command = "wl-copy"
    annotation-size-factor = 1.5
    save-after-copy = true
    default-hide-toolbars = false
    primary-highlighter = "block"

    [font]
    family = "${vars.font}"
    style = "Bold"

    [color-palette]
    palette = [
      "${vars.colorAccent}",
      "${vars.colorRed}",
      "${vars.colorGreen}",
      "${vars.colorYellow}",
      "${vars.colorBlue}",
      "${vars.colorMagenta}",
      "${vars.colorCyan}",
      "${vars.colorBg}",
    ]
  '';
}
