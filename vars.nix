# Centralized User & Rice Configuration Variables
# Edit this file to customize your identity, preferences, and rice settings for any machine/user.

{
  # User Profile & Identity
  username = "luther";                  # System user account name
  name = "Your Name";                   # Display name / Git author name
  email = "your-email@example.com";     # Git email & notification address
  hostname = "nixos";                   # Hostname of the system

  # Desktop Environment Preferences
  terminal = "kitty";
  shell = "fish";
  editor = "zeditor";
  fileManager = "dolphin";
  browser = "firefox";

  # Relative path to your dotfiles flake directory inside $HOME (default: "nixos-config")
  flakeDir = "nixos-config";

  # Device form-factor: set to false to hide battery indicator on desktop
  isLaptop = true;

  # Hardware & Graphics Driver Selection
  # Options:
  #   - "hybrid-amd-nvidia"   : AMD CPU + NVIDIA dGPU laptop (e.g. Lenovo IdeaPad/Legion, ASUS ROG AMD)
  #   - "hybrid-intel-nvidia" : Intel CPU + NVIDIA dGPU laptop (e.g. Dell XPS, ASUS Intel)
  #   - "nvidia"              : Single NVIDIA GPU desktop
  #   - "amd"                 : Pure AMD GPU (Mesa RADV / Radeon RX / Ryzen APU)
  #   - "intel"               : Pure Intel GPU (Intel Iris Xe / Arc / UHD Graphics)
  #   - "vm"                  : Virtual Machine (QEMU/KVM, VirtualBox)
  gpuDriver = "hybrid-amd-nvidia";

  # PCI Bus IDs for NVIDIA Hybrid Laptops (run `lspci | grep -E "VGA|3D"` to check yours)
  nvidiaBusId = "PCI:1:0:0";
  amdgpuBusId = "PCI:6:0:0";
  intelBusId = "PCI:0:2:0";

  # Keyboard & Input Preferences
  kbLayout = "us,ru,ua";                # Keyboard layouts (comma-separated: "us,ru,ua", "us,pl", etc.)
  kbVariant = "";                       # Keyboard layout variants (optional)
  kbOptions = "grp:alt_shift_toggle";   # Layout switch options ("grp:alt_shift_toggle", "grp:win_space_toggle", "caps:escape")
  mouseSensitivity = -0.7;              # Range: -1.0 to 1.0 (0.0 = normal)
  accelProfile = "adaptive";            # "adaptive" (standard curve) or "flat" (no acceleration)
  naturalScroll = true;                 # Touchpad natural scrolling

  # Workspace & Window Management
  maxWorkspaces = 10;                   # Configurable maximum workspaces (default: 10)
  windowLayout = "dwindle";             # "dwindle" or "master"
  dwindleSplitDirection = 0;            # Window spawn direction: 0 = auto/follow mouse, 1 = left/top, 2 = right/bottom
  dwindleSmartSplit = false;            # true = split based on mouse pointer position within window
  dwindlePreserveSplit = true;          # true = preserve split layout on window close
  initialWorkspaceTracking = 1;         # 1 = spawn new apps on the workspace where they were launched

  # Rice & Theme Options
  font = "JetBrainsMono Nerd Font";
  fontSize = 12;
  rounding = 10;
  borderSize = 2;
  gapsIn = 4;
  gapsOut = 8;
  gtkTheme = "adw-gtk3-dark";
  iconTheme = "Tela-circle-dark";
  cursorTheme = "Bibata-Modern-Classic";
  cursorSize = 24;
  qtScale = "1.25";                     # Global scale factor for Qt/KDE applications (1.0 = 100%, 1.25 = 125%, 1.5 = 150%)

  # Centralized Color Palette (Ultra-Muted Monochrome with Desaturated Accents)
  colorBg = "#0a0a0a";                  # Main background
  colorBgAlt = "#1a1a1a";               # Card / container background
  colorSurface = "#121218";             # Input field / surface background
  colorBorder = "#282828";              # Inactive border
  colorBorderActive1 = "#ffffff";       # Active border gradient start
  colorBorderActive2 = "#888888";       # Active border gradient end
  colorFg = "#e0e0e0";                  # Foreground / main text
  colorFgMuted = "#888888";             # Muted / secondary text
  colorAccent = "#ffffff";              # Primary accent
  colorAccentFg = "#0a0a0a";            # Accent foreground

  # Muted Desaturated Syntax Accents (Low saturation, blends seamlessly into monochrome)
  colorRed = "#b86868";                 # Muted dust red (Errors, deletions)
  colorGreen = "#7a9a7a";               # Muted sage green (Success, additions)
  colorYellow = "#b89b68";              # Muted sand yellow (Warnings)
  colorBlue = "#6d8699";                # Muted slate blue (Directories, info)
  colorMagenta = "#9e7e9e";             # Muted lavender mauve (Keywords)
  colorCyan = "#6b9696";                # Muted pebble teal (Paths, quotes)
  colorWarning = "#b86868";             # Warning / error color
}
