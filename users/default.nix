{
  pkgs,
  ...
}:

{
  users.users.tenshou170 = {
    isNormalUser = true;
    shell = pkgs.fish;
    createHome = true;
    name = "tenshou170";
    description = "Tenshou Zmeyev";
    home = "/home/tenshou170";
    extraGroups = [
      "adbusers"
      "adm"
      "audio"
      "input"
      "kmem"
      "kvm"
      "libvirtd"
      "mem"
      "networkmanager"
      "podman"
      "power"
      "proc"
      "qemu"
      "qemu-libvirtd"
      "sys"
      "tenshou170"
      "tss"
      "users"
      "wheel"
    ];
  };
}
