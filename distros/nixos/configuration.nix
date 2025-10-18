# Edit this configuration file to define what should be installed on

# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
	# Make sure you have already added the channel before building
	<home-manager/nixos>
    ];

  # Bootloader.
    boot = {
	kernelPackages = pkgs.linuxPackages_latest;
	initrd.kernelModules = [];
	loader = {
        	efi = {
                	canTouchEfiVariables = true;
                	efiSysMountPoint = "/boot/efi";
        	};
        	grub = {
			enable = true;
			efiSupport = true;
			devices = ["nodev"];
			useOSProber = true;
			configurationLimit = 5;
		};
		timeout = 5;
	    };
  };

 # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = true;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = false;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
	# Make sure to use the correct Bus ID values for your system!
	sync.enable = true; # turn off for option b offload
	intelBusId = "PCI:0:2:0";
	nvidiaBusId = "PCI:1:0:0";
	# offload = {
	# 	enable = true;
	# 	enableOffloadCmd = true;
	# };
};

  };
  networking.hostName = "dropped-nix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the GNOME Desktop Environment.
  services.xserver.videoDrivers = ["nvidia"]; # THis is needed for wayland or xorg independent of gnome
 security.polkit.enable = true;
 systemd = {
  user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
  services.gnome.gnome-keyring.enable = true;
  # Hyprland

  xdg.portal.enable = true; # probably not needed
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; # added for flatpak
  xdg.portal.config.common.default = "gtk"; # added for flatpak

  programs.hyprland = {
	enable = true;
	enableNvidiaPatches = true;
	xwayland.enable = true;
	portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };
  # Get GTK to Work (first step)
  programs.dconf.enable = true;

  environment.sessionVariables = {
	WLR_NO_HARDWARE_CURSORS = "1";
  	NIXOS_OZONE_WL = "1";

  };

  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "nodeadkeys";
  };

  # Configure console keymap
  console.keyMap = "de-latin1-nodeadkeys";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  # hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Allow swaylock to deal with logins
  security.pam.services.swaylock = {
	text = ''
		auth include login
		'';
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Flatpak support
  services.flatpak.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.holmes = {
    isNormalUser = true;
    description = "Martin Holmes";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
    initialPassword = "password";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  neovim 
  btop
  git
  google-chrome
  firefox
  lshw
  alacritty
  tree
  eza
  fish
  starship
  alacritty
  loupe # gnome 45 image viewer
  font-manager
  gparted
  # gnome stuff
  # gnome.gnome-tweaks gnomeExtensions.dash-to-dock gnomeExtensions.forge gnomeExtensions.blur-my-shell
  # gnomeExtensions.just-perfection
  # gradience

  # Hyprland Stuff
  killall
  swayidle
  eza
  waybar
  swww
  xfce.thunar
  polkit_gnome
  gnome.gnome-keyring
  wofi
  pywal
  grim
  slurp
  wl-clipboard
  cliphist
  wlogout
  mako
  libnotify # needed for dunst/mako
  swaylock-effects
  networkmanagerapplet
  brightnessctl
  pamixer
  jq # for json processing in scripts
  # nwg-bar
  # COSMIC DE
  cosmic-edit
  # cosmic-comp
  # cosmic-panel
  # cosmic-greeter
  cosmic-icons
  # cosmic-applets
  # cosmic-settings
  # gnomeExtensions.dash-to-dock-for-cosmic
  # gnomeExtensions.pop-launcher-super-key

  #  wget

  # neovim to work
  python3
  fzf
  ripgrep
  # libgcc
  # gccgo13
  # gnumake
  # gnumake42
  # makeself
  # cmake
  nodejs
  unzip
  ];
  
  # nerdfonts

  fonts.packages = with pkgs; [
	  fira
	  noto-fonts
	  font-awesome
	  (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "Hack"]; })
  ];

  fonts.fontDir.enable = true; # fix flatpak fonts

  # Thunar plugins
  programs.thunar.plugins = with pkgs.xfce; [
  	thunar-archive-plugin
	thunar-volman
  ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
 services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  # Flakes
  # nix = {
  # 	package = pkgs.nixFlakes;
  #	extraOptions = "experimental-features = nix-command flakes";
  # 	};

  home-manager.users.holmes = { config, pkgs, ... }: {
	programs.home-manager.enable = true;
  	nixpkgs.config.allowUnfree = true;
	home.packages = with pkgs; [
	];	
	home.stateVersion = "23.11";
	gtk.enable = true;
	gtk.cursorTheme.package = pkgs.volantes-cursors;
	gtk.cursorTheme.name = "volantes_cursors";
	gtk.cursorTheme.size = 24;
	gtk.theme.package = pkgs.adw-gtk3;
	gtk.theme.name = "adw-gtk3-dark";
	gtk.iconTheme.package = pkgs.tela-circle-icon-theme;
	gtk.iconTheme.name = "Tela-circle-dark";
	gtk.font.package = pkgs.fira-code-nerdfont;
	gtk.font.name = "Fira Sans Condensed";
	gtk.gtk3.bookmarks = [
		"file:///home/holmes/Documents"
	];
	programs.neovim = import ./neovim.nix pkgs;
  };
}

