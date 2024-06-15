import 'package:flutter/material.dart';

class SettingsDrawer extends StatelessWidget {
  final int tickCount;
  final ValueChanged<int> onTickCountChanged;
  final VoidCallback onPickBorderColor;
  final VoidCallback onPickFillColor;

  const SettingsDrawer({
    super.key,
    required this.tickCount,
    required this.onTickCountChanged,
    required this.onPickBorderColor,
    required this.onPickFillColor,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
            onTap: onPickBorderColor,
          ),
          ListTile(
            title: const Text('Pick Fill Color'),
            onTap: onPickFillColor,
          ),
          ListTile(
            title: const Text('Tick Count'),
            trailing: DropdownButton<int>(
              value: tickCount,
              onChanged: (newValue) {
                if (newValue != null) {
                  onTickCountChanged(newValue);
                }
              },
              items: <int>[3, 4, 5, 6, 7, 8, 9, 10].map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
