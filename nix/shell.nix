# Only the inputs which you may want to override in `callPackage`, the rest come from `pkgs`.
{ pkgs, pkgsCross, mkShell, rust-bin, noita-proxy }:

mkShell {
  strictDeps = true;

  inputsFrom = [ noita-proxy ];

  packages = with pkgs; [
    # Derivations in `rust-stable` provide the toolchain,
    # must be listed first to take precedence over nightly.
    (rust-bin.stable.latest.minimal.override {
      extensions = [ "rust-src" "rust-docs" "clippy" ];
      targets = [ "i686-pc-windows-gnu" ];
    })
    pkgsCross.mingw32.stdenv.cc
    pkgsCross.mingw32.windows.pthreads

    # Use rustfmt, and other tools that require nightly features.
    (rust-bin.selectLatestNightlyWith (toolchain:
      toolchain.minimal.override {
        extensions = [ "rustfmt" "rust-analyzer" ];
      }))

    just
    python3
    rust-bindgen
    cargo-flamegraph
  ];

  debsBuildBuild = with pkgs; [ wine64 ];

  env = {
    inherit (noita-proxy) OPENSSL_DIR OPENSSL_LIB_DIR OPENSSL_NO_VENDOR;

    RUST_BACKTRACE = 1;

    CARGO_TARGET_X86_64_PC_WINDOWS_GNU_LINKER =
      "${pkgsCross.mingw32.stdenv.cc.targetPrefix}cc";
    CARGO_TARGET_X86_64_PC_WINDOWS_GNU_RUNNER = "wine64";
  };
}
