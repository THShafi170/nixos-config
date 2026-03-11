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
      backend = "firewalld";
      checkReversePath = "loose";
      extraCommands = ''
        firewall-cmd --zone=trusted --add-interface=waydroid0
        firewall-cmd --zone=trusted --add-port=53/udp
        firewall-cmd --zone=trusted --add-port=67/udp
        firewall-cmd --zone=trusted --add-forward
        firewall-cmd --zone=trusted --add-masquerade
      '';
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
    protonvpn-gui
    wget
    wireguard-tools
  ];
}
