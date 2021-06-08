{
  description = "bic static site generator";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, nixpkgs }: {

    defaultPackage.x86_64-linux =

    with import nixpkgs { system = "x86_64-linux";};

    stdenv.mkDerivation rec {
      name = "bic";
      src = self;

      nativeBuildInputs = [ makeWrapper ];
      buildInputs = [ pandoc ];

      dontStrip = true;
      buildPhase = "true";

      installPhase = ''
        mkdir -p $out/share
        cp -r bic lib .env $out/share

        makeWrapper $out/share/bic $out/bin/bic \
          --prefix PATH : ${lib.makeBinPath [ pandoc ]} \
      '';

      meta = with lib; {
        description = "Opinionated minimal static site generator in a single Bash script";
        homepage = "https://bic.sh/";
        license = licenses.mit;
      };
    };
  };
}
