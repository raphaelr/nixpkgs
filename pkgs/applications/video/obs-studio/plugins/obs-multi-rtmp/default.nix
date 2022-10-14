{ lib, stdenv, fetchFromGitHub, obs-studio, cmake, qtbase }:

stdenv.mkDerivation rec {
  pname = "obs-multi-rtmp";
  version = "0.2.8.1-OBS28";

  src = fetchFromGitHub {
    owner = "sorayuki";
    repo = "obs-multi-rtmp";
    rev = version;
    hash = "sha256-1W+c8Y0AmtKQmCIg8IDAaYYStQzDpZRuqw3vZEY5ncU=";
  };

  patches = [
  # Patch cmake file to link against the obs build output, instead of its sources
    ./fix-build.patch
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio qtbase ];

  dontWrapQtApps = true;

  meta = with lib; {
    homepage = "https://github.com/sorayuki/obs-multi-rtmp/";
    changelog = "https://github.com/sorayuki/obs-multi-rtmp/releases/tag/${version}";
    description = "Multi-site simultaneous broadcast plugin for OBS Studio";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ jk ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
