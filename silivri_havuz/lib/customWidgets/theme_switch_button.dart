import 'package:flutter/material.dart';
import '../../controller/app_state.dart';
import '../controller/app_theme.dart';
import '../controller/provider.dart';

class ThemeSwitchButton extends StatelessWidget {
  const ThemeSwitchButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.light_mode, color: Colors.amber),
      Switch.adaptive(
        value: appState.colorMode == ColorMode.dark,
        onChanged: (value) => appState.toggleColorMode(),
        activeColor: Colors.white, // Açık temada switch rengi
        activeTrackColor: Colors.grey, // Açık temada arka plan
        inactiveThumbColor: Colors.black, // Koyu temada switch rengi
        inactiveTrackColor: Colors.white54, // Koyu temada arka plan
      ),
      const Icon(Icons.dark_mode, color: Colors.grey)
    ]);
  }
}
