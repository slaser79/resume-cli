{
  description = "resume-cli";
  nixConfig.bash-prompt = "\[nix-resume-cli\]$ ";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };



  outputs = { self, nixpkgs,... }@inputs:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
      pkgs = forAllSystems ( system:
                               import nixpkgs {
                                   inherit system;
                                   overlays = [self.overlay];
                               }
                           );
    in
        {
          devShell   = forAllSystems (system: import ./devshell.nix { pkgs = pkgs.${system}; });
          nixpkgs    = pkgs;
          defaultApp = forAllSystems (system: 
                                              let 
                                                inherit (pkgs.${system}) resume-cli ;
                                              in
                                              { 
                                                type = "app";
                                                program = "${resume-cli}/bin/resume";
                                              }
                                      );
          packages  = forAllSystems (system:
                            pkgs.${system}.resume-cli

                      );
          defaultPackage = self.packages; 

        } // {
          overlay = final: prev: {
            resume-cli = (prev.mkYarnPackage {
              name        = "resume-cli";
              src         = ./. ;
              packageJSON = ./package.json;
              yarnLock    = ./yarn.lock;
              yarnNix     = ./yarn.nix;
            }).overrideAttrs(old : {
                buildPhase = (if old ? buildPhase then old.buildPhase else "") + "\n yarn run prepare";  
            });

          };
        };
}
