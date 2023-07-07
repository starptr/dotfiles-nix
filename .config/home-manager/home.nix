{ config, pkgs, timevim, ... }:

let
  # legacy variable from pre-flake config
  pkgs-arb-latest = pkgs;
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "yuto";
  home.homeDirectory = "/home/yuto.linux";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "22.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    pkgs.yadm

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # needed for un-nixed treesitter install
    pkgs.gcc

    #(pkgs.callPackage timevim.packages.aarch64-linux.default {})
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/yuto/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  home.shellAliases = {
    g = "git";
    d = "ls -A";
    da = "ls -Al";
  };

  programs.bat = {
    enable = true;
    config = {
      #theme = "GitHub";
    };
  };

  programs.neovim = {
    package = pkgs-arb-latest.neovim-unwrapped;
    enable = true;
    defaultEditor = true;
  };

  programs.gh = {
    package = pkgs-arb-latest.gh;
    enable = true;
    settings = {
      git_protocol = "https";
    };
  };
  programs.git = {
    enable = true;
    userName = "Yuto Nishida";
    userEmail = "yuto@berkeley.edu";
    signing = {
      key = null;
      signByDefault = false;
    };
  };
  programs.ssh = {
    enable = true;
  };

  # nushell has runtime (technically optional) dependency on starship
  # and since its config isn't managed by nix, we have to expose starship
  # to the user
  programs.starship = {
    enable = true;
    enableBashIntegration = false;
    enableFishIntegration = false;
    enableIonIntegration = false;
    enableZshIntegration = false;
    enableNushellIntegration = true;
  };

  programs.nushell = {
    enable = true;
    envFile.source = ./nushell/env.nu;
    configFile.source = ./nushell/config.nu;
    shellAliases = {
      d = "ls";
      da = "ls -a";
    };
  };
  programs.bash = {
    enable = true;
  };

  xdg = {
    enable = true;
    configFile.my-hello = {
      source = timevim;
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
