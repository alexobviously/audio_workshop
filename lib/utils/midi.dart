import 'dart:math' as math;

abstract class Notes {
  static const a4 = 69;
}

// e.g. 69 -> "A4"
String stringFromNote(int note) {
  const noteNames = [
    'C',
    'C#',
    'D',
    'D#',
    'E',
    'F',
    'F#',
    'G',
    'G#',
    'A',
    'A#',
    'B',
  ];
  final noteIndex = note % 12;
  final octave = (note ~/ 12) - 1;
  return '${noteNames[noteIndex]}$octave';
}

Set<int> majorScale(int root) => {
  root,
  root + 2,
  root + 4,
  root + 5,
  root + 7,
  root + 9,
  root + 11,
};

Set<int> minorScale(int root) => {
  root,
  root + 2,
  root + 3,
  root + 5,
  root + 7,
  root + 8,
  root + 10,
};

double mtof(int note) => 440.0 * math.pow(2, (note - 69) / 12);
