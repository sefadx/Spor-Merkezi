import 'package:flutter/material.dart';
import '../model/table_model.dart';

class ViewModelTable extends ChangeNotifier {
  int? selectedDayIndex, selectedActivityIndex;
  List<int> daysOff = [];
  final TableModel table = TableModel();
  void setActivity(Activity type, int dayIndex, int activityIndex) {
    table.week.days[dayIndex].activities[activityIndex] = type;
    notifyListeners();
  }

  void setDaysOff(int dayIndex) {
    if (getDaysOff(dayIndex)) {
      daysOff.removeAt(daysOff.indexWhere((e) => e == dayIndex));
    } else {
      daysOff.add(dayIndex);
    }
    notifyListeners();
  }

  bool getDaysOff(int dayIndex) => daysOff.firstWhere((e) => e == dayIndex, orElse: () => -1) == -1 ? false : true;

  void addWeekToList() {}
}
