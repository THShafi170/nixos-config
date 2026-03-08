{
  inputs,
  lib,
  pkgs,
  ...
}:

{

  # Development environment configuration
  environment.systemPackages = with pkgs; [
    # Rust development tools
    (inputs.fenix.packages.${pkgs.stdenv.hostPlatform.system}.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rust-std"
      "rustc"
      "rustfmt"
    ])
    rustup
    rust-analyzer

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

    # Core development tools
    jdk21
    maven
    gradle
    gcc
    ninja
    ccache
    cachix
    clang
    cmake
    devenv
    gnumake
    gdb
    dotnet-sdk
    mono
    pkg-config

    # Code editors and IDEs
    vscode-fhs
    antigravity-fhs

    # Command line tools
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

    # JavaScript/Node.js development
    nodejs_24
    pnpm
  ];

  # Enable some development tools
  programs = {
    # Enable Java
    java = {
      enable = true;
      package = pkgs.jdk;
    };
    # Enable direnv
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
  };

  # Set development environment variables
  environment.sessionVariables = {
    # Rust
    RUST_BACKTRACE = "1";
    CARGO_HOME = "$HOME/.cargo";
    CARGO_TARGET_DIR = "$HOME/.cache/cargo-target";

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
