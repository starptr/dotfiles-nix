{
  description = "Home Manager configuration of yuto";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    timevim-local = {
      url = "git+file:./../../src/neovim-nuflake";
    };
    timevim-remote = {
      url = "github:starptr/nvim-flaked";
    };
  };

  outputs = { nixpkgs, home-manager, ... } @ inputs:
    let
      # Configure specific input
      timevim = inputs.timevim-remote;
    in let
      system = "aarch64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      # lima generates username based on host username
      usernames = [ "yuto" "ynishida" ];
      fillHolesInConfigs = f: builtins.listToAttrs (map (username: nixpkgs.lib.attrsets.nameValuePair username (f { inherit username; })) usernames);
      #forAllUsernames = (value: { "yuto" = value; });
    in {
      homeConfigurations = fillHolesInConfigs ({ username }: home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./home.nix
          inputs.vscode-server.homeModules.default ({ config, pkgs, ... }: {
            services.vscode-server.enable = true;
          })
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit username;
          timevim = timevim.outputs.packages.${system}.default;
        };
      });
    };
}
