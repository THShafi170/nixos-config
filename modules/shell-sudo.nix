{
  pkgs,
  ...
}:

{
  # Sudo configuration
  security.sudo.extraConfig = ''
    Defaults env_reset,pwfeedback
  '';

  # System packages
  environment.systemPackages = with pkgs; [
    # Fish plugins
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fishPlugins.grc

    # Zsh plugins
    zsh-history-substring-search

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

    # Starship prompt (shared config from /etc/starship.toml)
    promptInit = ''
      eval "$(starship init zsh)"
    '';
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
      set -g fish_key_bindings fish_vi_key_bindings
    '';
  };
}
