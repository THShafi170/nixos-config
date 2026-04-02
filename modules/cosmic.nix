{
  pkgs,
  ...
}:

{
  imports = [
    ../services/config-wm.nix
  ];

  services = {
    # COSMIC
    desktopManager.cosmic = {
      enable = true;
      xwayland.enable = true;
    };
    displayManager.cosmic-greeter.enable = true;

    # Desktop services
    gnome.gnome-keyring.enable = true;
    gnome.gnome-settings-daemon.enable = true;
    gvfs.enable = true;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    # Extensions
    cosmic-ext-ctl
    cosmic-ext-tweaks
    cosmic-ext-calculator
    cosmic-ext-applet-caffeine
    cosmic-ext-applet-weather
    cosmic-ext-applet-privacy-indicator

    (vivaldi.override {
      proprietaryCodecs = true;
      enableWidevine = true;
      commandLineArgs = [
        "--password-store=gnome-libsecret"
        "--ozone-platform=wayland"
        "--enable-wayland-ime"
        "--wayland-text-input-version=3"
      ];
    })
    (google-chrome.override {
      commandLineArgs = [
        "--password-store=gnome-libsecret"
        "--ozone-platform=wayland"
        "--enable-wayland-ime"
        "--wayland-text-input-version=3"
      ];
    })

    # Screenshot tools
    slurp
    grim
    satty

    # GNOME programs
    gnome-control-center
    gnome-settings-daemon
    gnome-tweaks
    loupe
    papers
    showtime
    xdg-user-dirs-gtk

    # Nemo file manager and extensions
    file-roller
    nemo
    nemo-with-extensions
    nemo-python
    nemo-preview
    nemo-seahorse
    nemo-fileroller

    # Theming
    cutecosmic
    bibata-cursors
    kdePackages.breeze
    kdePackages.breeze-gtk
    kdePackages.breeze-icons
    kdePackages.qqc2-breeze-style
    adw-gtk3
    themechanger

    # System tools
    xdg-utils
    xdg-user-dirs
    xsettingsd

    # Wayland
    xwayland
    wayland-utils
  ];

  # Essential programs
  programs = {
    seahorse.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  # PAM settings
  security = {
    pam.services = {
      login.enableGnomeKeyring = true;
      greetd.enableGnomeKeyring = true;
    };
  };

  # XDG portals for COSMIC
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-cosmic
      xdg-desktop-portal-gtk
    ];
    config.common = {
      default = [
        "cosmic"
        "gtk"
      ];
      "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
    };
  };

  # Environment variables
  environment.sessionVariables = {
    # COSMIC-specific
    COSMIC_DATA_CONTROL_ENABLED = "1";

    # Qt settings
    QT_QPA_PLATFORMTHEME = "cosmic";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";

    # Wayland
    GDK_SCALE = "1.25";
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_WEBRENDER = "1";
    _JAVA_AWT_WM_NONREPARENTING = "1";

    # Cursor theme
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "28";
  };
}
