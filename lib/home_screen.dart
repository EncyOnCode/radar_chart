import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

import 'chart_widget.dart';
import 'settings_drawer.dart';
import 'constants.dart';
import 'chart_methods.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey _repaintBoundaryKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> _titles = List.from(initialTitles);
  final List<double> _values = List.from(initialValues);

  final List<TextEditingController> _titleControllers =
      List.from(initialTitleControllers);
  final List<TextEditingController> _valueControllers =
      List.from(initialValueControllers);
  final List<TextEditingController> _angleControllers =
      List.from(initialAngleControllers);
  final List<TextEditingController> _offsetControllers =
      List.from(initialOffsetControllers);

  Color _borderColor = initialBorderColor;
  Color _fillColor = initialFillColor;
  int _tickCount = initialTickCount;

  void _updateChart() {
    setState(() {});
  }

  void _pickBorderColor() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick Border Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              color: _borderColor,
              pickersEnabled: const <ColorPickerType, bool>{
                ColorPickerType.both: false,
                ColorPickerType.primary: false,
                ColorPickerType.accent: false,
                ColorPickerType.bw: false,
                ColorPickerType.custom: false,
                ColorPickerType.wheel: true,
              },
              width: 40,
              height: 40,
              borderRadius: 4,
              spacing: 5,
              runSpacing: 5,
              wheelDiameter: 155,
              copyPasteBehavior: const ColorPickerCopyPasteBehavior(
                ctrlC: true,
                ctrlV: true,
                pasteButton: true,
                longPressMenu: true,
                snackBarParseError: true,
                snackBarDuration: Duration(seconds: 1),
              ),
              enableOpacity: true,
              heading: Text(
                'Select color',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              subheading: Text(
                'Select color shade',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              wheelSubheading: Text(
                'Selected color and its shades',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              onColorChanged: (color) {
                setState(() {
                  _borderColor = color;
                });
              },
            ),
          ),
          actions: [
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _pickFillColor() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick Fill Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickersEnabled: const <ColorPickerType, bool>{
                ColorPickerType.both: false,
                ColorPickerType.primary: false,
                ColorPickerType.accent: false,
                ColorPickerType.bw: false,
                ColorPickerType.custom: false,
                ColorPickerType.wheel: true,
              },
              width: 40,
              height: 40,
              borderRadius: 4,
              spacing: 5,
              runSpacing: 5,
              wheelDiameter: 155,
              copyPasteBehavior: const ColorPickerCopyPasteBehavior(
                ctrlC: true,
                ctrlV: true,
                pasteButton: true,
                longPressMenu: true,
                snackBarParseError: true,
                snackBarDuration: Duration(seconds: 1),
              ),
              enableOpacity: true,
              heading: Text(
                'Select color',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              subheading: Text(
                'Select color shade',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              wheelSubheading: Text(
                'Selected color and its shades',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              color: _fillColor,
              onColorChanged: (color) {
                setState(() {
                  _fillColor = color;
                });
              },
            ),
          ),
          actions: [
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Radar Chart Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: SettingsDrawer(
        tickCount: _tickCount,
        onTickCountChanged: (newTickCount) {
          setState(() {
            _tickCount = newTickCount;
          });
        },
        onPickBorderColor: _pickBorderColor,
        onPickFillColor: _pickFillColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            RepaintBoundary(
              key: _repaintBoundaryKey,
              child: ChartWidget(
                titles: _titles,
                values: _values,
                borderColor: _borderColor,
                fillColor: _fillColor,
                tickCount: _tickCount,
                angleControllers: _angleControllers,
                offsetControllers: _offsetControllers,
              ),
            ),
            const SizedBox(height: 20),
            ..._buildTitleFields(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => addEntry(
                _titles,
                _values,
                _titleControllers,
                _valueControllers,
                _angleControllers,
                _offsetControllers,
                _updateChart,
              ),
              child: const Text('Add Entry'),
            ),
            const SizedBox(height: 4),
            ElevatedButton(
              onPressed: () => makeScreenshot(_repaintBoundaryKey),
              child: const Text('Save Screenshot'),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTitleFields() {
    List<Widget> fields = [];
    for (int i = 0; i < _titles.length; i++) {
      fields.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _titleControllers[i],
                  decoration: const InputDecoration(labelText: 'Title'),
                  onChanged: (value) {
                    _titles[i] = value;
                    _updateChart();
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _valueControllers[i],
                  decoration: const InputDecoration(labelText: 'Value'),
                  onChanged: (value) {
                    _values[i] = double.tryParse(value) ?? 0.0;
                    _updateChart();
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: _angleControllers[i],
                  decoration: const InputDecoration(labelText: 'Angle'),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: _offsetControllers[i],
                  decoration: const InputDecoration(labelText: 'Offset'),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => removeEntry(
                  i,
                  _titles,
                  _values,
                  _titleControllers,
                  _valueControllers,
                  _angleControllers,
                  _offsetControllers,
                  _updateChart,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return fields;
  }

  @override
  void dispose() {
    for (var controller in _titleControllers) {
      controller.dispose();
    }
    for (var controller in _valueControllers) {
      controller.dispose();
    }
    for (var controller in _angleControllers) {
      controller.dispose();
    }
    for (var controller in _offsetControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
