with (import <nixpkgs> { }); {
  packageOverrides = pkgs:
    with pkgs; {
      userPackages = buildEnv {
        # Apply with `nix-env -iA nixpkgs.userPackages`
        name = "user-packages";
        paths = [
          dive
          docker-compose
          git
          gitAndTools.hub
          jq
          kind
          kubectl
          kustomize
          skaffold
          stow
          yq
        ];
      };
    };
  allowUnfree = true;
}
