{
  # Base python template

  description = "A Nix-flake-based Python development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

  outputs = { self, nixpkgs }:
  let
    supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    # TODO: Consider adding packages for Terraform and Ansible
    forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
      pkgs = import nixpkgs { inherit system; overlays = [ self.overlays.default ]; };
    });
  in
  {
    overlays.default = final: prev: rec {
      # ==== PYTHON ====

      # use different version of Ruby from nixpkgs
      # python = final.python2;
      # python = final.python310;

      # specify exact version of Python override
      # python = final.python.override {
      #   version = "2.2.2";
      #   sha256 = "sha256-7S+mC4pDcbXyhW2r5y8+VcX9JQXq5iEUJZiFmgVMPZ0=";
      # }
    };

    devShells = forEachSupportedSystem ({ pkgs }: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          # Build tools for gems
          git

          # Other dev tools
          # postgresql
          # redis

          # specify a python version if you don't want the default
          # e.g. python2
          python3
          uv

          nodejs
        ]
        ++ [ bashInteractive ]
        ++
        ## Linux only
        pkgs.lib.optionals pkgs.stdenv.isLinux (with pkgs; [
          inotify-tools
        ]);
      };
    });
  };
}
