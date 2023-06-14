{
  description = "Typst's humble yet comprehensive environment: an accommodating space for crafting papers and presentations, offering a range of fonts and templates.";

  inputs = {
    typst.url = "github:typst/typst";
    flake-utils.url = "github:numtide/flake-utils";

    typst-slides = {
      url = "github:andreasKroepelin/typst-slides";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, typst, flake-utils, typst-slides }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        typst-app = typst.packages.${system}.default;

        typst-templates = pkgs.stdenvNoCC.mkDerivation {
          pname = "typst-templates";
          version = "0.1.0";
          src = self;

          installPhase = ''
            mkdir -p $out/share/typst/templates
            cp -r ${typst-slides} $out/share/typst/templates/slides
          '';
        };

        typst-wrapper = pkgs.stdenvNoCC.mkDerivation {
          pname = "typst";
          version = "${typst-app.version}-rev";
          buildInputs = [ typst-app typst-templates ];
          src = self;

          buildPhase = ''
            cat > typst <<EOF
            #!${pkgs.stdenvNoCC.shell}
            font_paths=\$(echo "\$TYPST_EXTRA_FONT_PATHS" | awk -F: '{ for(i=1; i<=NF; i++) printf "--font-path %s ", \$i }')
            exec ${typst-app}/bin/typst \$font_paths --root "${typst-templates}/share/typst/templates" "\$@"
            EOF

            chmod +x typst
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp ./typst $out/bin
          '';
        };

        devShell = { fonts }: pkgs.mkShell {
          name = "typst";
          buildInputs = [ typst-wrapper ];
          shellHook =
            let
              fontPaths = pkgs.lib.concatStringsSep ":" (map (f: f + "/share/fonts") fonts);
            in
            ''
              export TYPST_EXTRA_FONT_PATHS="${fontPaths}"
              echo -e "\e[32mTypst Version: $(typst --version)\e[0m"
            '';
        };
      in
      {
        packages.default = typst-wrapper;

        devShells.default = pkgs.lib.makeOverridable devShell {
          fonts = [
            pkgs.source-han-serif
            pkgs.inriafonts
            pkgs.source-han-sans
            pkgs.fira-code
          ];
        };
      });
}
