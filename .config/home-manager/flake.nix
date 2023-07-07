{
  description = "Home Manager configuration of yuto";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    timevim = {
      flake = true;
      url = "git+file:./../../src/neovim-nuflake";
    };
  };

  outputs = { nixpkgs, home-manager, timevim, ... }:
    let
      system = "aarch64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in let
      homeConfigurations."yuto" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          timevim = timevim.outputs.packages.${system}.default;
        };
      };
    in {
      homeConfigurations."yuto" = homeConfigurations."yuto";
    };
}
