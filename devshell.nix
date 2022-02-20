{ pkgs }:
pkgs.mkShell {
  buildInputs = [
    pkgs.nodejs
    pkgs.yarn
    pkgs.nodePackages.typescript # dependency of tls
    pkgs.nodePackages.typescript-language-server
    pkgs.resume-cli
  ];
}
