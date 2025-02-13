import 'package:flutter/material.dart';

import '../../controller/app_state.dart';

class SessionCard extends StatelessWidget {
  const SessionCard({
    required this.sessionName,
    required this.trainerName,
    required this.date,
    required this.time,
    required this.capacity,
    required this.onTapDetails,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final String sessionName;
  final String trainerName;
  final String date;
  final String time;
  final String capacity;
  final Function() onTapDetails, onEdit, onDelete;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(top: 7, bottom: 7, left: 7, right: 20),
        child: Ink(
          decoration: BoxDecoration(
              color: AppState.instance.themeData.primaryColorLight,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 7)
              ]),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Session Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(sessionName,
                          style: AppState
                              .instance.themeData.textTheme.headlineMedium),
                      const SizedBox(height: 4),
                      Text("Eğitmen: $trainerName",
                          style:
                              AppState.instance.themeData.textTheme.bodyMedium),
                      Text("Tarih: $date",
                          style:
                              AppState.instance.themeData.textTheme.bodyMedium),
                      Text("Saat: $time",
                          style:
                              AppState.instance.themeData.textTheme.bodyMedium),
                      Text("Kapasite: $capacity",
                          style:
                              AppState.instance.themeData.textTheme.bodyMedium),
                    ],
                  ),
                ),
                // Action Buttons
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.people),
                      onPressed: onTapDetails,
                      tooltip: "Katılımcıları Gör",
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: onEdit,
                      tooltip: "Düzenle",
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: onDelete,
                      tooltip: "Sil",
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
