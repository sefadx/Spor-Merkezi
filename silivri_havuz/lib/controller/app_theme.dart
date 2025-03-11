import 'package:flutter/material.dart';
import 'package:silivri_havuz/controller/app_state.dart';
import 'package:silivri_havuz/controller/provider.dart';

enum ColorMode { light, dark }

class AppTheme {
  // Renkler
  static const Color primaryColor = Color(0xFF455A64);
  //static const Color lightPrimaryColor = Color(0xFFbce9ff);
  static const Color lightPrimaryColor = Color(0xFF03A9F4);
  static const Color darkPrimaryColor = Color(0xFF004d63);
  static const Color accentColor = Color(0xFF03A9F4);

  static const Color textColor = Color(0xFFFFFFFF);
  static const Color textDarkColor = Color(0xFF212121);
  static const Color textLightColor = Color(0xFF757575);

  static const Color dividerColor = Color(0xFFBDBDBD);

  static const Color buttonColor = Color(0xFFb4cad5);
  static const Color buttonDarkColor = Color(0xFF31464f);
  static const Color buttonLightColor = Color(0xFFd4f0ff);

  ///gapxxsmall = 2;
  static const double gapxxsmall = 2;

  ///gapxsmall = 5;
  static const double gapxsmall = 5;

  ///gapsmall = 10;
  static const double gapsmall = 10;

  ///gapmedium = 15;
  static const double gapmedium = 15;

  ///gaplarge = 20;
  static const double gaplarge = 20;

  ///gapxlarge = 40;
  static const double gapxlarge = 40;

  ///gapxxlarge = 60;
  static const double gapxxlarge = 60;

  ///Home Body Padding EdgeInsets
  static const EdgeInsets homeEdgeInsets = EdgeInsets.symmetric(vertical: gapxxsmall, horizontal: gapmedium);

  ///radiussmall = 8;
  static const double radiussmall = 8;

  ///radiusmedium = 12;
  static const double radiusmedium = 12;

  ///radiuslarge = 16;
  static const double radiuslarge = 16;

