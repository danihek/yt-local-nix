{ config, lib, pkgs, ... }:

let
  yt-local = pkgs.callPackage ./default.nix {};
in {
  options.services.yt-local = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the yt-local service";
    };
  };

  config = lib.mkIf config.services.yt-local.enable {
    systemd.services.yt-local = {
      description = "yt-local service";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.python312}/bin/python3 /etc/yt-local-nix/server.py";
        WorkingDirectory = "/etc/yt-local-nix/";
        Restart = "always";
        RestartSec = 5;
        Environment = "PYTHONPATH=${yt-local}/lib/python3.12/site-packages";
      };
      install.wantedBy = [ "multi-user.target" ];
    };
  };
}
