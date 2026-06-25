{
  autoPatchelfHook,
  fetchurl,
  lib,
  stdenv,
}:

let
  version = "1.4.0";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://github.com/Creationsss/arrpc-bun/releases/download/v${version}/arrpc-bun-linux-x64";
      hash = "sha256-3BvYJkIL3/7GKyTfYuzkiXQBdu25l27RZOqFVSTXcbM=";
    };
  };
in
stdenv.mkDerivation {
  pname = "arrpc-bun";
  inherit version;

  src =
    srcs.${stdenv.hostPlatform.system}
      or (throw "arrpc-bun: unsupported system ${stdenv.hostPlatform.system}");

  dontUnpack = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/arrpc-bun
    runHook postInstall
  '';

  meta = {
    description = "TypeScript + Bun rewrite of arRPC — open Discord RPC server for custom clients";
    homepage = "https://github.com/Creationsss/arrpc-bun";
    license = lib.licenses.mit;
    mainProgram = "arrpc-bun";
    platforms = builtins.attrNames srcs;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
