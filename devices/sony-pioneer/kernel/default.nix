{
  mobile-nixos
, fetchFromGitHub
, kernelPatches ? [] # FIXME
, buildPackages
}:

let
  inherit (buildPackages) dtc;
in
(mobile-nixos.kernel-builder-gcc49 {
  version = "4.4.205";
  configfile = ./config.aarch64;

  file = "Image.gz-dtb";
  hasDTB = true;

  # https://github.com/LineageOS/android_kernel_sony_sdm660
  src = fetchFromGitHub {
    owner = "LineageOS";
    repo = "android_kernel_sony_sdm660";
    rev = "c4bdbbfd01ed97ad9055612073b22beb6131e206";
    sha256 = "0wlpxjsh8lx1rb30jbd1y52hi3l992cx6lspyb0jwgdyan9sp7p1";
  };

  patches = [
    ./0001-mobile-nixos-Adds-and-sets-BGRA-as-default.patch
    ./0001-mobile-nixos-Workaround-selected-processor-does-not-.patch
    ./0003-arch-arm64-Add-config-option-to-fix-bootloader-cmdli.patch
  ];

  makeFlags = [
    "DTC_EXT=${dtc}/bin/dtc"
  ];

  isModular = false;

}).overrideAttrs({ postInstall ? "", postPatch ? "", ... }: {
  installTargets = [ "zinstall" "Image.gz-dtb" "install" ];
  postInstall = postInstall + ''
    cp -v "$buildRoot/arch/arm64/boot/Image.gz-dtb" "$out/"
  '';
})
