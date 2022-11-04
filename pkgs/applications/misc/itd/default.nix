{ lib
, buildGoModule
, fetchFromGitea
, pkg-config
, withGui ? true
, libGL
, libX11
, libXcursor
, libXext
, libXi
, libXinerama
, libXrandr
, libXxf86vm
}:

buildGoModule rec {
  pname = "itd";
  version = "0.0.9";

  src = fetchFromGitea {
    domain = "gitea.arsenm.dev";
    owner = "Arsen6331";
    repo = "itd";
    rev = "v${version}";
    hash = "sha256-FefffF8YIEcB+eglifNWuuK7H5A1YXyxxZOXz1a8HfY=";
  };

  vendorHash = "sha256-LFzrpKQQ4nFoK4vVTzJDQ5OGDe1y5BSfXPX+FRVunjQ=";

  nativeBuildInputs = lib.optional withGui pkg-config;

  buildInputs = lib.optionals withGui [
    libGL
    libX11
    libXcursor
    libXext
    libXi
    libXinerama
    libXrandr
    libXxf86vm
  ];

  # main.go uses go:embed to read this
  preBuild = ''
    echo "${version}" > version.txt
  '';

  # package contains no tests
  doCheck = false;

  postInstall = ''
    install -Dm644 itd.toml $out/etc/itd.toml
  '';

  subPackages = [ "." "cmd/itctl" ]
    ++ lib.optional withGui "cmd/itgui";

  meta = with lib; {
    description = "A daemon to interact with PineTime smartwatches running InfiniTime";
    homepage = "https://gitea.arsenm.dev/Arsen6331/itd";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ raphaelr ];
    platforms = platforms.linux;
  };
}
