{ pkgs ? import <nixpkgs> {} }:

let
  mach-nix = import (builtins.fetchGit {
    url = "https://github.com/DavHau/mach-nix/";
    ref = "refs/tags/3.0.2";
  }) {};

  repo = pkgs.fetchgit {
    url = "https://git.sr.ht/~heckyel/yt-local";
    rev = "refs/heads/master";
    sha256 = "sha256-0finwKrnnVY+rGxBjvcG3vKtul5YqH1oIrXze/4GMNQ=";
  };

  #requirements = builtins.readFile "${repo}/requirements.txt";

  pythonEnv = mach-nix.mkPython {
    requirements = ''
      blinker
      Brotli
      cachetools
      click
      defusedxml
      Flask
      gevent
      greenlet
      itsdangerous
      Jinja2
      MarkupSafe
      PySocks
      stem
      urllib3
      Werkzeug
      zope.event
      zope.interface
      '';
  };
  
in
  pkgs.stdenv.mkDerivation rec {
    pname = "yt-local";
    version = "0.0.2";

    src = repo;

    buildInputs = [
      pkgs.git
      pythonEnv
      pkgs.python312
      pkgs.python312Packages.pip
    ];
  
    installPhase = ''
      mkdir -p $out/etc/yt-local-nix/
      cp -r ${repo}/* $out/etc/yt-local-nix/
    '';

    meta = with pkgs.lib; {
      description = "yt-local for nix";
      license = licenses.mit;
      maintainers = [ maintainers.danihek ];
      platforms = platforms.all;
    };
  }
