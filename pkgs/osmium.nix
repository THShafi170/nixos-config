{
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  autoPatchelfHook,
  cairo,
  cups,
  dbus,
  expat,
  fetchurl,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  lib,
  libX11,
  libXScrnSaver,
  libXcomposite,
  libXcursor,
  libXdamage,
  libXext,
  libXfixes,
  libXi,
  libXrandr,
  libXrender,
  libXtst,
  libappindicator-gtk3,
  libcxx,
  libdbusmenu,
  libdrm,
  libgbm,
  libglvnd,
  libnotify,
  libpulseaudio,
  libunity,
  libuuid,
  libva,
  libxcb,
  libxshmfence,
  makeDesktopItem,
  makeShellWrapper,
  nspr,
  nss,
  pango,
  pipewire,
  speechd-minimal,
  stdenv,
  systemdLibs,
  wayland,
  wrapGAppsHook3,
  withTTS ? true,
  enableAutoscroll ? false,
  commandLineArgs ? "",
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "osmium";
  version = "0.0.16-alpha";

  src = fetchurl {
    url = "https://updater.osmium.chat/Osmium-0.0.16-alpha-x64.tar.gz";
    hash = "sha256-dMOyZ9oPVnLt6MHeQwsMJ03wgvaKzalynwAL/PRfI28=";
  };

  nativeBuildInputs = [
    alsa-lib
    autoPatchelfHook
    cups
    libdrm
    libuuid
    libXdamage
    libX11
    libXScrnSaver
    libXtst
    libxcb
    libxshmfence
    libgbm
    nss
    wrapGAppsHook3
    makeShellWrapper
  ];

  dontWrapGApps = true;

  libPath = lib.makeLibraryPath (
    [
      libcxx
      systemdLibs
      libpulseaudio
      libdrm
      libgbm
      stdenv.cc.cc
      alsa-lib
      atk
      at-spi2-atk
      at-spi2-core
      cairo
      cups
      dbus
      expat
      fontconfig
      freetype
      gdk-pixbuf
      glib
      gtk3
      libglvnd
      libnotify
      libX11
      libXcomposite
      libunity
      libuuid
      libva
      libXcursor
      libXdamage
      libXext
      libXfixes
      libXi
      libXrandr
      libXrender
      libXtst
      nspr
      libxcb
      pango
      pipewire
      libXScrnSaver
      libappindicator-gtk3
      libdbusmenu
      wayland
    ]
    ++ lib.optionals withTTS [ speechd-minimal ]
  );

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,opt/osmium,share/pixmaps,share/icons/hicolor/256x256/apps}
    mv * $out/opt/osmium

    chmod +x $out/opt/osmium/osmium
    patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} \
        $out/opt/osmium/osmium

    wrapProgramShell $out/opt/osmium/osmium \
        "''${gappsWrapperArgs[@]}" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
        ${lib.strings.optionalString withTTS ''
          --run 'if [[ "''${NIXOS_SPEECH:-default}" != "False" ]]; then NIXOS_SPEECH=True; else unset NIXOS_SPEECH; fi' \
          --add-flags "\''${NIXOS_SPEECH:+--enable-speech-dispatcher}" \
        ''} \
        ${lib.strings.optionalString enableAutoscroll "--add-flags \"--enable-blink-features=MiddleClickAutoscroll\""} \
        --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/" \
        --prefix LD_LIBRARY_PATH : ${finalAttrs.libPath}:$out/opt/osmium \
        --add-flags ${lib.escapeShellArg commandLineArgs}

    ln -s $out/opt/osmium/osmium $out/bin/
    # Without || true the install would fail on case-insensitive filesystems
    ln -s $out/opt/osmium/osmium $out/bin/osmium || true

    ln -s $out/opt/osmium/resources/assets/icons/256x256.png $out/share/pixmaps/osmium.png
    ln -s $out/opt/osmium/resources/assets/icons/256x256.png $out/share/icons/hicolor/256x256/apps/osmium.png

    ln -s "$desktopItem/share/applications" $out/share/

    runHook postInstall
  '';

  desktopItem = makeDesktopItem {
    name = "osmium";
    exec = "osmium";
    icon = "osmium";
    desktopName = "Osmium";
    genericName = "A globally distributed community messaging and voice/video platform.";
    categories = [
      "Network"
      "InstantMessaging"
    ];
    mimeTypes = [ "x-scheme-handler/osmium" ];
    startupWMClass = "osmium";
  };

  meta = {
    description = "A globally distributed community messaging and voice/video platform.";
    downloadPage = "https://osmium.chat/download";
    homepage = "https://osmium.chat/";
    license = lib.licenses.unfree;
    mainProgram = "osmium";
    maintainers = with lib.maintainers; [
      itsfolf
    ];
    platforms = [
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
