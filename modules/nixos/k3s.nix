{ config, pkgs, ... }:

{
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = toString [
      "--write-kubeconfig-mode=0644" 
    ];
  };
  
  environment.systemPackages = with pkgs; [
    docker
    k3s
    kubectl
    kubernetes-helm
    runc
    nvidia-container-toolkit
    libnvidia-container
  ];  

  environment.etc."k3s/containerd/config.toml.tmpl".text = ''
    {{ template "base" . }}

    [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.nvidia]
      privileged_without_host_devices = false
      runtime_engine = ""
      runtime_root = ""
      runtime_type = "io.containerd.runc.v2"
  '';

  systemd.services.k3s.path = with pkgs; [
    nvidia-container-toolkit
    libnvidia-container
  ];

  systemd.services.containerd.path = with pkgs; [
    containerd
    runc
    nvidia-container-toolkit
    libnvidia-container
  ];

  virtualisation = {
    containerd = {
      enable = true;
    };
    docker = {
      enable = true;
      enableNvidia = true;
    };
  };
}
