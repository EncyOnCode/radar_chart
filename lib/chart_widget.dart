import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartWidget extends StatelessWidget {
  final List<String> titles;
  final List<double> values;
  final Color borderColor;
  final Color fillColor;
  final int tickCount;
  final List<TextEditingController> angleControllers;
  final List<TextEditingController> offsetControllers;

  const ChartWidget({
    super.key,
    required this.titles,
    required this.values,
    required this.borderColor,
    required this.fillColor,
    required this.tickCount,
    required this.angleControllers,
    required this.offsetControllers,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: RadarChart(
        RadarChartData(
          radarShape: RadarShape.polygon,
          getTitle: (index, angle) {
            return RadarChartTitle(
              angle: double.parse(angleControllers[index].text),
              text: titles[index],
              positionPercentageOffset: double.parse(offsetControllers[index].text),
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
          tickCount: tickCount,
          dataSets: [
            RadarDataSet(
              borderColor: borderColor,
              borderWidth: 4,
              entryRadius: 8,
              fillColor: fillColor,
              dataEntries: values.map((value) => RadarEntry(value: value)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
