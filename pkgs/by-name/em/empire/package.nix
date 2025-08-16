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
    rev = "7182a140149e94128da9a953bc964e43b8a05d5c";
    hash = "sha256-5jBeWTDWMerNBcYHM//63pDbbBD2QMUCFoiA6G3bKYQ=";
  };

  pythonRelaxDeps = true;

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
    donut-shellcode
    python-obfuscator
    pyinstaller
    packaging
    netaddr
    # Todo: Needs to be 4.0.1
    bcrypt
    requests-file
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
