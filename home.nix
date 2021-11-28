{ config, pkgs, lib, ... }:
# https://unix.stackexchange.com/questions/272660/how-to-split-etc-nixos-configuration-nix-into-separate-modules
with import ./utils/symlink.nix { inherit lib; };
let
  vscode-config = pkgs.callPackage ./apps/vscode-config.nix { };
  # Remove after aarch64-linux is added to the official pkgs derivation
  jetbrains = pkgs.callPackage ./apps/jbidea { };
  clojure = pkgs.callPackage ./apps/clojure { };
  clojure-lsp = pkgs.callPackage ./apps/clojure-lsp { };
  doom-emacs-sync = "${pkgs.writeShellScript "doom-change" ''
    export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"
    export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"
    if [ ! -d "$DOOMLOCALDIR" ]; then
      ${config.xdg.configHome}/.emacs.d/bin/doom -y install
    else
      ${config.xdg.configHome}/.emacs.d/bin/doom -y sync -u
    fi
  ''}";
in {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "dev";
  home.homeDirectory = "/home/dev";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.09";

  home = {
    # Doom Emacs config
    activation.xdg = symlink "${config.xdg.configHome}/.emacs.d"
      "${config.home.homeDirectory}/.emacs.d";
    sessionPath = [ "${config.xdg.configHome}/.emacs.d/bin" ];
    sessionVariables = {
      DOOMDIR = "${config.xdg.configHome}/.doom.d";
      DOOMLOCALDIR = "${config.xdg.configHome}/.doom-local";
    };

    # Syncthing
    file.".config/syncthing/config.xml".source = ./apps/syncthing/config.xml;
    file."x/.stignore".source = ./apps/syncthing/.stignore;
    file.".config/syncthingtray.ini".source =
      ./apps/syncthing/syncthingtray.ini;

    # VSCode config
    file.".config/Code/User/settings.json".text =
      builtins.toJSON vscode-config.settings;
  };

  xdg = {
    enable = true;
    configFile = {
      ".doom.d/config.el".source = ./apps/emacs/config.el;
      ".doom.d/init.el" = {
        source = ./apps/emacs/init.el;
        onChange = doom-emacs-sync;
      };
      ".doom.d/packages.el".source = ./apps/emacs/packages.el;
      ".emacs.d" = {
        source = builtins.fetchGit {
          ref = "develop";
          rev = "bac7ccb970847125919ce32043dce84cfcca16b8";
          url = "https://github.com/hlissner/doom-emacs";
        };
        onChange = doom-emacs-sync;
      };
    };
  };
  # Home manager starts xsession and injects session variables like DOOMDIR.
  xsession.enable = true;
  fonts.fontconfig.enable = true;

  programs = {
    bash = {
      enable = true;
      #    initExtra = ''
      #      source "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"
      #    '';
      bashrcExtra = (builtins.readFile ./apps/bash/config.sh);
    };
    emacs = { enable = true; };

    git = {
      enable = true;
      userName = "voli";
      userEmail = "vadim.oliinyk@gmail.com";
      aliases = { st = "status"; };
    };

    tmux = {
      enable = true;
      shortcut = "a";
      aggressiveResize = true;
      baseIndex = 1;
      newSession = true;
      # Stop tmux+escape craziness.
      escapeTime = 0;
      # Force tmux to use /tmp for sockets (WSL2 compat)
      secureSocket = false;

      extraConfig = ''
        # Mouse works as expected
        set-option -g mouse on
        # easy-to-remember split pane commands
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"
      '';
    };

    vim = {
      enable = true;
      settings = {
        expandtab = true;
        shiftwidth = 2;
        tabstop = 2;
      };
    };

    vscode = {
      enable = true;
      extensions = (with pkgs.vscode-extensions;
        [
          # ms-python.python
          ms-vscode-remote.remote-ssh
        ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "scala";
            publisher = "scala-lang";
            version = "0.5.3";
            sha256 = "0isw8jh845hj2fw7my1i19b710v3m5qsjy2faydb529ssdqv463p";
          }
          {
            name = "metals";
            publisher = "scalameta";
            version = "1.10.4";
            sha256 = "0q6zjpdi98png4vpzz39q85nxmsh3h1nnan58saz5rr83d6jgj89";
          }
        ];
    };
  };

  # Allow non-free software (e.g. ms-vscode-remote.remote-ssh)
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    (pkgs.writeScriptBin "nixFlakes" ''
      exec ${pkgs.nixUnstable}/bin/nix --experimental-features "nix-command flakes" "$@"
    '')
    jdk

    #utils
    htop
    jq
    wget
    zip
    unzip
    tree
    zstd
    exa # A modern replacement for ls.
    # dust # A more intutive version of du written in rust.
    duf # A better df alternative
    fd # A simple, fast and user-friendly alternative to find.
    ripgrep
    fzf # A general purpose command-line fuzzy finder.
    sd # An intuitive find & replace CLI (sed alternative).
    tldr # A community effort to simplify man pages with practical examples.
    bottom # Yet another cross-platform graphical process/system monitor.
    glances # A top/htop alternative
    gtop # System monitoring dashboard for terminal.
    gping # ping, but with a graph.
    procs # A modern replacement for ps written in Rust.
    dog # A user-friendly command-line DNS client. dig on steroids

    #dev
    clojure-lsp
    metals
    graphviz
    #jetbrains.idea-community
    nixfmt
    clojure
    chromium
    firefox

    # doom emacs dependencies
    emacs-all-the-icons-fonts
    ripgrep
    shellcheck
    ledger
    pandoc
    fd
    black # python formatter
    python38Packages.pyflakes
    python38Packages.isort
    pipenv
    python38Packages.pytest
    shfmt

    # VM
    libvirt
    virt-manager
    qemu
  ];

  services = {
    syncthing = {
      enable = false;
      tray.enable = false;
    };
    udiskie.enable = true;
  };

  news.display = "silent";
}
