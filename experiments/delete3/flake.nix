{
  description = ''
        Modified to use flakes from
        https://www.haskellforall.com/2020/11/how-to-use-nixos-for-lightweight.html.
    nix-shell -p nixUnstable --run 'sudo nixos-install --flake github:kanashimia/nixos#literal-potato'
      '';
  inputs = {
    # nixpkgs.url =
    #   "https://github.com/NixOS/nixpkgs/archive/58f9c4c7d3a42c912362ca68577162e38ea8edfb.tar.gz";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
    # "github:nixos/nixpkgs";
  };
  outputs = { self, nixpkgs }: {
    packages.aarch64-linux.hello = nixpkgs.legacyPackages.aarch64-linux.hello;
    # In shell:
    # nix run '.#test.vm'
    # error: unable to execute '/nix/store/wq12nsfnlj0x0vz1z67gzrxc2z9ahq4w-nixos-vm/bin/nixos-vm': No such file or directory
    # This path is incorrect. Replace it with:
    # /nix/store/wq12nsfnlj0x0vz1z67gzrxc2z9ahq4w-nixos-vm/bin/run-nixos-vm
    # Could not access KVM kernel module: No such file or directory
    # qemu-system-aarch64: failed to initialize kvm: No such file or directory
    # This happens when KVM kernel module is not loaded (e.g. in a virtual machine).
    # In that case run QEMU in emulation mode:
    # /nix/store/wq12nsfnlj0x0vz1z67gzrxc2z9ahq4w-nixos-vm/bin/run-nixos-vm -cpu max -machine accel=tcg,gic-version=max
    # /nix/store/wq12nsfnlj0x0vz1z67gzrxc2z9ahq4w-nixos-vm/bin/run-nixos-vm -cpu max -smp 8 -machine accel=tcg,gic-version=max
    packages.aarch64-linux.test = let
      db = {
        database = "postgres";
        schema = "api";
        table = "todos";
        username = "authenticator";
        password = "mysecretpassword";
        webRole = "web_anon";
        flake = false;
      };
    in import "${nixpkgs}/nixos" {
      system = "aarch64-linux";

      configuration = { config, pkgs, ... }: {
        # Open the default port for `postgrest` in the firewall
        networking.firewall.allowedTCPPorts = [ 3000 ];

        services.postgresql = {
          enable = true;

          initialScript = pkgs.writeText "initialScript.sql" ''
            create schema ${db.schema};

            create table ${db.schema}.${db.table} (
              id serial primary key,
              done boolean not null default false,
              task text not null,
              due timestamptz
            );

            insert into ${db.schema}.${db.table} (task) values
              ('finish tutorial 0'), ('pat self on back');

            create role ${db.webRole} nologin;

            grant usage on schema ${db.schema} to ${db.webRole};
            grant select on ${db.schema}.${db.table} to ${db.webRole};

            create role ${db.username} inherit login password '${db.password}';
            grant ${db.webRole} to ${db.username};
          '';
        };

        users = {
          mutableUsers = false;
          groups = { authenticator = { }; };

          users = {
            # For ease of debugging the VM as the `root` user
            root.password = "";

            # Create a system user that matches the database user so that we
            # can use peer authentication.  The tutorial defines a password,
            # but it's not necessary.
            "${db.username}" = {
              isSystemUser = true;
              group = "authenticator";
            };
          };
        };

        systemd.services.postgrest = {
          wantedBy = [ "multi-user.target" ];

          after = [ "postgresql.service" ];

          script = let
            configuration = pkgs.writeText "tutorial.conf" ''
              db-uri = "postgres://${db.username}:${db.password}@localhost:${
                toString config.services.postgresql.port
              }/${db.database}"
              db-schema = "${db.schema}"
              db-anon-role = "${db.username}"
            '';

          in ''
            ${pkgs.haskellPackages.postgrest}/bin/postgrest ${configuration}
          '';

          serviceConfig.User = db.username;
        };

        # Uncomment the next line for running QEMU on a non-graphical system
        # virtualisation.graphics = false;
      };
    };
    packages.aarch64-linux.devShell.aarch64-linux =
      with nixpkgs.legacyPackages.aarch64-linux;
      mkShell { buildInputs = [ qemu ]; };
  };
}
