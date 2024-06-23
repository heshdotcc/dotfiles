{ config, pkgs, ... }:

{
  programs = {
    broot = {
      enable = true;
      enableNushellIntegration = true;
      settings.modal = true;
    };
    fzf = {
      enable = true;
      tmux.enableShellIntegration = true;
    };
    nushell = {
      enable = true;
    };
    tmux = {
      enable = true;
      mouse = true;
    };
  };
}
