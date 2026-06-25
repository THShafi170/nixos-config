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
    appmenu-gtk3-module
    libunity
    libayatana-appindicator
    libappindicator-gtk2
    libappindicator-gtk3
    python3Packages.pyclip
    wl-clipboard
    oh-my-posh

    # Media & Graphics
    pavucontrol
    ffmpegthumbnailer
    gdk-pixbuf
    icoextract
    icoutils
    imagemagick
    krita
    pear-desktop
    switcheroo
    webp-pixbuf-loader
    xournalpp

    # Communication
    (discord.override {
      withEquicord = true;
    })
    osmium
    # equibop
    # arrpc-bun
    zapzap

    # Gaming & Wine
    inputs.bottles-deflatpak.packages.${pkgs.stdenv.hostPlatform.system}.bottles-deflatpak-unwrapped
    faugus-launcher
    heroic
    lutris
    mangohud
    protonplus
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
    (_86box.override {
      enableDynarec = true;
      enableWayland = true;
      unfreeEnableDiscord = true;
      unfreeEnableRoms = true;
    })

    # Other programs
    gnome-boxes
    ente-auth

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

  # Brave policies
  environment.etc."brave/policies/managed/config.json".text = builtins.toJSON {
    BraveRewardsDisabled = 1;
    BraveWalletDisabled = 1;
    BraveVPNDisabled = 1;
    BraveAIChatEnabled = 0;
    BraveP3AEnabled = 0;
    BraveTalkDisabled = 1;
  };

  # Session variables
  environment.sessionVariables = {
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

  # Programs configuration
  programs = {
    # Basic programs
    chromium.enable = true;
    dconf.enable = true;
    appimage.enable = true;
    gamemode.enable = true;
    gamescope.enable = true;

    # Steam configuration
    steam = {
      enable = true;
      fontPackages = sharedFonts;
      extraPackages = with pkgs; [
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
      ];
      remotePlay.openFirewall = true;
      gamescopeSession.enable = true;
      protontricks.enable = true;
    };
  };
}
