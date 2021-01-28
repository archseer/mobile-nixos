{
  mobile-nixos
, fetchFromGitHub
}:

mobile-nixos.kernel-builder {
  version = "5.11.0-rc5";
  configfile = ./config.aarch64;
  src = fetchFromGitHub {
    # https://github.com/megous/linux
    owner = "megous";
    repo = "linux";
    # orange-pi-5.11
    rev = "64000c98293580985fdd2c7ec4af39afc93a136f";
    sha256 = "1zkk7c324crbjwsfl5904l813m5pbggjbgra4g8rmpr8cgazw5d4";
  };
  patches = [
    # ./0001-dts-pinephone-Setup-default-on-and-panic-LEDs.patch
  ];

  # Install *only* the desired FDTs
  postInstall = ''
    echo ":: Installing FDTs"
    mkdir -p "$out/dtbs/allwinner"
    cp -v $buildRoot/arch/arm64/boot/dts/allwinner/sun50i-a64-pinephone-*.dtb $out/dtbs/allwinner/
  '';

  isCompressed = false;
}
