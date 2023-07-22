{
    description = "";

    inputs = {
        nixpkgs.url = "nixpkgs";
    };

    outputs = { self, nixpkgs }:
        let
            supportedSystems = [ "x86_64-linux" ];

            forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);

            nixpkgsFor = forAllSystems (system: import nixpkgs {
                    inherit system;
                    overlays = [ self.overlays ];
            });
        in {
            overlays = (final: prev: {
                    haskell-basic = final.haskellPackages.callCabal2nix "haskell-basic" ./. {};
            });

            packages = forAllSystems (system: {
                    haskell-basic = nixpkgsFor.${system}.haskell-basic;
                });

            devShell = forAllSystems (system:
                    let
                        haskellPackages = nixpkgsFor.${system}.haskellPackages;
                    in haskellPackages.shellFor {
                        packages = p: [ self.packages.${system}.haskell-basic ];

                        withHoogle = true;

                        buildInputs = [
                            haskellPackages.cabal-install
                            haskellPackages.haskell-language-server
                            haskellPackages.ghcid
                        ];
                    });
        };
}
