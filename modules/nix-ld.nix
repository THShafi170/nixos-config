{
  inputs,
  pkgs,
  ...
}:

{
  # Enable nix-alien
  environment.systemPackages = with inputs.nix-alien.packages."${pkgs.stdenv.hostPlatform.system}"; [
    nix-alien
  ];

  # Enable nix-ld for dynamic linking compatibility
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # System essentials
      stdenv.cc.cc
      dbus
      expat
      icu
      libcap
      libelf
      libunwind
      libusb1
      libuuid
      util-linux
      tbb

      # Audio libraries
      alsa-lib
      flac
      libcaca
      libcanberra
      libmikmod
      libogg
      libpulseaudio
      libsamplerate
      libtheora
      libvorbis
      libvpx
      speex
      pipewire

      # Compression
      bzip2
      zlib
      zstd

      # Font support
      fontconfig
      freetype
      libidn

      # Graphics and OpenGL
      cairo
      fuse3
      libdrm
      libGL
      libglvnd
      libva
      libvdpau
      librsvg
      mesa
      pango
      pixman
      vulkan-loader
      freeglut
      glew_1_10

      # GUI toolkit libraries
      atk
      at-spi2-atk
      at-spi2-core
      cups
      gdk-pixbuf
      glib
      gnome2.GConf
      gtk2
      gtk3
      libappindicator-gtk2
      libappindicator-gtk3
      libdbusmenu-gtk2
      libindicator-gtk2
      libxkbcommon

      # Image processing
      libjpeg
      libpng
      libpng12
      libtiff

      # Multimedia
      ffmpeg

      # SDL gaming libraries
      SDL
      SDL2
      SDL2_image
      SDL2_mixer
      SDL2_ttf
      SDL_image
      SDL_mixer
      SDL_ttf

      # Security and crypto
      libgcrypt
      libnotify
      libsodium
      libssh
      nspr
      nss
      openssl
      acl
      attr
      fakeroot
      libudev0-shim

      # X11 libraries
      libICE
      libSM
      libX11
      libXScrnSaver
      libXcomposite
      libXcursor
      libXdamage
      libXext
      libXfixes
      libXft
      libXi
      libXinerama
      libXmu
      libXrandr
      libXrender
      libXt
      libXtst
      libXxf86vm
      libxcb
      libxkbfile
      libxshmfence
    ];
  };
}
