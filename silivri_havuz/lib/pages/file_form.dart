import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../customWidgets/buttons/custom_button.dart';
import '../model/file_model.dart';
import '../navigator/custom_navigation_view.dart';
import '../pages/widget_popup.dart';
import '../controller/app_theme.dart';
import '../customWidgets/custom_label_textfield.dart';
import '../controller/app_state.dart';
import '../controller/provider.dart';
import '../utils/extension.dart';
import '../view_model/member_details.dart';

@immutable
class PageFileForm extends StatelessWidget {
  PageFileForm({required this.fileModel, required this.approvalDateController, super.key});
  PageFileForm.readOnly({required this.fileModel, super.key}) {
    approvalDateController = null;
  }

  final FileModel fileModel;
  late final TextEditingController? approvalDateController;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return PagePopupWidget(
      widget: Padding(
          padding: const EdgeInsets.all(AppTheme.gapmedium),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*Text("Üye Bilgisi : ${vm.memberModel.displayName}", style: appState.themeData.textTheme.bodyLarge),
              const SizedBox(height: AppTheme.gapxsmall),*/
              Text("Dosya Adı : ${fileModel.fileName}", style: appState.themeData.textTheme.bodyLarge),
              const SizedBox(height: AppTheme.gapxsmall),
              Text("Dosya Boyutu : ${(fileModel.fileSize / (1024 * 1024)).toStringAsFixed(2)} MB", style: appState.themeData.textTheme.bodyLarge),
              const SizedBox(height: AppTheme.gapxsmall),
              Text("Rapor Tipi : ${fileModel.reportType}", style: appState.themeData.textTheme.bodyLarge),
              const SizedBox(height: AppTheme.gapxsmall),
              Text("Yükleme Tarihi : ${DateTime.now()}", style: appState.themeData.textTheme.bodyLarge),
              const SizedBox(height: AppTheme.gapxsmall),
              approvalDateController != null
                  ? CustomLabelTextField(
                      readOnly: false,
                      controller: approvalDateController,
                      label: "Rapor Onay Tarihi   (GG/AA/YYYY)",
                      inputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(8), // Maksimum 8 karakter
                        DateFormatter()
                      ],
                      suffixIcon: IconButton(
                          icon: Icon(Icons.date_range, color: appState.themeData.primaryColorDark),
                          onPressed: () async => pickDate(context, controller: approvalDateController!)),
                      validator: (value) => value == null || value.isEmpty ? 'Rapor Onay Tarihi giriniz' : null)
                  : Text("Rapor Onay Tarihi : ${fileModel.approvalDate.day}/${fileModel.approvalDate.month}/${fileModel.approvalDate.year}",
                      style: appState.themeData.textTheme.bodyLarge)
            ],
          )),
      actionButton: approvalDateController != null
          ? CustomButton(margin: const EdgeInsets.all(AppTheme.gapxxsmall), text: "Yükle", onTap: () => CustomRouter.instance.returnWith(true))
          : CustomButton(
              margin: const EdgeInsets.all(AppTheme.gapxxsmall), text: "Raporu Görüntüle", onTap: () => CustomRouter.instance.returnWith(true)),
      onTapClose: () => CustomRouter.instance.returnWith(false),
    );
  }
}
//await vm.downloadAndOpenFile(fileId: vm.listMemberFiles!.elementAt(index).fileId, context: context)
