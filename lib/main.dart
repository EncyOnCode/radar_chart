import 'dart:ui' as ui;
import 'dart:html' as html;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: _HomeScreen(),
    );
  }
}

class _HomeScreen extends StatefulWidget {
  const _HomeScreen({super.key});

  @override
  State<_HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen> {
  final GlobalKey _repaintBoundaryKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> _titles = ['Title 1', 'Title 2', 'Title 3'];
  final List<double> _values = [1.0, 1.0, 1.0];
  final List<TextEditingController> _titleControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];
  final List<TextEditingController> _valueControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  Color _borderColor = const Color(0xFFEE46BC);
  Color _fillColor = const Color(0xFFEE46BC).withOpacity(0.2);
  int _tickCount = 4;
  Color dialogPickerColor = const Color(0xFFEE46BC).withOpacity(0.2);// Default tick count

  void _makeScreenshot() => Future(
        () async {
      final RenderRepaintBoundary boundary =
      _repaintBoundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw Exception('Failed to capture image');
      final Uint8List pngBytes = byteData.buffer.asUint8List();

      if (kIsWeb) {
        final blob = html.Blob([pngBytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', 'screenshot.png')
          ..click();
        html.Url.revokeObjectUrl(url);
      }
    },
  );

  void _addEntry() {
    setState(() {
      _titles.add('Title ${_titles.length + 1}');
      _values.add(1.0);
      _titleControllers.add(TextEditingController());
      _valueControllers.add(TextEditingController());
    });
  }

  void _updateChart() {
    setState(() {
      // Update chart based on user input
    });
  }

  void _removeEntry(int index) {
    if (_titles.length > 3) {
      setState(() {
        _titles.removeAt(index);
        _values.removeAt(index);
        _titleControllers.removeAt(index).dispose();
        _valueControllers.removeAt(index).dispose();
      });
    }
  }

  void _pickBorderColor() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick Border Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              width: 40,
              height: 40,
              borderRadius: 4,
              spacing: 5,
              runSpacing: 5,
              wheelDiameter: 155,
              pickersEnabled: const <ColorPickerType, bool>{
                ColorPickerType.both: false,
                ColorPickerType.primary: false,
                ColorPickerType.accent: false,
                ColorPickerType.bw: false,
                ColorPickerType.custom: false,
                ColorPickerType.wheel: true,
              },
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
              width: 40,
              height: 40,
              borderRadius: 4,
              spacing: 5,
              runSpacing: 5,
              wheelDiameter: 155,
              pickersEnabled: const <ColorPickerType, bool>{
                ColorPickerType.both: false,
                ColorPickerType.primary: false,
                ColorPickerType.accent: false,
                ColorPickerType.bw: false,
                ColorPickerType.custom: false,
                ColorPickerType.wheel: true,
              },
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
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Pick Border Color'),
              onTap: _pickBorderColor,
            ),
            ListTile(
              title: const Text('Pick Fill Color'),
              onTap: _pickFillColor,
            ),
            ListTile(
              title: const Text('Tick Count'),
              trailing: DropdownButton<int>(
                value: _tickCount,
                onChanged: (newValue) {
                  setState(() {
                    _tickCount = newValue!;
                  });
                },
                items: <int>[3, 4, 5, 6, 7, 8, 9, 10]
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            RepaintBoundary(
              key: _repaintBoundaryKey,
              child: SizedBox(
                height: 400,
                child: RadarChart(
                  RadarChartData(
                    radarShape: RadarShape.polygon,
                    getTitle: (index, angle) {
                      return RadarChartTitle(
                        text: _titles[index],
                        positionPercentageOffset: 0.1,
                      );
                    },
                    gridBorderData: const BorderSide(
                      color: Color(0xFFD6ECFB),
                      width: 4,
                    ),
                    radarBorderData: const BorderSide(
                      color: Color(0xFFD6ECFB),
                      width: 4,
                    ),
                    borderData: FlBorderData(
                      border: Border.all(
                        color: const Color(0xFFD6ECFB),
                        width: 4,
                      ),
                    ),
                    tickBorderData: const BorderSide(color: Color(0xFFD6ECFB), width: 4),
                    tickCount: _tickCount,
                    dataSets: [
                      RadarDataSet(
                        borderColor: _borderColor,
                        borderWidth: 4,
                        entryRadius: 8,
                        fillColor: _fillColor,
                        dataEntries: _values.map((value) => RadarEntry(value: value)).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ..._buildTitleFields(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addEntry,
              child: const Text('Add Entry'),
            ),
            const SizedBox(height: 8,),
            ElevatedButton(
              onPressed: _makeScreenshot,
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
                  decoration: InputDecoration(labelText: 'Title ${i + 1}'),
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
                  decoration: InputDecoration(labelText: 'Value ${i + 1}'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _values[i] = double.tryParse(value) ?? 1.0;
                    _updateChart();
                  },
                ),
              ),
              if (_titles.length > 3) // Display remove button only if there are more than 3 entries
                IconButton(
                  icon: const Icon(Icons.remove_circle),
                  onPressed: () => _removeEntry(i),
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
    super.dispose();
  }
}
