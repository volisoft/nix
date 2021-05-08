{ config, pkgs, ... }:

{
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

  programs.vim = {
    enable = true;
    settings = {
      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
    };
  };
  programs.git = {
    enable = true;
    userName = "voli";
    userEmail = "vadim.oliinyk@gmail.com";
    aliases = {
      st = "status";
    };
  };
  programs.emacs = {
    enable = true;
  };
  programs.vscode = {
    enable = true;
    extensions = (with pkgs.vscode-extensions; [
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
  # Allow non-free software (e.g. ms-vscode-remote.remote-ssh)
  nixpkgs.config.allowUnfree = true;

  nixpkgs.programs.java.enable;

  home.packages = with pkgs; [

    #utils
    htop
    jq
    wget
    zip
    unzip
    tree

    #dev
    tmux
    graphviz
#    jetbrains.idea-community
  ];

}
