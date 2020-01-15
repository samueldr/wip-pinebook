{ stdenv, fetchFromGitHub, kernel, nukeReferences }:

let
  inherit (kernel.stdenv.lib) concatStringsSep;
  out = "${placeholder "out"}/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless";
in kernel.stdenv.mkDerivation rec {
  name = "rtl8723cs-${kernel.version}-${version}";
  version = "2019-08-25";

  src = fetchFromGitHub {
    owner = "icenowy";
    repo = "rtl8723cs";
    rev = "d7db077004f1497800faabb0e6da775391393711";
    sha256 = "15h3105hqh8z7dzj9kh09njkyzb3kxxmpyjbmwhpvihbc5pwss21";
  };

  nativeBuildInputs = [
    nukeReferences
  ];

  postPatch = ''
    sed -i 's/^.*depmod.*$//g' Makefile
  '';

  makeFlags = concatStringsSep " " [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
    "ARCH=${kernel.stdenv.hostPlatform.platform.kernelArch}"
    "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "MODDESTDIR=${out}"
  ];

  preInstall = ''
    mkdir -p ${out}
  '';

  postInstall = ''
    nuke-refs $(find $out -name "*.ko")
  '';
}
