{ config, lib, pkgs, ... }:

{
  # nvidia-vaapi-driver
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    graphics.enable = true;
    opengl.enable = true;
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    nvidia-container-toolkit.enable = true;
  };

  environment.systemPackages = with pkgs; [
    config.boot.kernelPackages.nvidiaPackages.stable
    cudatoolkit
  ];

  boot.extraModulePackages = [ config.boot.kernelPackages.nvidiaPackages.stable ];
}
