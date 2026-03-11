{
  inputs,
  pkgs,
  vicinae,
  ...
}:

{

  # Home-Manager imports
  imports = [ vicinae.homeManagerModules.default ];

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

  #Vicinae configurations
  services.vicinae = {
    enable = true;
    package = pkgs.vicinae;
    systemd = {
      enable = true;
      autoStart = true;
      environment = {
        USE_LAYER_SHELL = 1;
      };
    };
    extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
      bluetooth
      case-converter
      chromium-bookmarks
      color-converter
      fuzzy-files
      github
      kde-system-settings
      nix
      podman
      power-profile
      process-manager
      ssh
      vscode-recents
    ];
  };
}
