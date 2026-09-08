{ inputs, lib, ... }:
{
  options.flake.devShellPackages = lib.mkOption {
    type = lib.types.lazyAttrsOf (lib.types.listOf lib.types.package);
    default = { };
  };

  options.flake.devShellEnv = lib.mkOption {
    type = lib.types.lazyAttrsOf (lib.types.attrsOf lib.types.str);
    default = { };
  };

  config.flake.devShells = builtins.mapAttrs (system: pkgs: {
    default = pkgs.mkShell (
      (inputs.self.devShellEnv.${system} or { })
      // {
        packages = inputs.self.devShellPackages.${system} or [ ];
      }
    );
  }) inputs.nixpkgs.legacyPackages;
}
