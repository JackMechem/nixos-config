{ pkgs, ... }:

{

  # Enable sound.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Realtime scheduling for low-latency audio
  security.rtkit.enable = true;
  security.pam.loginLimits = [
    { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
    { domain = "@audio"; item = "rtprio"; type = "-"; value = "95"; }
    { domain = "@audio"; item = "nice"; type = "-"; value = "-19"; }
  ];

  users.users.jack.extraGroups = [ "audio" ];

  environment.systemPackages = with pkgs; [
    ardour
    qpwgraph # patchbay for routing PipeWire/JACK ports
    pavucontrol
    alsa-utils

    # LV2 plugins for Ardour (bass practice/recording)
    x42-plugins # tuner, meters, scope, EQ, compressor, metronome
    lsp-plugins # compressors, gate, parametric EQ, limiter
    zam-plugins # compressors, EQ, saturation
    calf # compressor, bass enhancer, EQ, reverb
    guitarix # amp/pedal simulations (usable for bass)
    neural-amp-modeler-lv2 # NAM amp/pedal captures
    chow-tape-model # tape saturation
    dragonfly-reverb # reverbs
  ];
}
