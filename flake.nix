{
  description = "resume-cli";
  nixConfig.bash-prompt = "\[nix-resume-cli\]$ ";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs,... }@inputs:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
      pkgs = forAllSystems ( system:
                               import nixpkgs {
                                   inherit system;
                               }
                           );
    in
        {
          devShell   = forAllSystems (system: import ./devshell.nix { pkgs = pkgs.${system}; });
          nixpkgs    = pkgs;
        };
}
