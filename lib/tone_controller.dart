import 'package:flutter_soloud/flutter_soloud.dart';

class ToneController {
  final SoLoud _soloud = SoLoud.instance;

  Future<void> playTone(double frequency, Duration duration) async {
    print('Playing tone $frequency for $duration');
    final sound = await _soloud.loadWaveform(
      WaveForm.sin,
      false,
      1.0,
      0.0,
    );
    print('Sound loaded $sound');
    _soloud.setWaveformFreq(sound, frequency);
    final handle = await _soloud.play(sound);
    _soloud.setVolume(handle, 0);
    _soloud.fadeVolume(handle, 1, const Duration(milliseconds: 100));
    print('Handle $handle');
    _soloud.fadeVolume(handle, 0, duration);
    await Future.delayed(duration);
    await _soloud.stop(handle);
  }
}
