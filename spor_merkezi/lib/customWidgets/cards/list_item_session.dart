import 'package:flutter/material.dart';

import '/controller/app_theme.dart';
import '../../controller/app_state.dart';
import '../../controller/provider.dart';

class SessionCard extends StatelessWidget {
  const SessionCard({
    required this.sessionName,
    required this.trainerName,
    required this.date,
    required this.time,
    required this.capacity,
    required this.onTapMembers,
    required this.onTapDetails,
    super.key,
  });

  final String sessionName;
  final String trainerName;
  final String date;
  final String time;
  final String capacity;
  final Function() onTapMembers, onTapDetails;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Material(
        color: Colors.transparent,
        child: Padding(
            padding: const EdgeInsets.only(bottom: AppTheme.gapxsmall),
            child: InkWell(
                onTap: onTapDetails,
                child: Ink(
                    decoration: AppTheme.listItemDecoration(context),
                    child: Padding(
                        padding: const EdgeInsets.all(AppTheme.gapmedium),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Eğitmen: $trainerName",
                                        style: appState
                                            .themeData.textTheme.bodyMedium),
                                    Text("Kapasite: $capacity",
                                        style: appState
                                            .themeData.textTheme.bodyMedium)
                                  ],
                                )),
                                Expanded(
                                    child: Column(
                                  children: [
                                    Text(sessionName,
                                        style: appState
                                            .themeData.textTheme.headlineMedium,
                                        textAlign: TextAlign.center),
                                    Text(time,
                                        style: appState
                                            .themeData.textTheme.bodyMedium,
                                        textAlign: TextAlign.end),
                                  ],
                                )),
                                Expanded(
                                    child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Column(
                                    children: [
                                      Text(
                                        date,
                                        style: appState
                                            .themeData.textTheme.bodySmall,
                                        textAlign: TextAlign.end,
                                      ),
                                      IconButton(
                                          icon: const Icon(Icons.people),
                                          onPressed: onTapMembers,
                                          tooltip: "Katılımcıları Gör",
                                          color: appState
                                              .themeData.iconTheme.color),
                                    ],
                                  ),
                                ))
                              ],
                            ),
                          ],
                        ))))));
  }
}
