import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../controller/app_state.dart';

// ------------------------------------------------------------------------------
///
DateFormat format = DateFormat('dd/MM/yyyy');

//------------------------------------------------------------------------------
/// Tarih Seçme Widget (fonksiyon)
Future<DateTime> selectDate(BuildContext context, {DateTime? initialDate, DateTime? firstDate, DateTime? lastDate}) async => showDatePicker(
        context: context,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        initialDate: initialDate ?? DateTime.now(),
        firstDate: firstDate ?? DateTime.utc(1900),
        lastDate: lastDate ?? DateTime.now(),
        builder: (BuildContext context, Widget? widget) => Theme(
            data: ThemeData(
                colorScheme: AppState.instance.themeData.colorScheme,
                datePickerTheme: DatePickerThemeData(
                    backgroundColor: AppState.instance.themeData.primaryColorDark,
                    dividerColor: AppState.instance.themeData.primaryColorDark,
                    headerBackgroundColor: AppState.instance.themeData.primaryColorLight,
                    headerForegroundColor: AppState.instance.themeData.primaryColorDark)),
            child: widget!)).then((DateTime? selected) {
      return selected ?? DateTime.now();
    });

//------------------------------------------------------------------------------
// Saat Seçme Widget (fonksiyon)
Future<TimeOfDay> selectTime(BuildContext context, {TimeOfDay? initialTime}) async => showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.inputOnly,
      initialTime: initialTime ?? TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: 00),
      builder: (BuildContext context, Widget? widget) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: Theme(
          data: ThemeData(
            colorScheme: AppState.instance.themeData.colorScheme,
            timePickerTheme: TimePickerThemeData(
              backgroundColor: AppState.instance.themeData.primaryColorDark,
              dialHandColor: AppState.instance.themeData.primaryColorLight,
              hourMinuteColor: AppState.instance.themeData.primaryColorDark,
              hourMinuteTextColor: AppState.instance.themeData.primaryColorLight,
            ),
          ),
          child: widget!,
        ),
      ),
    ).then((TimeOfDay? selected) {
      return selected ?? TimeOfDay.now();
    });

//------------------------------------------------------------------------------
/// TC KİMLİK NO DOĞRULAMA ALGORİTMASI (validator)
String? validateTcKimlik(String? value) {
  if (value == null || value.isEmpty) {
    return 'T.C. Kimlik Numarası giriniz';
  }
  if (!RegExp(r'^[1-9][0-9]{10}$').hasMatch(value)) {
    return 'Geçerli bir T.C. Kimlik Numarası giriniz';
  }

  List<int> digits = value.split('').map(int.parse).toList();

  // TCKN algoritma kontrolü
  int sumOdd = digits[0] + digits[2] + digits[4] + digits[6] + digits[8];
  int sumEven = digits[1] + digits[3] + digits[5] + digits[7];

  int check10 = ((sumOdd * 7) - sumEven) % 10;
  int check11 = (sumOdd + sumEven + digits[9]) % 10;

  if (digits[9] != check10 || digits[10] != check11) {
    return 'Geçerli bir T.C. Kimlik Numarası giriniz';
  }

  return null; // Geçerli ise hata mesajı dönmez
}

/// TELEFON NO DOĞRULAMA ALGORİTMASI (validator)
String? validatePhoneNo(String? phoneNo) {
  if (phoneNo == null || !RegExp(r'^(?:\+90.?5|0090.?5|905|0?5)(?:[01345][0-9])\s?(?:[0-9]{3})\s?(?:[0-9]{2})\s?(?:[0-9]{2})$').hasMatch(phoneNo)) {
    return 'Geçersiz TC Kimlik Numarası';
  }
  return null;
}
