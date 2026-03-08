{
  pkgs,
  sharedFonts,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../modules
    ../users
  ];

  # System hostname
  networking.hostName = "X1-Yoga-2nd";

  # Time configuration
  time = {
    timeZone = "Asia/Dhaka";
    hardwareClockInLocalTime = false;
  };

  # Language and locale settings
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocales = [
      "bn_BD/UTF-8"
      "ja_JP.UTF-8/UTF-8"
      "ru_RU.UTF-8/UTF-8"
      "ru_UA.UTF-8/UTF-8"
      "zh_CN.UTF-8/UTF-8"
      "zh_TW.UTF-8/UTF-8"
    ];
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  # Console configuration
  console = {
    packages = [ pkgs.terminus_font ];
    font = "${pkgs.terminus_font}/share/consolefonts/ter-124n.psf.gz";
    keyMap = "us";
  };

  # System font configuration
  fonts = {
    fontDir = {
      enable = true;
      decompressFonts = true;
    };
    fontconfig = {
      enable = true;
      useEmbeddedBitmaps = true;
    };
    enableDefaultPackages = true;
    packages = sharedFonts;
  };

  # ZRAM configuration
  services.zram-generator = {
    enable = true;
    settings = {
      zram0 = {
        zram-size = "ram";
        compression-algorithm = "zstd";
        swap-priority = 100;
      };
    };
  };

  # System limits and optimization
  systemd = {
    user.extraConfig = "DefaultLimitNOFILE=1048576";
    services.nix-daemon.environment.TMPDIR = "/var/tmp";
  };

  # Nix configuration
  nixpkgs.overlays = [
    (final: prev: {
      inherit (prev.lixPackageSets.latest)
        colmena
        nixpkgs-review
        nix-eval-jobs
        nix-fast-build
        nix-init
        nix-update
        nurl
        ;
    })
  ];

  nix = {
    package = pkgs.lixPackageSets.latest.lix;
    settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      download-buffer-size = 1073700000;
      max-jobs = 4;
      cores = 4;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "tenshou170"
      ];
      # Binary caches
      substituters = [
        "https://attic.xuyh0120.win/lantian"
        "https://nix-community.cachix.org"
        "https://vicinae.cachix.org"
        "https://ezkea.cachix.org"
        "https://bottles-deflatpak.cachix.org"
      ];
      trusted-public-keys = [
        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
        "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
        "bottles-deflatpak.cachix.org-1:YT/o8RO4yysuReUamuL09Db+O7PA5FtsYqeRXSfbweE="
      ];
    };
  };

  # State version
  system.stateVersion = "26.05";
}
