import 'package:flutter/material.dart';

const List<String> initialTitles = ['Выживаемость', 'Контроль', 'Урон', 'Помощь', 'Лечение'];
const List<double> initialValues = [1.0, 1.0, 1.0, 1.0, 1.0];

final List<TextEditingController> initialTitleControllers = [
  TextEditingController(text: 'Выживаемость'),
  TextEditingController(text: 'Контроль'),
  TextEditingController(text: 'Урон'),
  TextEditingController(text: 'Помощь'),
  TextEditingController(text: 'Лечение')
];
final List<TextEditingController> initialValueControllers = [
  TextEditingController(text: '1.0'),
  TextEditingController(text: '1.0'),
  TextEditingController(text: '1.0'),
  TextEditingController(text: '1.0'),
  TextEditingController(text: '1.0')
];

final List<TextEditingController> initialAngleControllers = [
  TextEditingController(text: '0.0'),
  TextEditingController(text: '0.0'),
  TextEditingController(text: '0.0'),
  TextEditingController(text: '0.0'),
  TextEditingController(text: '0.0')
];
final List<TextEditingController> initialOffsetControllers = [
  TextEditingController(text: '0.1'),
  TextEditingController(text: '0.1'),
  TextEditingController(text: '0.1'),
  TextEditingController(text: '0.1'),
  TextEditingController(text: '0.1')
];

Color initialBorderColor = const Color(0xFFEE46BC);
Color initialFillColor = const Color(0xFFEE46BC).withOpacity(0.2);
int initialTickCount = 4;
