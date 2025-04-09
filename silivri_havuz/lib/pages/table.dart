import 'package:flutter/material.dart';
import '../utils/enums.dart';
import '../controller/app_state.dart';
import '../controller/app_theme.dart';
import '../controller/provider.dart';

class PageTable extends StatelessWidget {
  PageTable({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      backgroundColor: appState.themeData.scaffoldBackgroundColor,
      appBar: AppBar(scrolledUnderElevation: 0, backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 875),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Ink(
                      padding: const EdgeInsets.symmetric(vertical: AppTheme.gapmedium, horizontal: AppTheme.gapxsmall),
                      child: Center(child: Text("SAAT", textAlign: TextAlign.center, style: appState.themeData.textTheme.headlineSmall))),
                  Expanded(
                    child: Material(
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                        child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 120),
                            child: ListView.builder(
                                shrinkWrap: false,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: timeSlots.length,
                                itemBuilder: (context, index) => timeSlots.elementAt(index).isBreak
                                    ? Ink(
                                        padding: const EdgeInsets.all(AppTheme.gapxxsmall),
                                        color: Colors.grey,
                                        child: Text("${timeSlots.elementAt(index).start} - ${timeSlots.elementAt(index).end}",
                                            style: appState.themeData.textTheme.bodyMedium, textAlign: TextAlign.center))
                                    : Ink(
                                        padding: const EdgeInsets.symmetric(vertical: AppTheme.gaplarge, horizontal: AppTheme.gapxsmall),
                                        height: 70,
                                        color: AppTheme.blackWhite(context),
                                        child: Center(
                                          child: Text("${timeSlots.elementAt(index).start} - ${timeSlots.elementAt(index).end}",
                                              style: appState.themeData.textTheme.bodyMedium, textAlign: TextAlign.center),
                                        )))),
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                  child: Material(
                child: ListView.separated(
                    shrinkWrap: false,
                    padding: const EdgeInsets.symmetric(horizontal: AppTheme.gapxsmall),
                    scrollDirection: Axis.horizontal,
                    itemCount: week.days.length,
                    separatorBuilder: (context, index) => const SizedBox(width: AppTheme.gapxsmall),
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Ink(
                              padding: const EdgeInsets.symmetric(vertical: AppTheme.gapmedium, horizontal: AppTheme.gapxsmall),
                              child: Text(week.days.elementAt(index).name,
                                  textAlign: TextAlign.center, style: appState.themeData.textTheme.headlineSmall)),
                          if (index + 1 != 1)
                            Expanded(
                              child: Material(
                                child: ScrollConfiguration(
                                  behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                                  child: ConstrainedBox(
                                      constraints: const BoxConstraints(maxWidth: 170),
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: week.days.elementAt(index).activities.length, //week.days.elementAt(index).activities.length,
                                          itemBuilder: (context, indexActivities) =>
                                              week.days.elementAt(index).activities.elementAt(indexActivities) == null
                                                  ? Ink(
                                                      padding: const EdgeInsets.all(AppTheme.gapxxsmall),
                                                      color: Colors.grey,
                                                      child: Text("Seans arası",
                                                          style: appState.themeData.textTheme.bodyMedium, textAlign: TextAlign.center))
                                                  : Ink(
                                                      padding:
                                                          const EdgeInsets.symmetric(vertical: AppTheme.gapxxsmall, horizontal: AppTheme.gapxsmall),
                                                      height: 70,
                                                      color: week.days
                                                          .elementAt(index)
                                                          .activities
                                                          .elementAt(indexActivities)!
                                                          .type
                                                          .getBackgroundColor(), //appState.themeData.primaryColorLight,
                                                      child: Column(
                                                        children: [
                                                          Text(week.days.elementAt(index).activities.elementAt(indexActivities)!.type.toString(),
                                                              style: appState.themeData.textTheme.bodyMedium, textAlign: TextAlign.center),
                                                          Text(week.days.elementAt(index).activities.elementAt(indexActivities)!.ageGroup.toString(),
                                                              style: appState.themeData.textTheme.bodyMedium, textAlign: TextAlign.center),
                                                          Text(week.days.elementAt(index).activities.elementAt(indexActivities)!.fee.toString(),
                                                              style: appState.themeData.textTheme.bodyMedium, textAlign: TextAlign.center),
                                                        ],
                                                      )))),
                                ),
                              ),
                            )
                          else
                            Expanded(
                                child: Center(
                              child: Ink(
                                  width: 170,
                                  padding: const EdgeInsets.all(AppTheme.gapxxsmall),
                                  child:
                                      Text("Tesis Bakım\nve\nTemizlik", style: appState.themeData.textTheme.bodyLarge, textAlign: TextAlign.center)),
                            ))
                        ],
                      );
                    }),
              ))
            ],
          ),
        ),
      ),
    );
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
  Day(name: "Pazartesi", day: 1, activities: [
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
  Day(name: "Salı", day: 2, activities: [
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
  Day(name: "Çarşamba", day: 3, activities: [
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
  Day(name: "Perşembe", day: 4, activities: [
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
  Day(name: "Cuma", day: 5, activities: [
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
  Day(name: "Cumartesi", day: 6, activities: [
    Activity(type: ActivityType.yuzmeAkademisi, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
    null,
    Activity(type: ActivityType.yetiskinKadin, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
    null,
    Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age7to12, fee: FeeType.paid),
    null,
    Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age4to6, fee: FeeType.paid),
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
  Day(name: "Pazar", day: 7, activities: [
    Activity(type: ActivityType.yuzmeAkademisi, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
    null,
    Activity(type: ActivityType.yetiskinKadin, ageGroup: AgeGroup.age13Plus, fee: FeeType.paid),
    null,
    Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age7to12, fee: FeeType.paid),
    null,
    Activity(type: ActivityType.cocuk, ageGroup: AgeGroup.age4to6, fee: FeeType.paid),
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
  String name;
  final int day; // e.g., "Salı", "Çarşamba"
  final List<Activity?> activities; // Matches timeSlots length, null for breaks or no activity

  Day({required this.name, required this.day, required this.activities});
}

class Week {
  final List<Day> days;

  Week({required this.days});
}

/*
class PageTable extends StatelessWidget {
  PageTable({super.key});

  final DateTime date = DateTime(2025);
  final scrollController = ScrollController(initialScrollOffset: (DateTime.now().difference(DateTime(2025, 1, 1)).inDays * 177) - 170);

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
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: timeSlots.length,
                    itemBuilder: (context, index) => timeSlots.elementAt(index).isBreak
                        ? Ink(
                            padding: const EdgeInsets.all(AppTheme.gapxxsmall),
                            color: Colors.grey,
                            child: Text("${timeSlots.elementAt(index).start} - ${timeSlots.elementAt(index).end}",
                                style: appState.themeData.textTheme.bodyMedium, textAlign: TextAlign.center))
                        : Ink(
                            padding: const EdgeInsets.symmetric(vertical: AppTheme.gaplarge, horizontal: AppTheme.gapxsmall),
                            height: 70,
                            color: AppTheme.blackWhite(context),
                            child: Center(
                              child: Text("${timeSlots.elementAt(index).start} - ${timeSlots.elementAt(index).end}",
                                  style: appState.themeData.textTheme.bodyMedium, textAlign: TextAlign.center),
                            ))))
          ],
        ),
        Expanded(
            child: Material(
          child: ListView.separated(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.gapxsmall),
              scrollDirection: Axis.horizontal,
              itemCount: 365,
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
                    if (dateLocal.weekday != 1)
                      ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 170),
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 17, //week.days.elementAt(index).activities.length,
                              itemBuilder: (context, indexActivities) => week.days
                                          .elementAt(dateLocal.weekday - 1)
                                          .activities
                                          .elementAt(indexActivities) ==
                                      null
                                  ? Ink(
                                      padding: const EdgeInsets.all(AppTheme.gapxxsmall),
                                      color: Colors.grey,
                                      child: Text("Seans arası", style: appState.themeData.textTheme.bodyMedium, textAlign: TextAlign.center))
                                  : Ink(
                                      padding: const EdgeInsets.symmetric(vertical: AppTheme.gapxxsmall, horizontal: AppTheme.gapxsmall),
                                      height: 70,
                                      color: week.days
                                          .elementAt(dateLocal.weekday - 1)
                                          .activities
                                          .elementAt(indexActivities)!
                                          .type
                                          .getBackgroundColor(), //appState.themeData.primaryColorLight,
                                      child: Column(
                                        children: [
                                          Text(week.days.elementAt(dateLocal.weekday - 1).activities.elementAt(indexActivities)!.type.toString(),
                                              style: appState.themeData.textTheme.bodyMedium, textAlign: TextAlign.center),
                                          Text(week.days.elementAt(dateLocal.weekday - 1).activities.elementAt(indexActivities)!.ageGroup.toString(),
                                              style: appState.themeData.textTheme.bodyMedium, textAlign: TextAlign.center),
                                          Text(week.days.elementAt(dateLocal.weekday - 1).activities.elementAt(indexActivities)!.fee.toString(),
                                              style: appState.themeData.textTheme.bodyMedium, textAlign: TextAlign.center),
                                        ],
                                      ))))
                    else
                      Expanded(
                          child: Center(
                        child: Ink(
                            width: 170,
                            padding: const EdgeInsets.all(AppTheme.gapxxsmall),
                            child: Text("Hafta Tatili", style: appState.themeData.textTheme.bodyMedium, textAlign: TextAlign.center)),
                      ))
                  ],
                );
              }),
        ))
      ],
    ));
  }
}

 */
