{
  pkgs,
  ...
}:

{
  # Plasma 6
  services = {
    desktopManager = {
      plasma6 = {
        enable = true;
        enableQt5Integration = true;
      };
    };
    displayManager.plasma-login-manager.enable = true;
  };

  # Fingerprint login
  security.pam.services.kde-fingerprint.fprintAuth = true;

  # Package Exclusion
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
  ];

  # Essential programs
  environment.systemPackages =
    (with pkgs; [
      adwaita-fonts
      adwaita-icon-theme
      adw-gtk3
      bibata-cursors
      (colloid-icon-theme.override {
        schemeVariants = [ "default" ];
        colorVariants = [ "all" ];
      })
      (fluent-gtk-theme.override {
        themeVariants = [ "all" ];
        colorVariants = [ "standard" ];
        sizeVariants = [ "standard" ];
        tweaks = [
          "solid"
          "float"
        ];
      })
      vlc
      (
        (vivaldi.override {
          proprietaryCodecs = true;
          enableWidevine = true;
          commandLineArgs = [
            "--password-store=kwallet6"
            "--ozone-platform=wayland"
            "--enable-wayland-ime"
            "--wayland-text-input-version=3"
          ];
        }).overrideAttrs
        (oldAttrs: {
          dontWrapQtApps = false;
          dontPatchELF = true;
          nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ pkgs.kdePackages.wrapQtAppsHook ];
        })
      )
      (google-chrome.override {
        commandLineArgs = [
          "--password-store=kwallet6"
          "--ozone-platform=wayland"
          "--enable-wayland-ime"
          "--wayland-text-input-version=3"
        ];
      })

    ])
    ++ (with pkgs.kdePackages; [
      markdownpart
      alligator
      isoimagewriter
      kcmutils
      phonon-vlc
      sddm-kcm
      flatpak-kcm
      kdeplasma-addons
      plasma5support
      kjournald
      ksystemlog
      ocean-sound-theme
      qtstyleplugin-kvantum
    ])
    ++ (with pkgs.libsForQt5; [
      qtstyleplugin-kvantum
    ]);

  # XDG configuration
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    config.common.default = [ "kde" ];
  };

  # Environment variables
  environment.sessionVariables = {
    GTK_USE_PORTAL = "1";
  };

  # Integration
  programs = {
    chromium.enablePlasmaBrowserIntegration = true;
    kdeconnect.enable = true;
  };
}
