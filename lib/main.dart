import 'package:audio_workshop/sequencer.dart';
import 'package:audio_workshop/utils/midi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SoLoud.instance.init();
  // final filters = SoLoud.instance.filters;
  // filters.freeverbFilter.activate();
  // filters.freeverbFilter
  //   ..roomSize.value = 0.5
  //   ..damp.value = 0.6
  //   ..width.value = 1.0;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _sequencer = Sequencer();

  @override
  Widget build(BuildContext context) {
    final activeColor = Colors.purple.shade300;
    final inactiveColor = Colors.black12;
    final playingColor = Colors.purple.shade100;

    return Scaffold(
      body: BlocBuilder<Sequencer, SequencerState>(
        bloc: _sequencer,
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final seqWidth = state.steps.length * 56;
              final wideLayout = constraints.maxWidth > seqWidth + 200;

              return Center(
                child: Flex(
                  direction: wideLayout ? Axis.horizontal : Axis.vertical,
                  children: [
                    if (wideLayout) _SettingsPanel(sequencer: _sequencer),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: .center,
                        children: [
                          Row(
                            mainAxisAlignment: .center,
                            children: [
                              Container(
                                width: 48,
                                margin: const .all(4),
                              ),
                              for (final (i, _) in state.steps.indexed)
                                Container(
                                  width: 48,
                                  height: 16,
                                  margin: const .all(4),
                                  decoration: BoxDecoration(
                                    color: i == state.step
                                        ? activeColor
                                        : inactiveColor,
                                    borderRadius: .circular(16),
                                  ),
                                ),
                            ],
                          ),
                          for (final note in state.availableNotes)
                            Row(
                              mainAxisAlignment: .center,
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  margin: const .all(4),
                                  padding: const .all(4),
                                  decoration: BoxDecoration(
                                    color: inactiveColor,
                                    borderRadius: .circular(16),
                                  ),
                                  child: FittedBox(
                                    child: Text(stringFromNote(note)),
                                  ),
                                ),
                                for (final (i, step) in state.steps.indexed)
                                  GestureDetector(
                                    onTap: () => _sequencer.setStepNote(
                                      step: i,
                                      note: note,
                                      active: !step.contains(note),
                                    ),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      width: 48,
                                      height: 48,
                                      margin: const .all(4),
                                      decoration: BoxDecoration(
                                        color: step.contains(note)
                                            ? state.activeNotes.contains((
                                                    i,
                                                    note,
                                                  ))
                                                  ? playingColor
                                                  : activeColor
                                            : inactiveColor,
                                        borderRadius: .circular(16),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          if (!wideLayout)
                            _SettingsPanel(sequencer: _sequencer),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _SliderSetting extends StatelessWidget {
  final String label;
  final num value;
  final double min;
  final double max;
  final void Function(num value) onChanged;
  final bool active;

  const _SliderSetting({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.active = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$label: $value ms'),
        Slider(
          value: value.toDouble(),
          min: min,
          max: max,
          onChanged: active
              ? (value) => onChanged(value.clamp(min, max).toInt())
              : null,
        ),
      ],
    );
  }
}

class _SettingsPanel extends StatelessWidget {
  final Sequencer sequencer;

  const _SettingsPanel({
    required this.sequencer,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Sequencer, SequencerState>(
      bloc: sequencer,
      builder: (context, state) {
        return Container(
          width: 300,
          decoration: BoxDecoration(
            borderRadius: .circular(16),
            border: .all(color: Colors.grey),
          ),
          margin: const .all(16),
          padding: const .all(16),
          child: Column(
            spacing: 4,
            children: [
              _SliderSetting(
                label: 'Attack',
                value: state.attack,
                min: 100,
                max: 1000,
                onChanged: sequencer.setAttack,
              ),
              _SliderSetting(
                label: 'Sustain',
                value: state.sustain,
                min: 100,
                max: 1000,
                onChanged: sequencer.setSustain,
              ),
              _SliderSetting(
                label: 'Release',
                value: state.release,
                min: 100,
                max: 1000,
                onChanged: sequencer.setRelease,
              ),
              // buggy
              // _DelaySettings(sequencer: sequencer),
            ],
          ),
        );
      },
    );
  }
}

class _DelaySettings extends StatelessWidget {
  final Sequencer sequencer;
  const _DelaySettings({required this.sequencer});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Sequencer, SequencerState>(
      bloc: sequencer,
      builder: (context, state) {
        return Column(
          children: [
            SwitchListTile(
              value: state.delayActive,
              onChanged: sequencer.setDelayActive,
              title: const Text('Delay Active'),
            ),
            _SliderSetting(
              label: 'Delay Time',
              value: state.delayTime,
              min: 100,
              max: 1000,
              onChanged: sequencer.setDelayTime,
              active: state.delayActive,
            ),
            _SliderSetting(
              label: 'Delay Decay',
              value: state.delayDecay * 100,
              min: 0,
              max: 100,
              onChanged: (value) => sequencer.setDelayDecay(value / 100),
              active: state.delayActive,
            ),
          ],
        );
      },
    );
  }
}
