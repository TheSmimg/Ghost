{ self, lib, pkgs, ... }: rec {
  mkHost = {
    inputs
    , host
    , user
    , nixpkgs ? inputs.nixpkgs
    , modules ? []
    , system  ? "x86_64-linux"
  }: let
    baseConfig  = "Hosts/base.nix";
    hostConfig  = "Hosts/${host}.nix";
    homeConfig  = "Homes/${user}/user.nix";
  in
    nixpkgs.lib.nixosSystem {
      system      = "${system}";
      specialArgs = { inherit lib host user inputs self; };
      modules = [
        inputs.impermanence.nixosModules.impermanence
        inputs.sops-nix.nixosModules.sops
        { networking.hostName = "${host}"; }
        { imports = self.modules.mapModulesRec ../config import; }
        ../../${baseConfig}
        ../../${hostConfig}
        inputs.home-manager.nixosModules.home-manager { home-manager = {
          extraSpecialArgs = { inherit host self user inputs; };
          useGlobalPkgs    = true;
          useUserPackages  = true;
          users.${user} = { pkgs, self, user, inputs, host, ... }: {
            imports = [ ../../${homeConfig} ];
          };
        };}
      ] ++ modules;
    };
  
  mkImage = {
    inputs
    , host
    , user
    , nixpkgs ? inputs.nixpkgs
    , modules ? [ (inputs.nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix") ]
    , system  ? "x86_64-linux"
  }: mkHost {
    inherit inputs host user nixpkgs modules system;
  };
}

