{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, libusb1
, sfml
, writeShellScript
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cutecapture";
  version = "unstable-2022-03-14";

  src = fetchFromGitHub {
    owner = "Gotos";
    repo = finalAttrs.pname;
    rev = "1c2b179884a38f415d77eab332b9e38a938d7d2b";
    hash = "sha256-Tv5pqoklRe1sDw74Faw86+fZbPwRv6ic1EOVeReZPjQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    libusb1
    sfml
  ];

  postPatch =
    let
      getVersion = writeShellScript "get_version.sh" ''
        echo ${lib.escapeShellArg finalAttrs.version}
      '';
    in
    "cp -f ${getVersion} get_version.sh";

  postInstall = ''
    install -Dm644 -t $out/lib/udev/rules.d 95-{3,}dscapture.rules
  '';

  meta = with lib; {
    description = "A (3)DS capture software for Linux and Mac";
    homepage = "https://github.com/Gotos/CuteCapture";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ raphaelr ];
  };
})
