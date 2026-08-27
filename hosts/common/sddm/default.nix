{ pkgs, vars, ... }:

let
  configuredTheme = pkgs.replaceVars ./theme.conf.user {
    font = vars.font;
    fontSize = toString vars.fontSize;
    rounding = toString vars.rounding;
    colorBg = vars.colorBg;
    colorBgAlt = vars.colorBgAlt;
    colorSurface = vars.colorSurface;
    colorBorder = vars.colorBorder;
    colorFg = vars.colorFg;
    colorFgMuted = vars.colorFgMuted;
    colorAccent = vars.colorAccent;
    colorAccentFg = vars.colorAccentFg;
    colorWarning = vars.colorWarning;
  };

  sddm-astronaut = (pkgs.sddm-astronaut.override {
    embeddedTheme = "astronaut";
  }).overrideAttrs (oldAttrs: {
    # Inject custom standalone theme configuration and background image
    installPhase = oldAttrs.installPhase + ''
      chmod -R u+w $out/share/sddm/themes/sddm-astronaut-theme/
      cp -f ${configuredTheme} $out/share/sddm/themes/sddm-astronaut-theme/theme.conf.user
      cp -f ${configuredTheme} $out/share/sddm/themes/sddm-astronaut-theme/Themes/astronaut.conf
      cp -f ${configuredTheme} $out/share/sddm/themes/sddm-astronaut-theme/theme.conf
      cp -f ${../../../wallpapers/default.jpg} \
        $out/share/sddm/themes/sddm-astronaut-theme/Backgrounds/wallpaper.jpg
    '';
  });
in
{
  environment.systemPackages = [ sddm-astronaut ];

  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;
    wayland.enable = true;
    extraPackages = with pkgs; [
      sddm-astronaut
      kdePackages.qtmultimedia
      kdePackages.qtsvg
      kdePackages.qtvirtualkeyboard
    ];
    theme = "sddm-astronaut-theme";
  };
}
