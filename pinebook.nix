# This configuration file can be safely imported in your system configuration.
{ config, pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (import ./overlay.nix)
  ];

  boot.kernelPackages = pkgs.linuxPackages_pinebook;

  boot.kernelParams = [
    # Attempt to fix display init with EFI boot...
    # (failed.)
    "video=efifb:off"
  ];

  # This list of modules is not entirely minified, but represents
  # a set of modules that is required for the display to work in stage-1.
  # Further minification can be done, but requires trial-and-error mainly.
  boot.initrd.kernelModules = [
    # For module-based kernel
    #"analogix_anx6345"
    #"panel_simple"
    #"pwm_bl"
    #"pwm_sun4i"
    #"sun4i_drm"
    #"sun8i_drm_hdmi"
    #"sun8i_mixer"
  ];

  boot.extraModulePackages = with pkgs; [
    linuxPackages_pinebook.rtl8723cs
  ];

  # Notes about this here:
  #  → https://github.com/systemd/systemd/blob/master/hwdb.d/60-keyboard.hwdb
  #  → https://wiki.archlinux.org/index.php/Map_scancodes_to_keycodes
  #  → https://wiki.archlinux.org/index.php/Keyboard_input#Identifying_scancodes
  # Key between Fn and LEFT_ALT
  #   0x7f 0xff from showkey --scancodes
  # Though apparently evtest has to be used
  #   Event: time [...], type 4 (EV_MSC), code 4 (MSC_SCAN), value 70065
  #   Event: time [...], type 1 (EV_KEY), code 127 (KEY_COMPOSE), value 0
  # Desired:
  #   Event: time [...], type 1 (EV_KEY), code 125 (KEY_LEFTMETA), value 0
  #
  # For such a remapping to be valid, the MSC_SCAN value needs to be used.
  services.udev.extraHwdb = ''
    evdev:input:b0003v258Ap000C*
      # Remaps the "Menu" key to LEFT_META
      # The key is at the bottom left, LCTRL, Fn, Menu, LALT
      # It defaults to KEY_COMPOSE
      KEYBOARD_KEY_70065=leftmeta
  '';

  hardware.enableRedistributableFirmware = true;

  # The default powersave makes the wireless connection unusable.
  networking.networkmanager.wifi.powersave = lib.mkDefault false;
}
