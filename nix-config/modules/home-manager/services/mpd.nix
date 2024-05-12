{ config, ... }: {
  services = {
    mpd.enable = true;
    mpd.musicDirectory = "${config.home.homeDirectory}/Music";
    mpdris2.enable = true;
  };
}

