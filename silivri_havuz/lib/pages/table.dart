import 'package:flutter/material.dart';
import '../utils/enums.dart';
import '../utils/extension.dart';
import '../controller/app_state.dart';
import '../controller/app_theme.dart';
import '../controller/provider.dart';

class PageTable extends StatelessWidget {
  PageTable({super.key});

  final DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Material(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Ink(
                padding: const EdgeInsets.symmetric(vertical: AppTheme.gapmedium, horizontal: AppTheme.gapxsmall),
                child: Center(child: Text("SAAT\n", textAlign: TextAlign.center, style: appState.themeData.textTheme.headlineSmall))),
            ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 120),
                child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: timeSlots.length,
                    separatorBuilder: (context, index) => timeSlots.elementAt(index).isBreak
                        ? const SizedBox()
                        : Ink(
                            padding: const EdgeInsets.all(AppTheme.gapxxsmall),
                            color: Colors.grey,
                            child: Text("${timeSlots.elementAt(index).start} - ${timeSlots.elementAt(index).end}",
                                style: appState.themeData.textTheme.bodyMedium, textAlign: TextAlign.center)),
                    itemBuilder: (context, index) => timeSlots.elementAt(index).isBreak
                        ? const SizedBox()
                        : Ink(
                            padding: const EdgeInsets.symmetric(vertical: AppTheme.gaplarge, horizontal: AppTheme.gapxsmall),
                            height: 70,
                            color: appState.themeData.primaryColorLight,
                            child: Center(
                              child: Text("${timeSlots.elementAt(index).start} - ${timeSlots.elementAt(index).end}",
                                  style: appState.themeData.textTheme.bodyMedium, textAlign: TextAlign.center),
                            ))))
          ],
        ),
        Expanded(
            child: Material(
          child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.gapxsmall),
              scrollDirection: Axis.horizontal,
              itemCount: 100,
              separatorBuilder: (context, index) => const SizedBox(width: AppTheme.gapxsmall),
              itemBuilder: (context, index) {
                final dateLocal = date.add(Duration(days: index));
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Ink(
                        padding: const EdgeInsets.symmetric(vertical: AppTheme.gapmedium, horizontal: AppTheme.gapxsmall),
                        child: Text("${dateFormat.format(dateLocal)}\n${dayFormat.format(dateLocal)}",
                            textAlign: TextAlign.center, style: appState.themeData.textTheme.headlineSmall)),
                    ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 170),
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 17, //week.days.elementAt(index).activities.length,
                            itemBuilder: (context, indexActivities) =>
                                week.days.elementAt(dateLocal.weekday - 1).activities.elementAt(indexActivities) == null
                                    ? Ink(
                                        padding: const EdgeInsets.all(AppTheme.gapxxsmall),
                                        color: Colors.grey,
                                        child: Text("Seans arası", style: appState.themeData.textTheme.bodyMedium, textAlign: TextAlign.center))
                                    : Ink(
                                        padding: const EdgeInsets.symmetric(vertical: AppTheme.gapxsmall, horizontal: AppTheme.gapxsmall),
                                        height: 70,
                                        color: appState.themeData.primaryColorLight,
                                        child: Column(
                                          children: [
                                            Text(week.days.elementAt(dateLocal.weekday - 1).activities.elementAt(indexActivities)!.type.toString(),
                                                style: appState.themeData.textTheme.bodyMedium, textAlign: TextAlign.center),
                                            Text(
                                                week.days.elementAt(dateLocal.weekday - 1).activities.elementAt(indexActivities)!.ageGroup.toString(),
                                                style: appState.themeData.textTheme.bodyMedium,
                                                textAlign: TextAlign.center),
                                            Text(week.days.elementAt(dateLocal.weekday - 1).activities.elementAt(indexActivities)!.fee.toString(),
                                                style: appState.themeData.textTheme.bodyMedium, textAlign: TextAlign.center),
                                          ],
                                        ))))
                  ],
                );
              }),
        ))
      ],
    ));
  }
}

final List<TimeSlot> timeSlots = [
  TimeSlot(start: "08:30", end: "09:30", isBreak: false),
  TimeSlot(start: "09:30", end: "10:00", isBreak: true),
  TimeSlot(start: "10:00", end: "11:00", isBreak: false),
  TimeSlot(start: "11:00", end: "11:30", isBreak: true),
  TimeSlot(start: "11:30", end: "12:30", isBreak: false),
  TimeSlot(start: "12:30", end: "13:00", isBreak: true),
  TimeSlot(start: "13:00", end: "14:00", isBreak: false),
  TimeSlot(start: "14:00", end: "14:30", isBreak: true),
  TimeSlot(start: "14:30", end: "15:30", isBreak: false),
  TimeSlot(start: "15:30", end: "16:00", isBreak: true),
  TimeSlot(start: "16:00", end: "17:00", isBreak: false),
  TimeSlot(start: "17:00", end: "17:30", isBreak: true),
  TimeSlot(start: "17:30", end: "18:30", isBreak: false),
  TimeSlot(start: "18:30", end: "19:00", isBreak: true),
  TimeSlot(start: "19:00", end: "20:00", isBreak: false),
  TimeSlot(start: "20:00", end: "20:30", isBreak: true),
  TimeSlot(start: "20:30", end: "21:30", isBreak: false),
];

