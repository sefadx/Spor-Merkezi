import 'package:flutter/material.dart';
import '/controller/app_state.dart';

import '../../controller/app_theme.dart';
import '../../controller/provider.dart';

class ListItemWeek extends StatelessWidget {
  const ListItemWeek({required this.weekName, required this.onTapDetails, super.key});

  final String weekName;
  final Function() onTapDetails;

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
                      child: Text(weekName, style: appState.themeData.textTheme.headlineMedium, textAlign: TextAlign.center),
                    )))));
  }
}
