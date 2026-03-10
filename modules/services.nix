{
  pkgs,
  ...
}:

{
  # Location
  location.provider = "geoclue2";

  # Enable power management
  powerManagement.enable = true;

  services = {
    # Services
    fstrim.enable = true;
    btrfs.autoScrub.enable = true;
    fwupd.enable = true;
    irqbalance.enable = true;
    thermald.enable = true;
    dbus.implementation = "broker";
    accounts-daemon.enable = true;
    userborn.enable = true;
    envfs.enable = true;

    # UDisks
    udisks2 = {
      enable = true;
      mountOnMedia = true;
    };

    # Geoclue2
    geoclue2 = {
      enable = true;
      geoProviderUrl = "https://api.beacondb.net/v1/geolocate";
      submissionUrl = "https://api.beacondb.net/v2/geosubmit";
      submissionNick = "geoclue";

      appConfig = {
        gammastep = {
          isAllowed = true;
          isSystem = false;
        };
        vivaldi = {
          isAllowed = true;
          isSystem = false;
        };
      };
    };

    # Printing services
    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    # seatd
    seatd = {
      enable = true;
      user = "tenshou170";
    };

    # Desktop services
    tumbler.enable = true;

    # X Server
    xserver = {
      enable = false;
      wacom.enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
      excludePackages = with pkgs; [
        xterm
      ];
    };
  };
}
