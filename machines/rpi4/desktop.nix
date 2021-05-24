{ config, lib, pkgs, ... }: {
  imports = [
    "${
      fetchTarball
      "https://github.com/NixOS/nixos-hardware/archive/936e4649098d6a5e0762058cb7687be1b2d90550.tar.gz"
    }/raspberry-pi/4"
  ];
  ########################################
  ######## Desktop #######################
  services.xserver = {
    enable = true;
    displayManager = {
      lightdm.enable = true;
      autoLogin.enable = true;
      autoLogin.user = "dev";
    };
    desktopManager.xfce.enable = true;
  };

  hardware.pulseaudio.enable = true;
  hardware.raspberry-pi."4".fkms-3d.enable = true;
  hardware.video.hidpi.enable = lib.mkDefault true; # high-resolution display
}
