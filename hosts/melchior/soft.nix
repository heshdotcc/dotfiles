{ config, pkgs, inputs, user, base, ... }:

let
  env = inputs.env;
in
{
  imports =
    [
      ./hard.nix
      "${base.modules}/nixos/nvidia.nix"
      inputs.home-manager.nixosModules.default
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = { 
    hostName = "melchior";
  };

  time.timeZone = env.timezone; 
  
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = env.extraLocaleSettings;
  };

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
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
          ./user.nix
        ];
      };
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  programs = {
    nh = {
      enable = true;
      flake = "/home/${user}/.dotfiles";
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
    extraConfig = env.openssh_extra;
  };

  networking.firewall.allowedTCPPorts = env.tcp_ports;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
