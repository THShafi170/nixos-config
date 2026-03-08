{
  pkgs,
  ...
}:

{
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
    python3Packages.guestfs

    # Tools
    distrobox
    swtpm
  ];
}
