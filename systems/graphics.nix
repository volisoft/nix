{ config, lib, pkgs, ... }:
with lib; {
  networking = {
    networkmanager.enable = true;
    wireless.enable = mkForce false;
  };
  powerManagement.enable = true;
  hardware.pulseaudio.enable = true;

  services.xserver = {
    enable = true;
    layout = "us";
    displayManager = {
      lightdm.enable = true;
      autoLogin.enable = true;
      autoLogin.user = "dev";
    };
    desktopManager.xfce.enable = true;
  };
}