final Week week = Week(days: [
  Day(day: 1, activities: [
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
  ]),
  Day(day: 2, activities: [
    Activity(type: ActivityType.yetiskinKadin, ageGroup: AgeGroup.age13Plus, fee: FeeType.free),
    null,
    Activity(type: ActivityType.yetiskinKadin, ageGroup: AgeGroup.age13Plus, fee: FeeType.free),
    null,
    Activity(type: ActivityType.yetiskinKadin, ageGroup: AgeGroup.age13Plus, fee: FeeType.free),
    null,
    Activity(type: ActivityType.eykom, ageGroup: AgeGroup.age6to12, fee: FeeType.free),
    null,
    Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age4to6, fee: FeeType.free),
    null,
    Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age7to12, fee: FeeType.paid),
    null,
    Activity(type: ActivityType.yetiskinErkek, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
    null,
    Activity(type: ActivityType.yuzmeAkademisi, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
    null,
    Activity(type: ActivityType.yetiskinErkek, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid)
  ]),
  Day(day: 3, activities: [
    Activity(type: ActivityType.yetiskinErkek, ageGroup: AgeGroup.age13Plus, fee: FeeType.free),
    null,
    Activity(type: ActivityType.eykom, ageGroup: AgeGroup.age13Plus, fee: FeeType.free),
    null,
    Activity(type: ActivityType.eykom, ageGroup: AgeGroup.age6to12, fee: FeeType.free),
    null,
    Activity(type: ActivityType.eykom, ageGroup: AgeGroup.age6to12, fee: FeeType.free),
    null,
    Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age7to12, fee: FeeType.free),
    null,
    Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age4to6, fee: FeeType.paid),
    null,
    Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age7to12, fee: FeeType.paid),
    null,
    Activity(type: ActivityType.yuzmeAkademisi, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
    null,
    Activity(type: ActivityType.yetiskinKadin, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid)
  ]),
  Day(day: 4, activities: [
    Activity(type: ActivityType.yetiskinKadin, ageGroup: AgeGroup.age13Plus, fee: FeeType.free),
    null,
    Activity(type: ActivityType.yetiskinKadin, ageGroup: AgeGroup.age13Plus, fee: FeeType.free),
    null,
    Activity(type: ActivityType.yetiskinKadin, ageGroup: AgeGroup.age13Plus, fee: FeeType.free),
    null,
    Activity(type: ActivityType.eykom, ageGroup: AgeGroup.age6to12, fee: FeeType.free),
    null,
    Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age4to6, fee: FeeType.free),
    null,
    Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age7to12, fee: FeeType.paid),
    null,
    Activity(type: ActivityType.yetiskinErkek, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
    null,
    Activity(type: ActivityType.yuzmeAkademisi, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
    null,
    Activity(type: ActivityType.yetiskinErkek, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid)
  ]),
  Day(day: 5, activities: [
    Activity(type: ActivityType.yetiskinErkek, ageGroup: AgeGroup.age13Plus, fee: FeeType.free),
    null,
    Activity(type: ActivityType.eykom, ageGroup: AgeGroup.age13Plus, fee: FeeType.free),
    null,
    Activity(type: ActivityType.eykom, ageGroup: AgeGroup.age6to12, fee: FeeType.free),
    null,
    Activity(type: ActivityType.eykom, ageGroup: AgeGroup.age6to12, fee: FeeType.free),
    null,
    Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age7to12, fee: FeeType.free),
    null,
    Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age4to6, fee: FeeType.paid),
    null,
    Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age7to12, fee: FeeType.paid),
    null,
    Activity(type: ActivityType.yuzmeAkademisi, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
    null,
    Activity(type: ActivityType.yetiskinKadin, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid)
  ]),
  Day(day: 6, activities: [
    Activity(type: ActivityType.yuzmeAkademisi, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
    null,
    Activity(type: ActivityType.yetiskinKadin, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
    null,
    Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age7to12, fee: FeeType.free),
    null,
    Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age4to6, fee: FeeType.free),
    null,
    Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age7to12, fee: FeeType.paid),
    null,
    Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age4to6, fee: FeeType.paid),
    null,
    Activity(type: ActivityType.yuzmeAkademisi, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
    null,
    Activity(type: ActivityType.yetiskinErkek, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
    null,
    Activity(type: ActivityType.havuzBakim, ageGroup: AgeGroup.all, fee: FeeType.free)
  ]),
  Day(day: 7, activities: [
    Activity(type: ActivityType.yuzmeAkademisi, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
    null,
    Activity(type: ActivityType.yetiskinKadin, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
    null,
    Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age7to12, fee: FeeType.free),
    null,
    Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age4to6, fee: FeeType.free),
    null,
    Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age7to12, fee: FeeType.paid),
    null,
    Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age4to6, fee: FeeType.paid),
    null,
    Activity(type: ActivityType.yuzmeAkademisi, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
    null,
    Activity(type: ActivityType.yetiskinErkek, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
    null,
    Activity(type: ActivityType.havuzBakim, ageGroup: AgeGroup.all, fee: FeeType.free)
  ]),
]);

class TimeSlot {
  final String start;
  final String end;
  final bool isBreak;

  TimeSlot({required this.start, required this.end, required this.isBreak});
}

class Activity {
  final ActivityType type; // e.g., "Yetişkin Kadın", "Yüzme Akademi"
  final AgeGroup ageGroup; // e.g., "13+", "6-12"
  final FeeType fee; // e.g., "40 TL", "Ücretsiz"

  Activity({required this.type, required this.ageGroup, required this.fee});
}

class Day {
  final int day; // e.g., "Salı", "Çarşamba"
  final List<Activity?> activities; // Matches timeSlots length, null for breaks or no activity

  Day({required this.day, required this.activities});
}

class Week {
  final List<Day> days;

  Week({required this.days});
}
