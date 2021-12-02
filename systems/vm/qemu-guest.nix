{ config, ... }: {
  # No password for sudo
  security.sudo.wheelNeedsPassword = false;
  virtualisation.docker.enable = true;
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
  systemd.network = {
    networks = {
      enable = true;
      "enp0s9" = {
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
    hostName = "devbox";
    domain = "id.volisoft.dev";
    hostId = "49e32584";
  };
}
