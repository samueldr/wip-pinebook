{ config, pkgs, lib, ... }:

let
  uboot = pkgs.ubootPinebook;
in
{
  imports = [
    <nixpkgs/nixos/modules/profiles/base.nix>
    <nixpkgs/nixos/modules/profiles/minimal.nix>
    <nixpkgs/nixos/modules/profiles/installation-device.nix>
    ./nixos/sd-image-aarch64.nix
    ./pinebook.nix
  ];

  sdImage = {
    manipulateImageCommands = ''
      (PS4=" $ "; set -x
      dd if=${uboot}/u-boot-sunxi-with-spl.bin of=$img bs=1024 seek=8 conv=notrunc
      )
    '';
    compressImage = lib.mkForce false;
  };
}