  // Yazı Tipi Stilleri
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );
  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  // Dekorasyonlar: UI öğelerinde kullanmak için
  // Bu fonksiyonlar, geçerli temaya göre (light/dark) dekorasyonu ayarlar.
  static BoxDecoration buttonPrimaryDecoration(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return BoxDecoration(
      color: appState.colorMode == ColorMode.light ? buttonLightColor : buttonDarkColor,
      borderRadius: BorderRadius.circular(radiussmall),
    );
  }

  static BoxDecoration buttonSecondaryDecoration(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return BoxDecoration(
      color: appState.colorMode == ColorMode.light ? buttonColor : buttonDarkColor,
      borderRadius: BorderRadius.circular(radiussmall),
    );
  }

  static BoxDecoration listItemDecoration(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return BoxDecoration(
      color: appState.themeData.primaryColorLight,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 7)],
    );
  }

  // Açık Tema (Light Theme)
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      primaryColorDark: darkPrimaryColor,
      primaryColorLight: lightPrimaryColor,
      // accentColor deprecated, kullanılması gerekiyorsa colorScheme üzerinden tanımlanabilir.
      scaffoldBackgroundColor: lightPrimaryColor,
      textTheme: TextTheme(
        headlineLarge: headlineLarge.copyWith(color: textDarkColor),
        headlineMedium: headlineMedium.copyWith(color: textDarkColor),
        headlineSmall: headlineSmall.copyWith(color: textDarkColor),
        bodyLarge: bodyLarge.copyWith(color: textDarkColor),
        bodyMedium: bodyMedium.copyWith(color: textDarkColor),
        bodySmall: bodySmall.copyWith(color: textDarkColor),
        labelLarge: buttonTextStyle.copyWith(color: textLightColor),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: lightPrimaryColor,
        titleTextStyle: headlineMedium.copyWith(color: textDarkColor),
        iconTheme: const IconThemeData(color: textDarkColor),
      ),
      iconTheme: const IconThemeData(color: textDarkColor),
      buttonTheme: ButtonThemeData(
        buttonColor: lightPrimaryColor,
        textTheme: ButtonTextTheme.primary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        prefixIconColor: textDarkColor,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: darkPrimaryColor, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // Koyu Tema (Dark Theme)
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      primaryColorDark: lightPrimaryColor,
      primaryColorLight: darkPrimaryColor,
      scaffoldBackgroundColor: darkPrimaryColor,
      textTheme: TextTheme(
        headlineLarge: headlineLarge.copyWith(color: textColor),
        headlineMedium: headlineMedium.copyWith(color: textColor),
        headlineSmall: headlineSmall.copyWith(color: textColor),
        bodyLarge: bodyLarge.copyWith(color: textColor),
        bodyMedium: bodyMedium.copyWith(color: textColor),
        bodySmall: bodySmall.copyWith(color: textColor),
        labelLarge: buttonTextStyle.copyWith(color: textDarkColor),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkPrimaryColor,
        titleTextStyle: headlineMedium.copyWith(color: textLightColor),
        iconTheme: const IconThemeData(color: textLightColor),
      ),
      iconTheme: const IconThemeData(color: textColor),
      buttonTheme: const ButtonThemeData(
        buttonColor: darkPrimaryColor,
        textTheme: ButtonTextTheme.primary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        prefixIconColor: textColor,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: lightPrimaryColor, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

/*
class AppTheme {
  static const Color primaryColor = Color(0xFF455A64);
  static const Color lightPrimaryColor = Color(0xFFbce9ff);
  static const Color darkPrimaryColor = Color(0xFF004d63);

  static const Color accentColor = Color(0xFF03A9F4);

  static const Color textColor = Color(0xFFFFFFFF);
  static const Color textDarkColor = Color(0xFF212121);
  static const Color textLightColor = Color(0xFF757575);

  static const Color dividerColor = Color(0xFFBDBDBD);

  static const Color buttonColor = Color(0xFFb4cad5);
  static const Color buttonDarkColor = Color(0xFF31464f);
  static const Color buttonLightColor = Color(0xFFd4f0ff);

  static BoxDecoration buttonPrimaryDecoration = BoxDecoration(
      color: AppState.instance.colorMode == ColorMode.light ? buttonLightColor : buttonDarkColor, borderRadius: BorderRadius.circular(radiussmall));

  static BoxDecoration buttonSecondaryDecoration = BoxDecoration(
      color: AppState.instance.colorMode == ColorMode.light ? buttonColor : buttonDarkColor, borderRadius: BorderRadius.circular(radiussmall));

  static BoxDecoration listItemDecoration = BoxDecoration(
      color: AppState.instance.themeData.primaryColorLight,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 7)]);

  ///gapxxsmall = 2;
  static const double gapxxsmall = 2;

  ///gapxsmall = 5;
  static const double gapxsmall = 5;

  ///gapsmall = 10;
  static const double gapsmall = 10;

  ///gapmedium = 15;
  static const double gapmedium = 15;

  ///gaplarge = 20;
  static const double gaplarge = 20;

  ///gapxlarge = 40;
  static const double gapxlarge = 40;

  ///gapxxlarge = 60;
  static const double gapxxlarge = 60;

  ///radiussmall = 8;
  static const double radiussmall = 8;

  ///radiusmedium = 12;
  static const double radiusmedium = 12;

  ///radiuslarge = 16;
  static const double radiuslarge = 16;

  // Ortak Yazı Tipi Stilleri
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle button = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  // Açık Tema Tanımı
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      primaryColorDark: darkPrimaryColor,
      primaryColorLight: lightPrimaryColor,
      hintColor: accentColor,
      scaffoldBackgroundColor: lightPrimaryColor,
      textTheme: TextTheme(
        headlineLarge: headlineLarge.copyWith(color: textDarkColor),
        headlineMedium: headlineMedium.copyWith(color: textDarkColor),
        headlineSmall: headlineSmall.copyWith(color: textDarkColor),
        bodyLarge: bodyLarge.copyWith(color: textDarkColor),
        bodyMedium: bodyMedium.copyWith(color: textDarkColor),
        bodySmall: bodySmall.copyWith(color: textDarkColor),
        labelLarge: button.copyWith(color: textLightColor),
      ),
      appBarTheme: AppBarTheme(
        color: lightPrimaryColor,
        titleTextStyle: headlineMedium.copyWith(color: lightPrimaryColor),
        iconTheme: const IconThemeData(color: lightPrimaryColor),
      ),
      iconTheme: const IconThemeData(color: textDarkColor),
      buttonTheme: const ButtonThemeData(
        buttonColor: lightPrimaryColor,
        textTheme: ButtonTextTheme.primary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        prefixIconColor: textDarkColor,
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: darkPrimaryColor, width: 2), borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // Koyu Tema Tanımı
  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: primaryColor,
      primaryColorDark: lightPrimaryColor,
      primaryColorLight: darkPrimaryColor,
      hintColor: accentColor,
      scaffoldBackgroundColor: darkPrimaryColor,
      textTheme: TextTheme(
        headlineLarge: headlineLarge.copyWith(color: textColor),
        headlineMedium: headlineMedium.copyWith(color: textColor),
        headlineSmall: headlineSmall.copyWith(color: textColor),
        bodyLarge: bodyLarge.copyWith(color: textColor),
        bodyMedium: bodyMedium.copyWith(color: textColor),
        bodySmall: bodySmall.copyWith(color: textColor),
        labelLarge: button.copyWith(color: textDarkColor),
      ),
      iconTheme: const IconThemeData(color: textColor),
      appBarTheme: AppBarTheme(
        color: darkPrimaryColor,
        titleTextStyle: headlineMedium.copyWith(color: textLightColor),
        iconTheme: const IconThemeData(color: textLightColor),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: darkPrimaryColor,
        textTheme: ButtonTextTheme.primary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        prefixIconColor: textColor,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: lightPrimaryColor, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
*/
