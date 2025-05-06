import 'package:flutter/material.dart';

import '../../controller/app_state.dart';
import '../../controller/app_theme.dart';
import '../../controller/provider.dart';
import '../../model/member_model.dart';

class ListItemSessionMembers extends StatelessWidget {
  final MemberModel member;
  final VoidCallback? onTap;

  const ListItemSessionMembers({
    super.key,
    required this.member,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          //color: AppTheme.buttonSecondaryDecoration(context).color,
          decoration: BoxDecoration(
              border: Border.all(
            color: Colors.grey.shade600,
            width: 1,
          )),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.gapsmall),
            child: Row(
              children: [
                // Profil veya kullanıcı ikonu
                CircleAvatar(
                    backgroundColor: appState.themeData.primaryColorDark,
                    foregroundColor: appState.themeData.primaryColor,
                    child: Icon(Icons.person, color: appState.themeData.primaryColorLight)),
                const SizedBox(width: 12),
                // Üye bilgileri: Ad Soyad ve Kimlik numarası (identity)
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(member.displayName,
                        style: appState.themeData.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold, color: appState.themeData.primaryColorDark)),
                    const SizedBox(height: 4),
                    Text("Telefon No: ${member.phoneNumber}", style: appState.themeData.textTheme.bodySmall, overflow: TextOverflow.ellipsis)
                  ],
                )),
                // Sağda ileri yön simgesi
                Icon(Icons.arrow_forward_ios, size: 16, color: appState.themeData.iconTheme.color),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
