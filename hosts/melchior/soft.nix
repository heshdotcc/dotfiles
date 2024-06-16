# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, user, ... }:

let
  pwd = toString ./.;
  secretsPath = "${pwd}/.env";
  env = import ./.env/default.nix;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hard.nix
      inputs.home-manager.nixosModules.default
      inputs.agenix.nixosModules.default
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.variables.RULES = "${toString secretsPath}/secrets.nix";

  age = {
    secrets = {
      "wireless".file = "${secretsPath}/wireless.age";
    };
    identityPaths = [
      "/home/he/.ssh/id_ed25519_age"
    ]; 
  };

  networking = { 
    hostName = "melchior";
    wireless = {
      enable = true;
      environmentFile = config.age.secrets.wireless.path;
      networks = {
        "WSC" = { psk = "@WSC@"; };
      };
    };
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  #networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = env.timezone; 

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_AR.UTF-8";
    LC_IDENTIFICATION = "es_AR.UTF-8";
    LC_MEASUREMENT = "es_AR.UTF-8";
    LC_MONETARY = "es_AR.UTF-8";
    LC_NAME = "es_AR.UTF-8";
    LC_NUMERIC = "es_AR.UTF-8";
    LC_PAPER = "es_AR.UTF-8";
    LC_TELEPHONE = "es_AR.UTF-8";
    LC_TIME = "es_AR.UTF-8";
  };

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "altgr-intl";
    };
  };

  users.users.${user} = {
    isNormalUser = true;
    description = "${user}";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      tmux
    ];
    openssh.authorizedKeys.keys = env.pubkeys;
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs user; };
    users = {
      ${user} = {
        imports = [
          (./user.nix)
         # inputs.self.outputs.homeManagerModules.default
        ];
      };
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    inputs.agenix.packages."${system}".default
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs = {
    nh = {
      enable = true;
      flake = "/home/${user}/.dotfiles";
    };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
    extraConfig = env.openssh_extra;
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = env.tcp_ports;
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
