{
  pkgs,
  ...
}:

{
  # Sudo configuration
  security.sudo.extraConfig = ''
    Defaults env_reset,pwfeedback
    root ALL=(ALL:ALL) ALL
    tenshou170 ALL=(ALL:ALL) ALL
  '';

  # System packages
  environment.systemPackages = with pkgs; [
    # Fish plugins
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fishPlugins.hydro
    fishPlugins.grc

    # Zsh plugins
    zsh
    zsh-completions
    zsh-autosuggestions
    zsh-history-substring-search
    zsh-syntax-highlighting

    # Utilities
    bat
    eza
    fastfetch
    fd
    fzf
    grc
    msedit
    nano
    neovim
    pywal
    pciutils
    vim
    zenity
  ];

  # Zsh configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    # History settings
    histSize = 10000;
    histFile = "$HOME/.zsh_history";

    # Oh My Zsh
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "docker"
        "kubectl"
      ];
      theme = "alanpeabody";
    };
  };

  # Fish shell
  programs.fish = {
    enable = true;
    vendor = {
      config.enable = true;
      functions.enable = true;
      completions.enable = true;
    };

    # Fish config
    shellInit = ''
      set -g fish_greeting ""
      set -g fish_key_bindings fish_vi_key_bindings
    '';
  };
}
