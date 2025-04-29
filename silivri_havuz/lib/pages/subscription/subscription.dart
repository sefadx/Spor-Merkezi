import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/customWidgets/cards/list_item_subscription.dart';
import '/model/subscription_model.dart';
import '/pages/widget_popup.dart';
import '../../controller/app_state.dart';
import '../../controller/app_theme.dart';
import '../../controller/provider.dart';
import '../../customWidgets/buttons/custom_button.dart';
import '../../customWidgets/custom_dropdown_list.dart';
import '../../customWidgets/custom_label_textfield.dart';
import '../../customWidgets/search_and_filter.dart';
import '../../navigator/custom_navigation_view.dart';
import '../../navigator/ui_page.dart';
import '../../network/api.dart';
import '../../utils/enums.dart';
import '../../utils/extension.dart';
import '../../view_model/home.dart';
import '../../view_model/subscription_details.dart';

class PageSubscription extends StatelessWidget {
  PageSubscription({super.key});
  /*PageSubscription({SubscriptionModel? model, super.key}) {
    if (model == null) {
      vmSubscription = ViewModelSubscriptionDetails();
    }
  }*/

  ViewModelSubscriptionDetails vmSubscription = ViewModelSubscriptionDetails();

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final vm = Provider.of<ViewModelHome>(context);

    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: appState.themeData.primaryColorLight,
          scrolledUnderElevation: 0,
          leading: IconButton(onPressed: () => vm.resetAndFetchSubscription(), icon: const Icon(Icons.refresh)),
          title: Text("Abonelik Yönetimi", style: appState.themeData.textTheme.headlineMedium),
          centerTitle: true,
          actions: [
            CustomButton(
                text: "Abonelik Ekle",
                onTap: () {
                  vmSubscription.memberController.text = "";
                  vmSubscription.activityController.text = "";
                  vmSubscription.ageGroupController.text = "";
                  vmSubscription.feeController.text = "";
                  vmSubscription.amountController.text = "";
                  vmSubscription.paymentDateController.text = "";
                  CustomRouter.instance.pushWidget(
                      child: PagePopupWidget(
                        actionButton: CustomButton(
                          margin: const EdgeInsets.all(AppTheme.gapxsmall),
                          text: "Ekle",
                          onTap: () async {
                            await vmSubscription.onSave();
                          },
                        ),
                        title: "Abonelik Bilgileri",
                        widget: Padding(
                            padding: const EdgeInsets.all(AppTheme.gapmedium),
                            child: Form(
                              key: vmSubscription.formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomLabelTextField(
                                    controller: vmSubscription.memberController,
                                    label: "T.C. Kimlik No",
                                    validator: validateTcKimlik,
                                  ),
                                  const SizedBox(height: AppTheme.gapsmall),
                                  CustomDropdownList(
                                    readOnly: false,
                                    labelText: "Kategori",
                                    value: vmSubscription.activityController.text,
                                    list: List<String>.from(ActivityType.values.map((e) => e.toString())),
                                    onChanged: (text) {
                                      vmSubscription.activityController.text = text!;
                                    },
                                  ),
                                  const SizedBox(height: AppTheme.gapsmall),
                                  CustomDropdownList(
                                    readOnly: false,
                                    labelText: "Yaş Grubu",
                                    value: vmSubscription.ageGroupController.text,
                                    list: List<String>.from(AgeGroup.values.map((e) => e.toString())),
                                    onChanged: (text) {
                                      vmSubscription.ageGroupController.text = text!;
                                    },
                                  ),
                                  const SizedBox(height: AppTheme.gapsmall),
                                  CustomDropdownList(
                                    readOnly: false,
                                    labelText: "Ücret Tipi",
                                    value: vmSubscription.feeController.text,
                                    list: List<String>.from(FeeType.values.map((e) => e.toString())),
                                    onChanged: (text) {
                                      vmSubscription.feeController.text = text!;
                                    },
                                  ),
                                  const SizedBox(height: AppTheme.gapsmall),
                                  CustomLabelTextField(
                                      controller: vmSubscription.amountController,
                                      label: "Ödenen Ücret",
                                      validator: (value) => value == null || value.isEmpty ? 'Ödenen Ücret Bilgisi Giriniz' : null),
                                  const SizedBox(height: AppTheme.gapsmall),
                                  CustomLabelTextField(
                                      readOnly: false,
                                      controller: vmSubscription.paymentDateController,
                                      label: "Ödeme Tarihi   (GG/AA/YYYY)",
                                      inputFormatter: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(8), // Maksimum 8 karakter
                                        DateFormatter()
                                      ],
                                      suffixIcon: IconButton(
                                          icon: Icon(Icons.date_range, color: appState.themeData.primaryColorDark),
                                          onPressed: () async => pickDate(context, controller: vmSubscription.paymentDateController)),
                                      validator: validateDate),
                                  const SizedBox(height: AppTheme.gapxsmall),
                                ],
                              ),
                            )),
                      ),
                      pageConfig: ConfigPopupInfo());
                })
          ],
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: AppTheme.gapsmall),
          SearchAndFilter(
              controller: vm.subscriptionSearchTextEditingController, onTap: () => vm.resetAndFetchMemberModel(search: vm.subscriptionSearchTextEditingController.text)),

          const SizedBox(height: AppTheme.gapsmall),

          // Members List
          Expanded(
              child: StreamBuilder<List<SubscriptionModel>>(
                  stream: vm.subscriptions.stream,
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.hasData) {
                      return ListView.builder(
                          controller: vm.subscriptionScrollController,
                          itemCount: asyncSnapshot.data!.length ?? 0, // Example data

                          itemBuilder: (context, index) {
                            return ListItemSubscription(
                              text: asyncSnapshot.data!.elementAt(index).member.displayName,
                              date: dateFormat.format(asyncSnapshot.data!.elementAt(index).paymentDate),
                              credit: asyncSnapshot.data!.elementAt(index).credit.toString(),
                              onTap: () {
                                vmSubscription.readOnly = true;
                                vmSubscription.memberController.text = asyncSnapshot.data!.elementAt(index).member.identityNumber;
                                vmSubscription.activityController.text = asyncSnapshot.data!.elementAt(index).type.toString();
                                vmSubscription.ageGroupController.text = asyncSnapshot.data!.elementAt(index).ageGroup.toString();
                                vmSubscription.feeController.text = asyncSnapshot.data!.elementAt(index).fee.toString();
                                vmSubscription.amountController.text = asyncSnapshot.data!.elementAt(index).amount.toString();
                                vmSubscription.paymentDateController.text = dateFormat.format(asyncSnapshot.data!.elementAt(index).paymentDate);
                                CustomRouter.instance.pushWidget(
                                    child: PagePopupWidget(
                                      title: "Abonelik Bilgileri",
                                      widget: Padding(
                                          padding: const EdgeInsets.all(AppTheme.gapmedium),
                                          child: Form(
                                            key: vmSubscription.formKey,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                CustomLabelTextField(
                                                  readOnly: vmSubscription.readOnly,
                                                  controller: vmSubscription.memberController,
                                                  label: "T.C. Kimlik No",
                                                  validator: validateTcKimlik,
                                                ),
                                                const SizedBox(height: AppTheme.gapsmall),
                                                CustomDropdownList(
                                                  readOnly: vmSubscription.readOnly,
                                                  labelText: "Kategori",
                                                  value: vmSubscription.activityController.text,
                                                  list: List<String>.from(ActivityType.values.map((e) => e.toString())),
                                                  onChanged: (text) {
                                                    vmSubscription.activityController.text = text!;
                                                  },
                                                ),
                                                const SizedBox(height: AppTheme.gapsmall),
                                                CustomDropdownList(
                                                  readOnly: vmSubscription.readOnly,
                                                  labelText: "Yaş Grubu",
                                                  value: vmSubscription.ageGroupController.text,
                                                  list: List<String>.from(AgeGroup.values.map((e) => e.toString())),
                                                  onChanged: (text) {
                                                    vmSubscription.ageGroupController.text = text!;
                                                  },
                                                ),
                                                const SizedBox(height: AppTheme.gapsmall),
                                                CustomDropdownList(
                                                  readOnly: vmSubscription.readOnly,
                                                  labelText: "Ücret Tipi",
                                                  value: vmSubscription.feeController.text,
                                                  list: List<String>.from(FeeType.values.map((e) => e.toString())),
                                                  onChanged: (text) {
                                                    vmSubscription.feeController.text = text!;
                                                  },
                                                ),
                                                const SizedBox(height: AppTheme.gapsmall),
                                                CustomLabelTextField(
                                                    readOnly: vmSubscription.readOnly,
                                                    controller: vmSubscription.amountController,
                                                    label: "Ödenen Ücret",
                                                    validator: (value) => value == null || value.isEmpty ? 'Ödenen Ücret Bilgisi Giriniz' : null),
                                                const SizedBox(height: AppTheme.gapsmall),
                                                CustomLabelTextField(
                                                    readOnly: vmSubscription.readOnly,
                                                    controller: vmSubscription.paymentDateController,
                                                    label: "Ödeme Tarihi   (GG/AA/YYYY)",
                                                    inputFormatter: [
                                                      FilteringTextInputFormatter.digitsOnly,
                                                      LengthLimitingTextInputFormatter(8), // Maksimum 8 karakter
                                                      DateFormatter()
                                                    ],
                                                    suffixIcon: IconButton(
                                                        icon: Icon(Icons.date_range, color: appState.themeData.primaryColorDark),
                                                        onPressed: () async => pickDate(context, controller: vmSubscription.paymentDateController)),
                                                    validator: validateDate),
                                                const SizedBox(height: AppTheme.gapxsmall),
                                              ],
                                            ),
                                          )),
                                    ),
                                    pageConfig: ConfigPopupInfo());
                              },
                            );
                          });
                    } else if (asyncSnapshot.hasError) {
                      return Center(child: Text((asyncSnapshot.error as BaseResponseModel).message.toString()));
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  })),
        ]));
  }
}
