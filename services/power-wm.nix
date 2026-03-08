{
  ...
}:

{
  # Power management
  services = {
    logind.settings.Login = {
      SleepOperation = "suspend-then-hibernate";
      HandlePowerKey = "lock";
      HandlePowerKeyLongPress = "poweroff";
      HandleLidSwitch = "suspend-then-hibernate";
    };

    upower = {
      enable = true;
      percentageLow = 20;
      percentageCritical = 10;
      percentageAction = 6;
      criticalPowerAction = "Hibernate";
    };
  };
}
