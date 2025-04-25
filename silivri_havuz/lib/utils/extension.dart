import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controller/app_state.dart';
import '../controller/provider.dart';

// ------------------------------------------------------------------------------

DateFormat dateFormat = DateFormat('dd/MM/yyyy');
DateFormat dayFormat = DateFormat('EEEE', 'tr_TR');
DateFormat timeFormat = DateFormat('HH:mm');

//------------------------------------------------------------------------------
/// Tarih Seçme Widget (fonksiyon)
Future<DateTime?> selectDate(BuildContext context,
    {DateTime? initialDate, DateTime? firstDate, DateTime? lastDate, bool Function(DateTime)? selectableDayPredicate}) async {
  final appState = Provider.of<AppState>(context);

  return showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime.utc(1900),
      lastDate: lastDate ?? DateTime.now().toUtc(),
      selectableDayPredicate: selectableDayPredicate,
      builder: (BuildContext context, Widget? widget) => Theme(
          data: ThemeData(
              colorScheme: appState.themeData.colorScheme,
              datePickerTheme: DatePickerThemeData(
                  backgroundColor: appState.themeData.primaryColorDark,
                  dividerColor: appState.themeData.primaryColorDark,
                  headerBackgroundColor: appState.themeData.primaryColorLight,
                  headerForegroundColor: appState.themeData.primaryColorDark)),
          child: widget!)).then((DateTime? selected) {
    return selected != null ? DateTime.utc(selected.year, selected.month, selected.day) : null;
  });
}

void pickDate(BuildContext context, {required TextEditingController controller}) async {
  //DateTime? date = await selectDate(context, initialDate: controller.text != "" ? dateFormat.parse(controller.text) : null, lastDate: DateTime.now().add(const Duration(days: 90)));
  DateTime? date = await selectDate(context, initialDate: DateTime.now().toUtc(), lastDate: DateTime.now().add(const Duration(days: 90)));
  controller.text = date != null ? dateFormat.format(date) : "";
}

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
    return 'Geçersiz TC Kimlik Numarası';
  }

  List<int> digits = value.split('').map(int.parse).toList();

  // TCKN algoritma kontrolü
  int sumOdd = digits[0] + digits[2] + digits[4] + digits[6] + digits[8];
  int sumEven = digits[1] + digits[3] + digits[5] + digits[7];

  int check10 = ((sumOdd * 7) - sumEven) % 10;
  int check11 = (sumOdd + sumEven + digits[9]) % 10;

  if (digits[9] != check10 || digits[10] != check11) {
    return 'Geçersiz TC Kimlik Numarası';
  }

  return null; // Geçerli ise hata mesajı dönmez
}

/// TELEFON NO DOĞRULAMA ALGORİTMASI (validator)
String? validatePhoneNo(String? phoneNo) {
  if (phoneNo == null || phoneNo.isEmpty) {
    return 'Telefon numarası gerekli';
  }
  if (phoneNo == null || !RegExp(r'^(?:\+90.?5|0090.?5|905|0?5)(?:[01345][0-9])\s?(?:[0-9]{3})\s?(?:[0-9]{2})\s?(?:[0-9]{2})$').hasMatch(phoneNo)) {
    return 'Geçersiz Telefon Numarası';
  }
  return null;
}

///Mail adresi tipi doğrulama
String? validateMailAddress(String? value) {
  if (value == null || value.isEmpty) {
    return 'E-posta adresi gerekli';
  }
  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
    return 'Geçersiz E-posta Adresi';
  }
  return null;
}

String? validateDate(String? value) {
  if (value == null || value.isEmpty) {
    return 'Tarih boş olamaz';
  }

  final regex = RegExp(
      r'^(?:(?:31\/(?:0?[13578]|1[02]))|(?:(?:29|30)\/(?:0?[13-9]|1[0-2])))\/(?:[1-9]\d{3})$|^(?:29\/0?2\/(?:(?:[1-9]\d(?:0[48]|[2468][048]|[13579][26]))|(?:[1-9]\d00)))$|^(?:0?[1-9]|1\d|2[0-8])\/(?:0?[1-9]|1[0-2])\/(?:[1-9]\d{3})$');

  if (!regex.hasMatch(value)) {
    return 'Geçerli bir tarih giriniz (GG/AA/YYYY)';
  }

  return null;
}
