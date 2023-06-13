{
  description = "Typst's humble yet comprehensive environment: an accommodating space for crafting papers and presentations, offering a range of fonts and templates.";

  inputs = {
    typst.url = "github:typst/typst";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, typst, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        typst' = typst.packages.${system}.default;
      in
      rec {
        packages.default = pkgs.stdenvNoCC.mkDerivation {
          pname = "typst";
          version = "${typst'.version}-rev";
          buildInputs = [ typst' ];
          src = self;

          buildPhase = ''
            cat > typst <<EOF
            #!${pkgs.stdenvNoCC.shell}
            font_paths=\$(echo "\$TYPST_EXTRA_FONT_PATHS" | awk -F: '{ for(i=1; i<=NF; i++) printf "--font-path %s ", \$i }')
            exec ${typst'}/bin/typst \$font_paths "\$@"
            EOF

            chmod +x typst
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp ./typst $out/bin
          '';
        };

        devShells.default = pkgs.mkShell {
          name = "typst";
          buildInputs = [ packages.default ];
          shellHook = ''
            export TYPST_EXTRA_FONT_PATHS="${pkgs.source-han-serif}/share/fonts:${pkgs.inriafonts}/share/fonts"
            echo -e "\e[32mTypst Version: $(typst --version)\e[0m"
          '';
        };
      });
}
