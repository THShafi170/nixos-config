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
    stateVersion = "26.11";
  };

  # Enable home-manager
  programs.home-manager.enable = true;

  # XDG user directories configuration
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  # Programs configuration
  programs = {
    # Oh My Posh
    oh-my-posh = {
      enable = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      useTheme = "amro";
    };
    # Vicinae
    vicinae = {
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
        case-converter
        color-converter
        fuzzy-files
        github
        kde-system-settings
        nix
        power-profile
        process-manager
        ssh
      ];
    };
    # Git
    git = {
      enable = true;
      lfs.enable = true;
      settings = {
        user = {
          name = "Tenshou Zmeyev";
          email = "tenshou170@gmail.com";
        };
        core.editor = "nano";
      };
    };
    # GitHub CLI
    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
    };
  };
}
