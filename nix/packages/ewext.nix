{ sourceRoot, lib, pkgsCross, rust-bin, makeRustPlatform }:
let
  rust-stable = rust-bin.latest.stable.minimal.override {
    targets = "i686-pc-windows-gnu";
  };
  rustPlatform = makeRustPlatform {
    rustc = rust-stable;
    cargo = rust-stable;
  };
in pkgsCross.mingw32.callPackage ({ rustPlatform, pkg-config, cmake, wine }:
  rustPlatform.buildRustPackage (finalAttrs:
    let
      inherit (finalAttrs) src pname version meta buildInputs;
      manifest = lib.importTOML "${src}/ewext/Cargo.toml";
    in {
      pname = "ewext";
      inherit (manifest.package) version;

      src = sourceRoot;
      sourceRoot = "source/ewext";

      cargoLock.lockFile = "${src}/ewext/Cargo.lock";

      # cargoBuildTarget = "i686-pc-windows-gnu";

      strictDeps = true;
      nativeBuildInputs = [ pkg-config cmake ];

      nativeCheckInputs = [ wine ];
      doCheck = false;
      # buildInputs = with pkgsCross.mingw32; [ openssl ];

      env = { CARGO_TARGET_I686_PC_WINDOWS_GNU_RUNNER = "wine"; };

      # env = {
      #   # CARGO_TARGET_I686_PC_WINDOWS_GNU_LINKER = "${mingw32.stdenv.cc.targetPrefix}gcc";
      #   OPENSSL_DIR = "${lib.getDev pkgsCross.mingw32.openssl}";
      #   OPENSSL_LIB_DIR = "${lib.getLib pkgsCross.mingw32.openssl}/lib";
      #   OPENSSL_NO_VENDOR = 1;
      # };

      meta = { };
    })) { }
