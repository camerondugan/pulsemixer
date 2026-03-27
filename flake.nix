{
  inputs = {
    utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, utils }: utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      pulsemixer = pkgs.writeShellScriptBin "pulsemixer" ''
          export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath [pkgs.pulseaudio]}:$LD_LIBRARY_PATH
          exec ${pkgs.python3}/bin/python3 ${./pulsemixer} "$@"
      '';
    in
    {
      packages.default = pulsemixer;

      apps.default = {
        type = "app";
        program = "${pulsemixer}/bin/pulsemixer";
        meta.description = "CLI and curses mixer for PulseAudio";
      };
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
