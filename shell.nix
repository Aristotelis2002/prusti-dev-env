{
  pkgs,
  self',
  ...
}: let
  inherit (pkgs) lib stdenv mkShell;
  inherit (pkgs.darwin.apple_sdk) frameworks;

  prusti-server-rpath = lib.makeLibraryPath [
    stdenv.cc.cc.lib # libstdc++.so.6
  ];

  prusti-server-driver-rpath = "${stdenv.cc.cc.lib}/lib:${pkgs.jdk}/lib/openjdk/lib/server";

  patch-prusti = pkgs.writeShellScriptBin "patch-prusti" ''
    set -x

    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${prusti-server-rpath} \
      $HOME/.config/Code/User/globalStorage/viper-admin.prusti-assistant/prustiTools/Latest/prusti/viper_tools/z3/bin/z3

    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${prusti-server-rpath} \
      $HOME/.config/Code/User/globalStorage/viper-admin.prusti-assistant/prustiTools/Latest/prusti/prusti-driver

    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${prusti-server-rpath} \
      $HOME/.config/Code/User/globalStorage/viper-admin.prusti-assistant/prustiTools/Latest/prusti/prusti-rustc

    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${prusti-server-rpath} \
      $HOME/.config/Code/User/globalStorage/viper-admin.prusti-assistant/prustiTools/Latest/prusti/cargo-prusti

    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${prusti-server-rpath} \
      $HOME/.config/Code/User/globalStorage/viper-admin.prusti-assistant/prustiTools/Latest/prusti/prusti-server

    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${prusti-server-driver-rpath} \
      $HOME/.config/Code/User/globalStorage/viper-admin.prusti-assistant/prustiTools/Latest/prusti/prusti-server-driver
  '';
in
  mkShell {
    packages =
      [
        pkgs.jdk
        self'.legacyPackages.rustToolchain
        patch-prusti
      ]
      ++ lib.optionals stdenv.isDarwin [
        pkgs.libiconv
        frameworks.CoreServices
      ];

    shellHook = ''
      ${lib.getExe patch-prusti}
    '';
  }
