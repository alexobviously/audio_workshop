// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sequencer.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SequencerStateCWProxy {
  SequencerState step(int step);

  SequencerState steps(List<Set<int>> steps);

  SequencerState availableNotes(Set<int> availableNotes);

  SequencerState activeNotes(Set<(int, int)> activeNotes);

  SequencerState attack(int attack);

  SequencerState sustain(int sustain);

  SequencerState release(int release);

  SequencerState delayActive(bool delayActive);

  SequencerState delayTime(double delayTime);

  SequencerState delayDecay(double delayDecay);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `SequencerState(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// SequencerState(...).copyWith(id: 12, name: "My name")
  /// ```
  SequencerState call({
    int step,
    List<Set<int>> steps,
    Set<int> availableNotes,
    Set<(int, int)> activeNotes,
    int attack,
    int sustain,
    int release,
    bool delayActive,
    double delayTime,
    double delayDecay,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfSequencerState.copyWith(...)` or call `instanceOfSequencerState.copyWith.fieldName(value)` for a single field.
class _$SequencerStateCWProxyImpl implements _$SequencerStateCWProxy {
  const _$SequencerStateCWProxyImpl(this._value);

  final SequencerState _value;

  @override
  SequencerState step(int step) => call(step: step);

  @override
  SequencerState steps(List<Set<int>> steps) => call(steps: steps);

  @override
  SequencerState availableNotes(Set<int> availableNotes) =>
      call(availableNotes: availableNotes);

  @override
  SequencerState activeNotes(Set<(int, int)> activeNotes) =>
      call(activeNotes: activeNotes);

  @override
  SequencerState attack(int attack) => call(attack: attack);

  @override
  SequencerState sustain(int sustain) => call(sustain: sustain);

  @override
  SequencerState release(int release) => call(release: release);

  @override
  SequencerState delayActive(bool delayActive) =>
      call(delayActive: delayActive);

  @override
  SequencerState delayTime(double delayTime) => call(delayTime: delayTime);

  @override
  SequencerState delayDecay(double delayDecay) => call(delayDecay: delayDecay);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `SequencerState(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// SequencerState(...).copyWith(id: 12, name: "My name")
  /// ```
  SequencerState call({
    Object? step = const $CopyWithPlaceholder(),
    Object? steps = const $CopyWithPlaceholder(),
    Object? availableNotes = const $CopyWithPlaceholder(),
    Object? activeNotes = const $CopyWithPlaceholder(),
    Object? attack = const $CopyWithPlaceholder(),
    Object? sustain = const $CopyWithPlaceholder(),
    Object? release = const $CopyWithPlaceholder(),
    Object? delayActive = const $CopyWithPlaceholder(),
    Object? delayTime = const $CopyWithPlaceholder(),
    Object? delayDecay = const $CopyWithPlaceholder(),
  }) {
    return SequencerState(
      step: step == const $CopyWithPlaceholder() || step == null
          ? _value.step
          // ignore: cast_nullable_to_non_nullable
          : step as int,
      steps: steps == const $CopyWithPlaceholder() || steps == null
          ? _value.steps
          // ignore: cast_nullable_to_non_nullable
          : steps as List<Set<int>>,
      availableNotes:
          availableNotes == const $CopyWithPlaceholder() ||
              availableNotes == null
          ? _value.availableNotes
          // ignore: cast_nullable_to_non_nullable
          : availableNotes as Set<int>,
      activeNotes:
          activeNotes == const $CopyWithPlaceholder() || activeNotes == null
          ? _value.activeNotes
          // ignore: cast_nullable_to_non_nullable
          : activeNotes as Set<(int, int)>,
      attack: attack == const $CopyWithPlaceholder() || attack == null
          ? _value.attack
          // ignore: cast_nullable_to_non_nullable
          : attack as int,
      sustain: sustain == const $CopyWithPlaceholder() || sustain == null
          ? _value.sustain
          // ignore: cast_nullable_to_non_nullable
          : sustain as int,
      release: release == const $CopyWithPlaceholder() || release == null
          ? _value.release
          // ignore: cast_nullable_to_non_nullable
          : release as int,
      delayActive:
          delayActive == const $CopyWithPlaceholder() || delayActive == null
          ? _value.delayActive
          // ignore: cast_nullable_to_non_nullable
          : delayActive as bool,
      delayTime: delayTime == const $CopyWithPlaceholder() || delayTime == null
          ? _value.delayTime
          // ignore: cast_nullable_to_non_nullable
          : delayTime as double,
      delayDecay:
          delayDecay == const $CopyWithPlaceholder() || delayDecay == null
          ? _value.delayDecay
          // ignore: cast_nullable_to_non_nullable
          : delayDecay as double,
    );
  }
}

extension $SequencerStateCopyWith on SequencerState {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfSequencerState.copyWith(...)` or `instanceOfSequencerState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SequencerStateCWProxy get copyWith => _$SequencerStateCWProxyImpl(this);
}
