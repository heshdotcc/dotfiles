{ pkgs, lib, ... }:

let
  containerdTemplate = pkgs.writeText "config.toml.tmpl" (lib.readFile ./config.toml.tmpl);
in
{
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = toString [
      "--write-kubeconfig-mode=0644" 
    ];
  };
  
  environment.systemPackages = with pkgs; [
    k3s
    kns
    kubectl
    kubernetes-helm
    kubevirt
    docker
    runc
  ];  

  virtualisation = {
    docker = {
      enable = true;
      enableNvidia = true;
    };
  };

  system.activationScripts.writeContainerdConfigTemplate = ''
    cp ${containerdTemplate} /var/lib/rancher/k3s/agent/etc/containerd/config.toml.tmpl
  '';
}
