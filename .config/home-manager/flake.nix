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
      timevim = inputs.timevim-local;
    in let
      system = "aarch64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."yuto" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./home.nix
          inputs.vscode-server.nixosModules.default ({ config, pkgs, ... }: {
            services.vscode-server.enable = true;
          })
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          timevim = timevim.outputs.packages.${system}.default;
        };
      };
    };
}
