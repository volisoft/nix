{ config, ... }: {
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  networks = {
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
}
