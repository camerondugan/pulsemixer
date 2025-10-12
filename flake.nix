{
  inputs = {
    utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, utils }: utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShell = pkgs.mkShell {
        packages = with pkgs; [
          python3
        ];
        shellHook = ''
          export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath [pkgs.pulseaudio]}:$LD_LIBRARY_PATH
        '';
      };
    }
  );
}
