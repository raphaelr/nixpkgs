{
  lib,
  stdenv,
  fetchzip,

  cmake,
  ninja,
  python3,

  enableThreading ? true, # Threading can be disabled to increase security https://tls.mbed.org/kb/development/thread-safety-and-multi-threading
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tf-psa-cypto";
  version = "1.0.0";

  src = fetchzip {
    url = "https://github.com/Mbed-TLS/TF-PSA-Crypto/releases/download/tf-psa-crypto-1.0.0/tf-psa-crypto-1.0.0.tar.bz2";
    hash = "sha256-9CjdCw9cE1n7ZLvH6X38TwEvJQYlKvU50FZlKGHRAB4=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    ninja
    python3
  ];

  strictDeps = true;

  postConfigure = lib.optionalString enableThreading ''
    python3 scripts/config.py set MBEDTLS_THREADING_C       # Threading abstraction layer
    python3 scripts/config.py set MBEDTLS_THREADING_PTHREAD # POSIX thread wrapper layer for the threading layer.
  '';

  cmakeFlags = [
    "-DUSE_STATIC_TF_PSA_CRYPTO_LIBRARY=${if stdenv.hostPlatform.isStatic then "on" else "off"}"
    "-DUSE_SHARED_TF_PSA_CRYPTO_LIBRARY=${if stdenv.hostPlatform.isStatic then "off" else "on"}"
    # The programs only do some cryptographic operations on hardcoded buffers, not very useful to have:
    "-DENABLE_PROGRAMS=off"

    # Avoid a dependency on jsonschema and jinja2 by not generating source code
    # using python. In releases, these generated files are already present in
    # the repository and do not need to be regenerated. See:
    # https://github.com/Mbed-TLS/mbedtls/releases/tag/v3.3.0 below "Requirement changes".
    "-DGEN_FILES=off"
  ];

  doCheck = true;

  # Parallel checking causes test failures
  # TODO: https://github.com/Mbed-TLS/mbedtls/issues/4980
  enableParallelChecking = false;

  meta = with lib; {
    # TF = Trusted Firmware
    # PSA = Platform Security Architecture
    changelog = "https://github.com/Mbed-TLS/TF-PSA-Crypto/blob/development/ChangeLog";
    description = "TODO";
    license = [
      licenses.asl20 # or
      licenses.gpl2Plus
    ];
    maintainers = with maintainers; [ raphaelr ];
  };
})
