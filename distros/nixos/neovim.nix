pkgs: with pkgs; {
  enable = true;
  viAlias = true;
  vimAlias = true;
  extraPackages = with pkgs; [
	lua-language-server
  ];
  # extraConfig = ''
  # set number relativenumber
  # '';
  plugins = with pkgs.vimPlugins; [
  	telescope-fzf-native-nvim
  ];
}

