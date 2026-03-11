{
  inputs,
  pkgs,
  sharedFonts,
  ...
}:

{
  # System packages
  environment.systemPackages = with pkgs; [
    # System utilities
    binwalk
    btop
    btrfs-progs
    colord
    dconf-editor
    dee
    dosfstools
    gammastep
    libsecret
    mtools
    ntfs3g
    seatd
    libunity
    libayatana-appindicator
    libappindicator-gtk2
    libappindicator-gtk3
    wl-clipboard

    # Media & Graphics
    pavucontrol
    ffmpegthumbnailer
    gdk-pixbuf
    icoextract
    icoutils
    imagemagick
    krita
    switcheroo
    webp-pixbuf-loader
    wpgtk
    xournalpp

    # Android tools
    android-tools
    heimdall

    # Communication
    (discord.override {
      withEquicord = true;
    })
    zapzap

    # Gaming & Wine
    inputs.bottles-deflatpak.packages.${pkgs.stdenv.hostPlatform.system}.bottles-deflatpak-unwrapped
    heroic
    lutris
    mangohud
    protonplus
    steam
    steamcmd
    steam-run
    umu-launcher
    vkbasalt
    vkbasalt-cli
    wineWow64Packages.fonts
    wineWow64Packages.stagingFull
    winetricks

    # Emulations
    dosbox-x
    (_86box-with-roms.override {
      unfreeEnableDiscord = true;
      unfreeEnableRoms = true;
    })

    # Other programs
    gnome-boxes
    proton-authenticator

    # Productivity
    onlyoffice-desktopeditors
    qbittorrent

    # Archives & Compression
    rar
    p7zip
    unzip
    unrar
    freetype
    varia
  ];

  # Environment variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    NIXPKGS_ALLOW_UNFREE = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    ELECTRON_ENABLE_HARDWARE_ACCELERATION = "1";
  };

  # Services
  services.flatpak = {
    enable = true;
    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
    ];
  };

  # XDG configuration
  xdg.portal.xdgOpenUsePortal = true;

  # Programs configuration
  programs = {
    # Basic programs
    command-not-found.enable = true;
    chromium.enable = true;
    dconf.enable = true;
    appimage.enable = true;
    gamemode.enable = true;
    gamescope.enable = true;

    # Steam configuration
    steam = {
      enable = true;
      extraPackages =
        with pkgs;
        [
          libXcursor
          libXi
          libXinerama
          libXcomposite
          libGL
          vulkan-loader
          libpulseaudio
          alsa-lib
          libkrb5
          systemd
          wayland
          libxkbcommon
        ]
        ++ sharedFonts;
      remotePlay.openFirewall = true;
      gamescopeSession.enable = true;
      protontricks.enable = true;
    };
  };
}
