{ config, lib, pkgs, ... }:

{
  # nvidia-vaapi-driver
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    graphics.enable = true;
    opengl = {
      enable = true;
      driSupport32Bit = true;
    };
    nvidia = {
      nvidiaPersistenced = true;
      modesetting.enable = true;
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      powerManagement = {
        enable = false;
        finegrained = false;
      };
    };
    nvidia-container-toolkit.enable = true;
  };

  environment.systemPackages = with pkgs; [
    config.boot.kernelPackages.nvidiaPackages.stable
    cudatoolkit
  ];

  boot.extraModulePackages = [ config.boot.kernelPackages.nvidiaPackages.stable ];
}
