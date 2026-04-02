{
  inputs,
  pkgs,
  ...
}:

{
  # Overlay for nix-cachyos-kernel
  nixpkgs.overlays = [
    inputs.nix-cachyos-kernel.overlays.default
  ];

  # Boot configuration
  boot = {
    loader = {
      # Using systemd-boot as bootloader
      systemd-boot = {
        enable = true;
        consoleMode = "auto";
        edk2-uefi-shell.enable = true;
      };
      efi.canTouchEfiVariables = true;
    };

    # Kernel configuration
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;

    # Essential kernel modules loaded at boot
    kernelModules = [
      "vfio-pci"
      "ntsync"
      "zram"
    ];

    # Kernel boot parameters
    kernelParams = [
      "preempt=full"
      "nowatchdog"
      "quiet"
      "splash"
      "mitigations=auto"
      "resume_offset=533760"
      "psi=1"
      "intel_iommu=on"
      "iommu=pt"
    ];

    # Kernel runtime parameters
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };

    # Hibernation & Power Management
    resumeDevice = "/dev/disk/by-uuid/73508ce6-9a32-4819-9335-ae49af24622d";

    # initrd configuration
    initrd = {
      systemd = {
        enable = true;
        fido2.enable = true;

        # Low latency settings for real-time applications
        tmpfiles.settings = {
          "10-lowlatency" = {
            "/sys/class/rtc/rtc0/max_user_freq" = {
              w.argument = "128";
            };
            "/proc/sys/dev/hpet/max-user-freq" = {
              w.argument = "128";
            };
          };
        };
      };
    };

    # Extra modprobe config
    extraModprobeConfig = ''
      options kvm_intel nested=1
      options kvm ignore_msrs=1
    '';

    # Boot splash
    plymouth = {
      enable = true;
      theme = "bgrt";
    };
  };

  # Sleep and hibernation behavior
  systemd.sleep.settings.Sleep = {
    AllowSuspendThenHibernate = "yes";
    HibernateMode = "shutdown";
    HibernateDelaySec = "60min";
  };

  # sched_ext configuration
  services.scx = {
    enable = true;
    scheduler = "scx_rustland";
  };
}
