import 'package:flutter/material.dart';
import 'package:silivri_havuz/model/health_status.dart';
import 'package:silivri_havuz/model/payment_status.dart';

import '../../controller/app_state.dart';

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
        padding: const EdgeInsets.only(top: 7, bottom: 7, left: 7, right: 20),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
                color: AppState.instance.themeData.primaryColorLight,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 7)]),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(memberName, style: AppState.instance.themeData.textTheme.headlineMedium),
                    RichText(
                        text: TextSpan(text: "Sağlık Raporu: ", style: AppState.instance.themeData.textTheme.bodyMedium, children: [
                      TextSpan(text: checkHealthy.text, style: AppState.instance.themeData.textTheme.bodyMedium?.copyWith(color: checkHealthy.color))
                    ])),
                    RichText(
                        text: TextSpan(text: "Ödeme: ", style: AppState.instance.themeData.textTheme.bodyMedium, children: [
                      TextSpan(text: checkPayment.text, style: AppState.instance.themeData.textTheme.bodyMedium?.copyWith(color: checkPayment.color))
                    ])),
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
