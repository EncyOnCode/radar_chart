import 'dart:ui' as ui;
import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void makeScreenshot(GlobalKey repaintBoundaryKey) async {
  final RenderRepaintBoundary boundary =
  repaintBoundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
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
}

void addEntry(
    List<String> titles,
    List<double> values,
    List<TextEditingController> titleControllers,
    List<TextEditingController> valueControllers,
    List<TextEditingController> angleControllers,
    List<TextEditingController> offsetControllers,
    VoidCallback updateChart,
    ) {
  titles.add('New Title');
  values.add(1.0);
  titleControllers.add(TextEditingController());
  valueControllers.add(TextEditingController());
  angleControllers.add(TextEditingController(text: '0.0'));
  offsetControllers.add(TextEditingController(text: '0.1'));
  updateChart();
}

void removeEntry(
    int index,
    List<String> titles,
    List<double> values,
    List<TextEditingController> titleControllers,
    List<TextEditingController> valueControllers,
    List<TextEditingController> angleControllers,
    List<TextEditingController> offsetControllers,
    VoidCallback updateChart,
    ) {
  if (titles.length > 3) {
    titles.removeAt(index);
    values.removeAt(index);
    titleControllers.removeAt(index).dispose();
    valueControllers.removeAt(index).dispose();
    angleControllers.removeAt(index).dispose();
    offsetControllers.removeAt(index).dispose();
    updateChart();
  }
}
