with (import <nixpkgs> { }); {
  packageOverrides = pkgs:
    with pkgs; {
      userPackages = buildEnv {
        # Apply with `nix-env -iA nixpkgs.userPackages`
        name = "user-packages";
        paths = [
          envsubst
          gnumake
          jq
          stow
          yq
        ];
      };
    };
  allowUnfree = true;
}
