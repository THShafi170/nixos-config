{
  pkgs,
  ...
}:

{
  # Network configuration
  networking = {
    wireless.iwd.enable = true;
    firewall = {
      enable = true;
      checkReversePath = "loose";
      # Waydroid needs full trust on its virtual interface
      trustedInterfaces = [ "waydroid0" ];
    };
    useDHCP = false;
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
      plugins = with pkgs; [
        networkmanager-l2tp
        networkmanager-openconnect
        networkmanager-openvpn
        networkmanager-vpnc
      ];
    };
    resolvconf.enable = true;
    mihoyo-telemetry.block = true;
  };

  # SSH service
  services.openssh.enable = true;

  # Network utilities
  environment.systemPackages = with pkgs; [
    curl
    dhcpcd
    dnsmasq
    networkmanagerapplet
    openvpn
    openvpn3
    proton-vpn
    wget
    wireguard-tools
  ];
}
