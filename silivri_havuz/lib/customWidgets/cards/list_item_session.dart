import 'package:flutter/material.dart';
import 'package:silivri_havuz/controller/app_theme.dart';

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
            padding: const EdgeInsets.only(top: 7, bottom: 7, left: 7, right: 20),
            child: InkWell(
                onTap: onTapDetails,
                child: Ink(
                    decoration: AppTheme.listItemDecoration(context),
                    /*BoxDecoration(
                        color: AppState.instance.themeData.primaryColorLight,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 7)]),*/
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Session Info
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(sessionName, style: appState.themeData.textTheme.headlineMedium),
                                const SizedBox(height: 4),
                                Text("Eğitmen: $trainerName", style: appState.themeData.textTheme.bodyMedium),
                                Text("Tarih: $date", style: appState.themeData.textTheme.bodyMedium),
                                Text("Saat: $time", style: appState.themeData.textTheme.bodyMedium),
                                Text("Kapasite: $capacity", style: appState.themeData.textTheme.bodyMedium)
                              ],
                            )),
                            // Action Buttons
                            IconButton(
                                icon: const Icon(Icons.people),
                                onPressed: onTapMembers,
                                tooltip: "Katılımcıları Gör",
                                color: appState.themeData.iconTheme.color)
                          ],
                        ))))));
  }
}
