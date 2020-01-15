final: super:

let
  inherit (final) callPackage kernelPatches linuxPackagesFor;
in
{
  linux_pinebook = callPackage ./kernel {
    kernelPatches = [
      kernelPatches.bridge_stp_helper
      #kernelPatches.export_kernel_fpu_functions
      {
        name = "pinebook-config-fixes";
        patch = null;
        extraConfig = ''
          SUN8I_DE2_CCU y
          CRYPTO_AEGIS128_SIMD n # FIXME upstream in nixpkgs

          # Most of the following is required for display init.
          # Equivalent modules can also be added to the initrd instead.
          BACKLIGHT_PWM y
          DRM y
          DRM_ANALOGIX_ANX6345 y
          DRM_ANALOGIX_DP y
          DRM_ANALOGIX_DP_I2C y
          DRM_KMS_HELPER y
          DRM_LIMA n
          DRM_PANEL_SIMPLE y
          DRM_SCHED y
          DRM_SUN4I y
          DRM_SUN4I_BACKEND y
          DRM_SUN4I_HDMI y
          DRM_SUN6I_DSI y
          DRM_SUN8I_DW_HDMI y
          DRM_SUN8I_MIXER y
          DRM_SUN8I_TCON_TOP y
          PWM_SUN4I y
        '';
      }
    ];
  };
  linuxPackages_pinebook = (linuxPackagesFor final.linux_pinebook)
    .extend(final: super: {
      rtl8723cs = final.callPackage ./rtl8723cs.nix {};
    })
  ;
}
