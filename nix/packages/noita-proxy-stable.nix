# TODO: Update script & CI
{ callPackage, fetchFromGitHub, rustPlatform }:
(callPackage ./noita-proxy.nix {
  sourceRoot = fetchFromGitHub {
    owner = "intquant";
    repo = "noita_entangled_worlds";
    rev = "v1.6.2";
    hash = "sha256-DAGLpGo8K6qSfxMwTELSU9HLHRX2lp5qbmmq/tL08JM=";
  };
  inherit rustPlatform;
})
