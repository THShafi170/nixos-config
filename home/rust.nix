{ pkgs, ... }:

{
  # Manages ~/.cargo/config.toml declaratively.
  # Linker binaries referenced here are provided by system-devenv.nix.
  home.file.".cargo/config.toml".text = ''
    [build]
    target = "x86_64-unknown-linux-gnu"

    [net]
    # Avoids libgit2 ABI issues on NixOS
    git-fetch-with-cli = true

    # Linux
    [target.x86_64-unknown-linux-gnu]
    linker = "clang"
    rustflags = ["-C", "link-arg=-fuse-ld=mold"]

    [target.x86_64-unknown-linux-musl]
    linker = "musl-gcc"

    # Windows (MinGW)
    [target.x86_64-pc-windows-gnu]
    linker = "x86_64-w64-mingw32-gcc"
    ar     = "x86_64-w64-mingw32-ar"

    [target.i686-pc-windows-gnu]
    linker = "i686-w64-mingw32-gcc"
    ar     = "i686-w64-mingw32-ar"

    [profile.dev]
    opt-level = 0
    debug = true
    split-debuginfo = "unpacked"

    [profile.release]
    opt-level = 3
    lto = "thin"
    codegen-units = 1
  '';
}
