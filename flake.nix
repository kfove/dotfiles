{
  description = "NixOS configuration of Ryan Yin";

  # ......

  inputs = {
    # ......
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
	};

    # helix editor, use tag 23.10
    helix.url = "github:helix-editor/helix/23.10";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      nixosdk = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        # 将所有 inputs 参数设为所有子模块的特殊参数，
        # 这样就能直接在子模块中使用 inputs 中的 helix 了
        specialArgs = inputs;
        modules = [
          ./nixos/configuration.nix
	  home-manager.nixosModules.home-manager
	  {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.dingduck = import ./home/home.nix;
          }
        ];
      };
    };
  };
}
