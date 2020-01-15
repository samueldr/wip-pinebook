WIP stuff to get started on the pinebook.

## Using in your configuration

Clone this repository somwhere, and in your configuration.nix

```
{
  imports = [
    .../pinebook/pinebook.nix
  ];
}
```

That entry point will try to stay unopinionated, while maximizing the hardware
compatibility.

## Compatibility

### Tested

 * X11 with modesetting
 * Wi-Fi
 * Brightness controls

### Untested


### Known issues

 * Sometimes the display doesn't wake in DPMS. Wait until it sleeps again and wake it, it eventually comes back.

## Image build

```
$ ./build.sh
$ lsblk /dev/mmcblk0 && sudo dd if=$(echo result/sd-image/*.img) of=/dev/mmcblk0 bs=8M oflag=direct status=progress
```

The `build.sh` script transmits parameters to `nix-build`, so e.g. `-j0` can
be used.

Once built, this image is self-sufficient, meaning that it should already be
booting, no need burn u-boot to it.

The required modules (and maybe a bit more) are present in stage-1 so the
display should start early enough in the boot process.

## Note about cross-compilation

This will automatically detect the need for cross-compiling or not.

When cross-compiled, all caveats apply. Here this mainly means that the kernel
will need to be re-compiled on the device on the first nixos-rebuild switch,
while most other packages can be fetched from the cache.

## `u-boot`

Assuming `/dev/mmcblk0` is an SD card.

```
$ nix-build -A pkgs.ubootPinebook
$ lsblk /dev/mmcblk0 && sudo dd if=u-boot-sunxi-with-spl.bin of=/dev/mmcblk0 bs=1024 seek=8 oflag=direct,sync
```
