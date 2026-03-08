{
  ...
}:

{
  # Basic home configuration
  home = {
    username = "tenshou170";
    homeDirectory = "/home/tenshou170";
    stateVersion = "26.05";
  };

  # Enable home-manager
  programs.home-manager.enable = true;

  # XDG user directories configuration
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  # Git
  programs = {
    git = {
      enable = true;
      lfs.enable = true;
      settings.user = {
        name = "Tawsif Hossain Shafi";
        email = "thshafi170@gmail.com";
      };
    };
    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
    };
  };
}
