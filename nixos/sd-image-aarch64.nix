{ config, lib, pkgs, ... }:

let
  extlinux-conf-builder =
    import <nixpkgs/nixos/modules/system/boot/loader/generic-extlinux-compatible/extlinux-conf-builder.nix> {
      pkgs = pkgs.buildPackages;
    };
in
{
  imports = [
    ./sd-image.nix
  ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  boot.consoleLogLevel = lib.mkDefault 7;

  boot.kernelParams = [
    "cma=32M"

    "earlycon=uart,mmio32,0x01c28000"
    # TODO : toggle off/on depending on desire
    "console=ttyS0,115200n8"

    # The last console parameter will be where the boot process will print
    # its messages. Comment or move abot ttyS2 for better serial debugging.
    "console=tty0"
  ];

  services.mingetty.serialSpeed = [ 1500000 115200 57600 38400 9600 ];

  boot.initrd.availableKernelModules = [
  ];

  sdImage = {
    populateRootCommands = ''
      mkdir -p ./files/boot
      ${extlinux-conf-builder} -t 3 -c ${config.system.build.toplevel} -d ./files/boot
    '';
  };

  # the installation media is also the installation target,
  # so we don't want to provide the installation configuration.nix.
  installer.cloneConfig = false;
}
