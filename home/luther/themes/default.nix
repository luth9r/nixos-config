{ pkgs, vars, lib, ... }:

let
  hexToRgb = hex:
    let
      clean = lib.strings.removePrefix "#" hex;
      r = toString (lib.trivial.fromHexString (builtins.substring 0 2 clean));
      g = toString (lib.trivial.fromHexString (builtins.substring 2 2 clean));
      b = toString (lib.trivial.fromHexString (builtins.substring 4 2 clean));
    in
      "${r},${g},${b}";

  configuredKdeGlobals = pkgs.replaceVars ./kdeglobals {
    font = vars.font;
    iconTheme = vars.iconTheme;
    colorBgRgb = hexToRgb vars.colorBg;
    colorBgAltRgb = hexToRgb vars.colorBgAlt;
    colorSurfaceRgb = hexToRgb vars.colorSurface;
    colorBorderRgb = hexToRgb vars.colorBorder;
    colorBorderActive2Rgb = hexToRgb vars.colorBorderActive2;
    colorFgRgb = hexToRgb vars.colorFg;
    colorFgMutedRgb = hexToRgb vars.colorFgMuted;
    colorAccentRgb = hexToRgb vars.colorAccent;
    colorAccentFgRgb = hexToRgb vars.colorAccentFg;
    colorRedRgb = hexToRgb vars.colorRed;
    colorGreenRgb = hexToRgb vars.colorGreen;
    colorYellowRgb = hexToRgb vars.colorYellow;
    colorBlueRgb = hexToRgb vars.colorBlue;
    colorMagentaRgb = hexToRgb vars.colorMagenta;
  };
in
{
  home.packages = with pkgs; [
    kdePackages.breeze
    kdePackages.breeze-icons
    kdePackages.qqc2-breeze-style
    kdePackages.breeze-gtk
    tela-circle-icon-theme
    papirus-icon-theme
    adw-gtk3
    bibata-cursors
  ];

  # Force dark theme across all modern GTK/GNOME/Portal applications
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = vars.gtkTheme;
      icon-theme = vars.iconTheme;
      cursor-theme = vars.cursorTheme;
      cursor-size = vars.cursorSize;
      font-name = "${vars.font} ${toString (vars.fontSize - 1)}";
    };
  };

  # GTK Theme & Cursor Configuration
  gtk = {
    enable = true;
    theme = {
      name = vars.gtkTheme;
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = vars.iconTheme;
      package = pkgs.tela-circle-icon-theme;
    };
    cursorTheme = {
      name = vars.cursorTheme;
      package = pkgs.bibata-cursors;
      size = vars.cursorSize;
    };
    font = {
      name = vars.font;
      size = vars.fontSize - 1;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # Qt / KDE Platform Theme & Color Scheme
  qt = {
    enable = true;
    platformTheme.name = "kde";
    style.name = "breeze";
  };

  # Session variables for dark theme
  home.sessionVariables = {
    GTK_THEME = vars.gtkTheme;
    QT_QPA_PLATFORMTHEME = "kde";
    QT_STYLE_OVERRIDE = "breeze";
  };

  # Cursor settings for Home-Manager
  home.pointerCursor = {
    enable = true;
    name = vars.cursorTheme;
    package = pkgs.bibata-cursors;
    size = vars.cursorSize;
    gtk.enable = true;
    x11.enable = true;
  };

  # Deploy KDE color scheme into both ~/.config/kdeglobals and ~/.local/share/color-schemes/
  xdg.configFile."kdeglobals".source = configuredKdeGlobals;
  xdg.dataFile."color-schemes/Monochrome.colors".source = configuredKdeGlobals;
  xdg.configFile."dolphinrc".source = ./dolphinrc;
}
