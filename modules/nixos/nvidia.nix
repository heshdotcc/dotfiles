{ config, lib, pkgs, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    graphics.enable = true;
    opengl.enable = true;
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  environment.systemPackages = with pkgs; [
    config.boot.kernelPackages.nvidiaPackages.stable
    cudatoolkit
  ];

  boot.extraModulePackages = [ config.boot.kernelPackages.nvidiaPackages.stable ];
}
