{
  inputs,
  lib,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    # Rust
    # rustup is the sole toolchain manager. Fenix components must not be added
    # here — they shadow rustup's proxies in /run/current-system/sw/bin/.
    # rust-analyzer is also omitted: install via `rustup component add rust-analyzer`
    # so it stays in sync with the active toolchain.
    rustup
    cargo-nextest

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

    # Go
    go
    gopls
    delve

    # Windows cross-compilation via MinGW
    # Places x86_64-w64-mingw32-gcc and friends in /run/current-system/sw/bin/,
    # which ~/.cargo/config.toml (managed by rust.nix) references directly.
    pkgsCross.mingwW64.stdenv.cc
    wine64

    # Core development tools
    jdk21
    maven
    gradle
    gcc
    ninja
    ccache
    cachix
    clang # used as the mold linker driver for Linux targets
    cmake
    devenv
    gnumake
    gdb
    dotnet-sdk
    mono
    mold
    pkg-config
    openssl

    # Editors
    vscode-fhs
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

    # Language servers and formatters
    nixd
    nixfmt
    nixfmt-tree
    clang-tools
    typescript-language-server
    vtsls
    nodePackages.vscode-langservers-extracted
    yaml-language-server
    taplo
    marksman

    # JavaScript / Node.js
    nodejs_24
    pnpm
  ];

  programs = {
    java = {
      enable = true;
      package = pkgs.jdk;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
  };

  environment.sessionVariables = {
    # Rust
    RUST_BACKTRACE = "1";
    RUSTUP_HOME = "$HOME/.rustup";
    CARGO_HOME = "$HOME/.cargo";
    CARGO_TARGET_DIR = "$HOME/.cache/cargo-target";
    PKG_CONFIG_ALLOW_CROSS = "1";

    # .NET
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";
    DOTNET_ROOT = "${pkgs.dotnet-sdk}";

    # Java
    JAVA_HOME = "${pkgs.jdk}";

    # C/C++
    CC = lib.getExe' pkgs.gcc "gcc";
    CXX = lib.getExe' pkgs.gcc "g++";

    # Node
    NODE_OPTIONS = "--max-old-space-size=4096";
  };
}
