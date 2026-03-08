{
  pkgs,
  ...
}:

{
  # Shared fonts
  config = {
    _module.args.sharedFonts = with pkgs; [
      # Essential fonts
      noto-fonts
      noto-fonts-color-emoji
      liberation_ttf
      dejavu_fonts
      cantarell-fonts
      jetbrains-mono
      fira-code
      fira-code-symbols
      terminus_font

      # Development fonts
      nerd-fonts.meslo-lg
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      source-code-pro

      # UI fonts
      adwaita-fonts
      font-awesome
      inter
      material-icons
      material-symbols
      powerline-fonts
      powerline-symbols

      # Language-specific fonts
      lohit-fonts.bengali
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      source-sans
      source-serif
      source-han-sans
      source-han-serif
      source-han-mono
      wqy_zenhei
    ];
  };
}
