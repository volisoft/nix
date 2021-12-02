{ config, lib, pkgs, ... }: {
  environment.systemPackages = with pkgs; [ tcpdump git vim zstd nixfmt xclip ];
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
