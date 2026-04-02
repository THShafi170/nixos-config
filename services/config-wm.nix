{
  ...
}:

{
  # Services
  services = {
    # LoginD
    logind.settings.Login = {
      SleepOperation = "suspend-then-hibernate";
      HandlePowerKey = "lock";
      HandlePowerKeyLongPress = "poweroff";
      HandleLidSwitch = "suspend-then-hibernate";
    };

    # UPower
    upower = {
      enable = true;
      percentageLow = 20;
      percentageCritical = 10;
      percentageAction = 6;
      criticalPowerAction = "Hibernate";
    };

    # seatd
    seatd = {
      enable = true;
      user = "tenshou170";
    };
  };
}
