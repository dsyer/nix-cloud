with import <nixpkgs> {};
pkgs.mkShell {
  name = "cloud";
  buildInputs = [
    (import ./default.nix { inherit pkgs; })
    figlet
  ];
  shellHook = ''
    figlet ":cloud:"
    echo
    terraform version
    echo
'';
}