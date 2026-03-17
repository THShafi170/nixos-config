{
  pkgs,
  ...
}:

{
  # Fix virt-manager: enable libguestfs introspection and system tray on Wayland (Plasma 6)
  nixpkgs.overlays = [
    (final: prev: {
      virt-manager = prev.virt-manager.overrideAttrs (old: {
        preFixup = (old.preFixup or "") + ''
          gappsWrapperArgs+=(
            "--prefix" "PYTHONPATH" ":"
            "${final.libguestfs-with-appliance}/lib/${final.python3.libPrefix}/site-packages"
            "--unset" "WAYLAND_DISPLAY"
          )
        '';
      });
    })
  ];

  # Virtualisation
  virtualisation = {
    # libvirt
    libvirtd = {
      enable = true;
      qemu = {
        runAsRoot = true;
        vhostUserPackages = [ pkgs.virtiofsd ];
        swtpm.enable = true;
      };
    };

    spiceUSBRedirection.enable = true;
    containers.enable = true;

    waydroid = {
      enable = true;
      package = pkgs.waydroid-nftables;
    };

    # Podman
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings = {
        dns_enabled = true;
        ipv6_enabled = true;
      };
    };
  };

  # virt-manager
  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    # QEMU
    qemu
    qemu_kvm
    qemu-user
    qemu-utils
    OVMFFull

    # Guest management
    libguestfs-with-appliance

    # Tools
    distrobox
    swtpm
  ];
}
