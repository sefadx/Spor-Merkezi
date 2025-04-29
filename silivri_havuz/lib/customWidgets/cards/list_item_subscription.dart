import 'package:flutter/material.dart';

import '../../controller/app_state.dart';
import '../../controller/app_theme.dart';

class ListItemSubscription extends StatelessWidget {
  const ListItemSubscription({
    required this.text,
    required this.credit,
    required this.date,
    this.onTap,
    super.key,
  });

  final String text, credit, date;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppTheme.gapxsmall),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Ink(
            decoration: AppTheme.listItemDecoration(context),
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.gapmedium),
              child: Row(
                children: [
                  Expanded(
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(text, style: AppState.instance.themeData.textTheme.headlineMedium),
                    Text(date, style: AppState.instance.themeData.textTheme.headlineMedium),
                    Text("Kalan Seans Hakkı: $credit", style: AppState.instance.themeData.textTheme.headlineMedium),
                  ])),
                  const Icon(Icons.chevron_right)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
