{
  description = "A disgustingly spooky NixOS Config.";

  inputs = {
    nixpkgs.url             = "github:nixos/nixpkgs/nixos-unstable";
    impermanence.url        = "github:nix-community/impermanence";
    home-manager.url        = "github:nix-community/home-manager/master";
    nixvim.url              = "github:nix-community/nixvim/nixos-24.05";
    sops-nix.url            = "github:Mic92/sops-nix";

    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.nixpkgs.follows       = "nixpkgs";
    sops-nix.inputs.nixpkgs.follows     = "nixpkgs";
  };

  outputs = inputs @ { self, nixpkgs, ... }: let
    args = {
      inherit self;
      inherit (nixpkgs) lib;
      pkgs = nixpkgs;
    };

    lib = (import ./Ghost/library args);
  in {
    nixosConfigurations = {
      inky = with lib; with builtins; mkHost {
        inputs  = self.inputs;
        host    = "inky";
        user    = "wisp";
      };

      clyde = with lib; with builtins; mkImage {
        modules = [ "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix" ];
        inputs  = self.inputs;
        host = "clyde";
        user = "wisp";
      };
    };
  };
}
