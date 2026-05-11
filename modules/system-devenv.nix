{
  inputs,
  lib,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    # Nix
    nixd
    nixfmt
    nixfmt-tree

    # Android
    androidenv.androidPkgs.androidsdk
    androidenv.androidPkgs.all.packages.ndk.v27_3_13750724
    androidenv.androidPkgs.platform-tools

    # Rust
    # rustup is the sole toolchain manager. Fenix components must not be added
    # here — they shadow rustup's proxies in /run/current-system/sw/bin/.
    # rust-analyzer is also omitted: install via `rustup component add rust-analyzer`
    # so it stays in sync with the active toolchain.
    rustup

    # Python
    (python3.withPackages (
      ps: with ps; [
        pip
        pytest
        requests
        numpy
        pandas
        virtualenv
      ]
    ))
    uv
    ruff
    pyright

    # C / C++
    gcc
    clang
    clang-tools
    gdb
    cmake
    ninja
    gnumake
    mold
    ccache
    pkg-config
    openssl

    # Java
    jdk21
    maven
    gradle

    # JavaScript / Node.js
    nodejs_24
    pnpm

    # Go
    go
    gopls
    delve

    # MinGW-w64
    pkgsCross.mingwW64.stdenv.cc
    pkgsCross.mingw32.stdenv.cc

    # DotNET
    dotnet-sdk
    mono
    csharp-ls

    # Zig
    zig
    zls

    # General tools
    binwalk
    devenv
    nh
    nix-output-monitor
    cachix
    jq
    tree
    ripgrep
    fd
    fakeroot
    libcap
    sqlite

    # Editors
    zed-editor-fhs
    kiro-fhs
    antigravity-fhs

    # CLI tools
    nh
    nix-output-monitor
    jq
    tree
    ripgrep
    fakeroot
    libcap
    sqlite
    nix-search-tv
  ];

  programs = {
    java = {
      enable = true;
      package = pkgs.jdk17;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
  };

  # Android SDK License
  nixpkgs.config.android_sdk.accept_license = true;

  environment.sessionVariables = {
    # Rust
    RUST_BACKTRACE = "1";
    RUSTUP_HOME = "$HOME/.rustup";
    CARGO_HOME = "$HOME/.cargo";
    PKG_CONFIG_ALLOW_CROSS = "1";
    XWIN_CACHE_DIR = "$HOME/.cache/cargo-xwin";

    # .NET
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";
    DOTNET_ROOT = "${pkgs.dotnet-sdk}";

    # Java
    JAVA_HOME = "${pkgs.jdk17}";

    # C/C++
    CC = lib.getExe' pkgs.gcc "gcc";
    CXX = lib.getExe' pkgs.gcc "g++";

    # Node
    NODE_OPTIONS = "--max-old-space-size=4096";
  };
}
