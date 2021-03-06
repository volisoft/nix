{ config, lib, pkgs, modulesPath, ... }: {

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.loader.raspberryPi.firmwareConfig = "dtparam=sd_poll_once=on";
  boot.consoleLogLevel = lib.mkDefault 7;
  # Required for nix-fort
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  systemd.network = {
    enable = true;
    networks = {
      "eth0" = {
        networkConfig = {
          DHCPServer = true;
          IPv6SendRA = true;
          LLMNR = true;
        };
        dhcpServerConfig = {
          EmitDNS = true;
          EmitNTP = true;
        };
      };
    };
  };

  networking = {
    hostName = "backup-rpi4";
    hostId = "50e1a69b";
    defaultGateway = "192.168.1.1";
    wireless = {
      enable = true;
      interfaces = [ "wlan0" ];
      networks = {
        # generated by wpa_passphrase Amber password
        Amber = {
          pskRaw =
            "099163c36ec27c3d4b5e9d8b7083ee06a415089f78bdd879bcd8c6b4b157e2a9";
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [ tcpdump git vim htop zstd nixfmt ];

  services = {
    openssh = {
      enable = true;
      permitRootLogin = "yes";
    };
    chrony.enable = true;
  };

  users = {
    users = {
      root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKyoMfgUym3E2wsHyWEIJVPDXvGB6U6t/ciSkFtnfSeB dev@devmachine"
      ];
      dev = {
        isNormalUser = true;
        password = "password";
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKyoMfgUym3E2wsHyWEIJVPDXvGB6U6t/ciSkFtnfSeB dev@devmachine"
        ];
      };
    };
  };

  time.timeZone = "UTC";

  swapDevices = [ ];
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It???s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
