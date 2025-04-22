{
  lib,
  stdenv,
  fetchFromGitHub,
  yarn,
  electron,
  makeWrapper,
  rsync,
}:
stdenv.mkDerivation {
  pname = "revolt-desktop";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "revoltchat";
    repo = "desktop";
    rev = "d668949c3f5838da3be904ef21d9dfa88cf57af0";
    hash = "sha256-z7yyAznkSlsIleO+VqNyfRmzxP5ftxJVGyW7KmVyP+k=";
  };

  nativeBuildInputs = [yarn makeWrapper];

  buildPhase = ''
    mkdir -p $PWD/.yarn/cache
    ${lib.getExe rsync} -rs ${../.yarn/cache}/ $PWD/.yarn/cache/
    export HOME=$PWD
    export YARN_ENABLE_IMMUTABLE_INSTALLS=true
    export YARN_CACHE_FOLDER=$PWD/.yarn/cache
    export YARN_ENABLE_SCRIPTS=false
    yarn --immutable
    yarn build:bundle
  '';

  installPhase = ''
    mkdir -p $out/opt/revolt
    cp -r . $out/opt/revolt

    mkdir -p $out/bin
    makeWrapper ${electron}/bin/electron $out/bin/revolt-desktop \
      --add-flags "$out/opt/revolt"

    mkdir -p $out/share/applications
    cp revolt-desktop.desktop $out/share/applications/
    substituteInPlace $out/share/applications/revolt-desktop.desktop \
      --replace "Exec=./revolt-desktop.sh" "Exec=revolt-desktop"

    mkdir -p $out/share/icons/hicolor/512x512/apps
    cp build/icons/512x512.png $out/share/icons/hicolor/512x512/apps/revolt-desktop.png
  '';

  meta = with lib; {
    description = "Official Revolt desktop client.";
    homepage = "https://github.com/revoltchat/desktop";
    license = licenses.agpl3Plus;
    maintainers = [];
    platforms = platforms.all;
  };
}
