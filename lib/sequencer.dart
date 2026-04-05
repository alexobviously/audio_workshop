import 'dart:async';
import 'dart:math';

import 'package:audio_workshop/utils/midi.dart';
import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

part 'sequencer.g.dart';

class Sequencer extends Cubit<SequencerState> {
  final SoLoud _soloud = SoLoud.instance;

  Sequencer() : super(SequencerState.initial()) {
    _startTimer();
  }

  Timer? _timer;
  static const _filterFadeTime = Duration(milliseconds: 300);

  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) => _onTick(),
    );
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _onTick() {
    nextStep();
    _playNotes();
  }

  void _playNotes() {
    final step = state.steps[state.step];
    _playStep(step: state.step);
  }

  void setStepNote({
    required int step,
    required int note,
    required bool active,
  }) {
    emit(state.setStepNote(step: step, note: note, active: active));
  }

  Future<void> _playStep({required int step}) async {
    final notes = state.steps[step];
    emit(state.setNotesActive(step: step, notes: notes, active: true));
    for (final note in notes) {
      unawaited(
        _playTone(
          frequency: mtof(note),
          attack: Duration(milliseconds: state.attack),
          sustain: Duration(milliseconds: state.sustain),
          release: Duration(milliseconds: state.release),
        ),
      );
    }
    await Future.delayed(
      Duration(milliseconds: min(200, state.totalNoteLength)),
    );
    emit(state.setNotesActive(step: step, notes: notes, active: false));
  }

  Future<void> _playTone({
    required double frequency,
    required Duration attack,
    required Duration sustain,
    required Duration release,
  }) async {
    final sound = await _soloud.loadWaveform(.sin, true, .1, 0.0);
    _soloud.setWaveformFreq(sound, frequency);
    final handle = await _soloud.play(sound, volume: 0);

    _soloud.fadeVolume(handle, 1, attack);
    await Future.delayed(attack + sustain);

    _soloud.fadeVolume(handle, 0, release);
    await Future.delayed(release);
    await _soloud.stop(handle);
  }

  void start() {
    if (_timer != null) return;
    _startTimer();
  }

  void stop() {
    if (_timer == null) return;
    _stopTimer();
  }

  void nextStep() {
    final step = (state.step + 1) % state.steps.length;
    emit(state.copyWith(step: step));
  }

  void setAttack(num attack) {
    emit(state.copyWith(attack: attack.toInt()));
  }

  void setSustain(num sustain) {
    emit(state.copyWith(sustain: sustain.toInt()));
  }

  void setRelease(num release) {
    emit(state.copyWith(release: release.toInt()));
  }

  void setDelayActive(bool delayActive) {
    final filters = _soloud.filters;
    if (delayActive) {
      filters.echoFilter.activate();
    } else {
      filters.echoFilter.deactivate();
    }

    emit(state.copyWith(delayActive: delayActive));
  }

  void setDelayTime(num delayTime) {
    _soloud.filters.echoFilter.delay.fadeFilterParameter(
      to: delayTime / 1000.0,
      time: _filterFadeTime,
    );
    emit(state.copyWith(delayTime: delayTime.toDouble()));
  }

  void setDelayDecay(num delayDecay) {
    _soloud.filters.echoFilter.decay.fadeFilterParameter(
      to: delayDecay.toDouble(),
      time: _filterFadeTime,
    );
    emit(state.copyWith(delayDecay: delayDecay.toDouble()));
  }
}

@CopyWith()
class SequencerState {
  final int step;
  final List<Set<int>> steps;
  final Set<int> availableNotes;
  final Set<(int, int)> activeNotes;
  final int attack;
  final int sustain;
  final int release;

  final bool delayActive;
  // ms
  final double delayTime;

  /// 0 - 1
  final double delayDecay;

  const SequencerState({
    this.step = 0,
    this.steps = const [],
    this.availableNotes = const {},
    this.activeNotes = const {},
    this.attack = 200,
    this.sustain = 500,
    this.release = 300,
    this.delayActive = false,
    this.delayTime = 200,
    this.delayDecay = 0.7,
  });

  int get totalNoteLength => attack + sustain + release;

  factory SequencerState.initial() => SequencerState(
    step: 0,
    steps: List.generate(8, (_) => {}),
    availableNotes: majorScale(Notes.a4),
  );

  SequencerState setStepNote({
    required int step,
    required int note,
    required bool active,
  }) => copyWith(
    steps: [...steps]
      ..[step] = active
          ? {...steps[step], note}
          : {...steps[step].where((e) => e != note)},
  );

  SequencerState setNoteActive({
    required int step,
    required int note,
    required bool active,
  }) => copyWith(
    activeNotes: {
      ...activeNotes.where((e) => e != (step, note)),
      if (active) (step, note),
    },
  );

  SequencerState setNotesActive({
    required int step,
    required Set<int> notes,
    required bool active,
  }) => copyWith(
    activeNotes: {
      ...activeNotes.where((e) => e.$1 != step && !notes.contains(e.$2)),
      if (active) ...notes.map((e) => (step, e)),
    },
  );
}
