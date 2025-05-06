import 'package:flutter/material.dart';

import '/model/health_status.dart';
import '/model/payment_status.dart';
import '../../controller/app_state.dart';
import '../../controller/app_theme.dart';

class ListItemMember extends StatelessWidget {
  const ListItemMember({
    required this.memberName,
    required this.checkPayment,
    required this.checkHealthy,
    this.onTap,
    super.key,
  });

  final String memberName;
  final HealthStatus checkHealthy;
  final PaymentStatus checkPayment;
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
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(memberName, style: AppState.instance.themeData.textTheme.headlineMedium),
                    /*RichText(
                        text: TextSpan(text: "Sağlık Raporu: ", style: AppState.instance.themeData.textTheme.bodyMedium, children: [
                      TextSpan(text: checkHealthy.text, style: AppState.instance.themeData.textTheme.bodyMedium?.copyWith(color: checkHealthy.color))
                    ])),
                    RichText(
                        text: TextSpan(text: "Ödeme: ", style: AppState.instance.themeData.textTheme.bodyMedium, children: [
                      TextSpan(text: checkPayment.text, style: AppState.instance.themeData.textTheme.bodyMedium?.copyWith(color: checkPayment.color))
                    ])),*/
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
