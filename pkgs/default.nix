{ callPackage, lib }:

let

  # Read all files and directories in the current folder ('pkgs/')
  entries = builtins.readDir ./.;

  # Filter for regular .nix files (excluding this default.nix file)
  nixFiles = lib.filterAttrs (
    name: type: type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix"
  ) entries;

  # Filter for directories that contain their own default.nix
  nixDirs = lib.filterAttrs (
    name: type: type == "directory" && builtins.pathExists (./. + "/${name}/default.nix")
  ) entries;

  # Map the filtered files and directories to pkgs.callPackage
  packagesFromFiles = lib.mapAttrs' (
    name: _: lib.nameValuePair (lib.removeSuffix ".nix" name) (callPackage (./. + "/${name}") { })
  ) nixFiles;

  packagesFromDirs = lib.mapAttrs' (
    name: _: lib.nameValuePair name (callPackage (./. + "/${name}") { })
  ) nixDirs;

in
packagesFromFiles // packagesFromDirs
