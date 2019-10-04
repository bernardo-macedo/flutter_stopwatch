// ignore_for_file: prefer_single_quotes, always_specify_types
// Ignoring some lint rules because I want the map to also be valid json.

class Strings {
  Map<String, Map<String, String>> map = <String, Map<String, String>>{
    "home_title": {"en": "Stopwatch", "pt": "Cronômetro"},
    "vibration_label": {"en": "Vibration", "pt": "Vibração"},
    "sound_label": {"en": "Sound", "pt": "Som"},
    "start_label": {"en": "START", "pt": "INICIAR"},
    "pause_label": {"en": "PAUSE", "pt": "PAUSAR"},
    "continue_label": {"en": "CONTINUE", "pt": "CONTINUAR"},
    "stop_label": {"en": "STOP", "pt": "CANCELAR"}
  };
}
