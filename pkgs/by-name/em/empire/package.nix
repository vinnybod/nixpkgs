{
  lib,
  python312,
  fetchFromGitHub,
  nix-update-script,
  starkiller,
}:
let
  python = python312.override {
    self = python;
    packageOverrides = self: super: {
      donut-shellcode = super.donut-shellcode.overridePythonAttrs {
        version = "2.0.0";
        src = fetchFromGitHub {
          owner = "bc-security";
          repo = "donut-shellcode";
          rev = "b361c0d3dd125e42dfefb6ff9a6d3757d7190c14";
          hash = "sha256-jd8drECQ7sSKx+E3toa10ljkM7R20y+tT6rlrWhg/Ak=";
        };
      };
    };
  };
in
python.pkgs.buildPythonApplication {
  pname = "empire";
  version = "6.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bc-security";
    repo = "empire";
    rev = "d4486c17d0000c49309f58afaaec246db829db2e";
    hash = "sha256-ZyblfQXwzJI7tLHA1Nmq8UewmdC8QtRocoJGr1gs2OI=";
  };

  # TODO: donut-shellcode doesn't work on darwin
  # TODO: bcrypt is locked at 4.0.1 in pyproject.toml,
  #  but maybe it can be updated
  dontCheckRuntimeDeps = true;

  build-system = with python.pkgs; [
    poetry-core
  ];

  dependencies = with python.pkgs; [
    urllib3
    requests
    macholib
    pyopenssl
    zlib-wrapper
    jinja2
    pyparsing
    pymysql
    sqlalchemy
    pyyaml
    sqlalchemy-utc
    terminaltables
    pycryptodome
    cryptography
    fastapi
    uvicorn
    jq
    aiofiles
    python-multipart
    python-jose
    passlib
    python-socketio
    flask
    pysecretsocks
    python-obfuscator
    pyinstaller
    packaging
    netaddr
    # Todo: Needs to be 4.0.1
    bcrypt
    requests-file
  ] ++ lib.optionals (!stdenv.isDarwin) [
    donut-shellcode
  ];

  buildInputs = [
    starkiller
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/BC-SECURITY/Empire";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    description = "Post-exploitation framework";
    maintainers = with lib.maintainers; [
      fzakaria
      vrose
    ];
  };
}
