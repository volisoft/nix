{ config, lib, pkgs, ... }:

{
  # imports = [ ./nix ./nix/home-manager.nix ];
  systemd.network.enable = true;

  networking.hostName = "backup-rpi4";

  users.extraUsers = { dev = { isNormalUser = true; }; };

  services = {
    openssh = {
      enable = true;
      permitRootLogin = "yes";
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILNmvSSbggdDCozdmL4awN9rZUd54CyCHz6AVsXT1yeM dev@devmachine"
  ];
}
