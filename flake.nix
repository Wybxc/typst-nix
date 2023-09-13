{
  description = "Typst's humble yet comprehensive environment: an accommodating space for crafting papers and presentations, offering a range of fonts and templates.";

  inputs = {
    typst.url = "github:typst/typst/v0.7.0";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, typst, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        typst-app = typst.packages.${system}.default;

        typst-templates = pkgs.stdenvNoCC.mkDerivation {
          pname = "typst-templates";
          version = "0.2.0";
          src = ./templates;
          buildInputs = [ pkgs.yq ];

          installPhase =
            let
              templates = [
                "handout"
              ];
            in
            pkgs.lib.concatStringsSep "\n" (map
              (template: ''
                VERSION=$(cat $src/${template}/typst.toml | tomlq -r '.package.version')
                mkdir -p $out/share/typst/packages/local/${template}
                cp -r $src/${template} $out/share/typst/packages/local/${template}/$VERSION
              '')
              templates);
        };

        typst-fonts = pkgs.stdenvNoCC.mkDerivation {
          pname = "typst-fonts";
          version = "0.2.0";
          src = self;

          installPhase =
            let
              fonts = {
                inherit (pkgs) source-han-serif inriafonts source-han-sans fira-code;
              };
            in
            pkgs.lib.concatStringsSep "\n" (map
              (name: ''
                mkdir -p $out/share/fonts/${name}
                cp -r ${fonts.${name}}/share/fonts/* $out/share/fonts/${name}
              '')
              (builtins.attrNames fonts));
        };

        typst-packages = builtins.fetchGit {
          url = "https://github.com/typst/packages.git";
          ref = "main";
          rev = "d691ac949a07426f2ede2b3444a01e4ab547847a";
        };
      in
      rec {
        packages = {
          inherit typst-templates typst-fonts;
        };

        devShells.default = pkgs.mkShell {
          name = "typst";
          buildInputs = [ typst-templates typst-fonts ];
          packages = [ typst-app ];
          shellHook = ''
            export TYPST_FONT_PATHS="${typst-fonts}/share/fonts"
            export XDG_DATA_HOME="${typst-templates}/share"
            echo -e "\e[32mTypst Version: $(typst --version)\e[0m"
          '';
        };

        checks.default =
          let
            examples = [
              "slide"
              "handout"
            ];
          in
          pkgs.stdenvNoCC.mkDerivation
            {
              pname = "typst-nix-check";
              version = "0.1.0";
              src = self;
              buildInputs = [ typst-templates typst-fonts typst-app ];

              buildPhase =

                devShells.default.shellHook + "\n" + ''
                  mkdir -p $out/.cache/typst
                  cp -r ${typst-packages}/packages $out/.cache/typst
                  export XDG_CACHE_HOME="$out/.cache"
                '' +
                pkgs.lib.concatStringsSep "\n" (map
                  (example: ''
                    echo -e "\e[32mChecking ${example}\e[0m"
                    typst compile examples/${example}.typ
                  '')
                  examples);

              installPhase = pkgs.lib.concatStringsSep "\n" (map
                (example: ''
                  mkdir -p $out/share/typst/examples
                  cp examples/${example}.pdf $out/share/typst/examples/
                '')
                examples);
            };
      });
}
