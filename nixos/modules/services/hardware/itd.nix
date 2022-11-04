{ config, lib, pkgs, ... }:

with lib;

{
  options = {
    services.itd = {
      enable = mkEnableOption (mdDoc ''
        Whether to enable itd, a daemon to interact with PineTime smartwatches running InfiniTime.
      '');
    };
  };

  config = mkIf config.services.itd.enable {
    environment.systemPackages = [ pkgs.itd ];

    environment.etc."itd.toml".source = "${pkgs.itd}/etc/itd.toml";

    systemd.user.services.itd = {
      description = "InfiniTime daemon";
      wantedBy = [ "default.target" ];
      # Used to enter bluetooth pairing codes
      path = [ pkgs.gnome.zenity ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.itd}/bin/itd";
      };
    };

    assertions = [{
      assertion = config.hardware.bluetooth.enable;
      message = "itd requires Bluetooth to be enabled.";
    }];
  };

  meta.maintainers = with lib.maintainers; [ raphaelr ];
}
