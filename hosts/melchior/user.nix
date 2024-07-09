{ config, pkgs, inputs, user, base, ... }:

{
  imports = [
    "${base.modules}/home/shell.nix"
  ];

  home.username = "${user}";
  home.homeDirectory = "/home/${user}";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    git
    htop
    nushell
    ripgrep
    sops
    tree
    zoxide
    inputs.ownpkgs.packages.${pkgs.system}.lunarvim
  ];

  home.file = {
    ".config" = {
      recursive = true;
      source = "${base.modules}/home/.config";
    };
  };

  home.sessionVariables = {
    EDITOR = "lvim";
    SHELL = "${pkgs.nushell}/bin/nu";
    KUBECONFIG = "/home/${user}/.config/kube/config";
  };

  programs.home-manager.enable = true;
}
