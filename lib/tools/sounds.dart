import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

class Sounds {
  static Soundpool pool = Soundpool.fromOptions();
  static Map<String, String> soundFiles = {
    'pop': 'assets/sounds/pop.mp3',
    'click': 'assets/sounds/click.wav'
  };

  static Map<String, int?> sounds = {};

  static loadSounds() async {
    for (final e in soundFiles.entries) {
      int soundId = await rootBundle.load(e.value).then((ByteData soundData) {
        return pool.load(soundData);
      });
      sounds[e.key] = soundId;
    }
  }

  static play(String sound) async {
    final soundId = sounds[sound];
    if (soundId == null) return;
    await pool.play(soundId);
  }
}
