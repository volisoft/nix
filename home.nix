{ config, pkgs, ... }:

let
  vscode-config = pkgs.callPackage ./apps/vscode-config.nix { };
  # Remove after aarch64-linux is added to the official pkgs derivation
  jetbrains = pkgs.callPackage ./apps/jbidea { };
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
  home.stateVersion = "21.05";

  home = {
    # Doom Emacs config
    file.".emacs.d".source = "${config.xdg.configHome}/.emacs.d";
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
      ".doom.d/init.el".source = ./apps/emacs/init.el;
      ".doom.d/packages.el".source = ./apps/emacs/packages.el;
      ".emacs.d" = {
        source = builtins.fetchGit "https://github.com/hlissner/doom-emacs";
        onChange = "${pkgs.writeShellScript "doom-change" ''
          export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"
          export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"
          if [ ! -d "$DOOMLOCALDIR" ]; then
            ${config.xdg.configHome}/.emacs.d/bin/doom -y install
          else
            ${config.xdg.configHome}/.emacs.d/bin/doom -y sync -u
          fi
        ''}";
      };
    };
  };

  programs = {
    bash = {
      enable = true;
      initExtra = ''
        source "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"
      '';
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
    jdk

    #utils
    htop
    jq
    wget
    zip
    unzip
    tree

    #dev
    # clojure-lsp
    metals
    graphviz
    #jetbrains.idea-community
    nixfmt

    emacs-all-the-icons-fonts
  ];

  services = {
    syncthing = {
      enable = true;
      tray = true;
    };
    udiskie.enable = true;
  };

  news.display = "silent";
}
