import 'package:flutter/material.dart';
import '../../view_model/table.dart';
import '../../controller/provider.dart';
import '../../utils/enums.dart';
import '../../controller/app_theme.dart';
import '../../customWidgets/custom_dropdown_list.dart';
import '../widget_popup.dart';

class PageTableSessionDetails extends StatelessWidget {
  const PageTableSessionDetails({required this.vm, super.key});

  final ViewModelTable vm;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ViewModelTable>(context);
    return PagePopupWidget(
      title: "Seans Bilgileri",
      widget: Padding(
          padding: const EdgeInsets.all(AppTheme.gapmedium),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomDropdownList(
                  readOnly: false,
                  labelText: "Kategori",
                  value: null,
                  list: List<String>.from(ActivityType.values.map((e) => e.toString())),
                  onChanged: (text) {}),
              const SizedBox(height: AppTheme.gapsmall),
              CustomDropdownList(
                  readOnly: false,
                  labelText: "Grup",
                  value: null,
                  list: List<String>.from(AgeGroup.values.map((e) => e.toString())),
                  onChanged: (text) {}),
              const SizedBox(height: AppTheme.gapsmall),
              CustomDropdownList(
                  readOnly: false,
                  labelText: "Ücret",
                  value: null,
                  list: List<String>.from(FeeType.values.map((e) => e.toString())),
                  onChanged: (text) {}),
              const SizedBox(height: AppTheme.gapxsmall),
            ],
          )),
    );
  }
}
