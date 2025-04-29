import 'package:flutter/material.dart';

import '/model/member_model.dart';
import '/model/subscription_model.dart';
import '/utils/enums.dart';
import '/utils/extension.dart';
import '../navigator/custom_navigation_view.dart';
import '../navigator/ui_page.dart';
import '../network/api.dart';
import '../pages/alert_dialog.dart';
import '../pages/info_popup.dart';

class ViewModelSubscriptionDetails extends ChangeNotifier {
  bool readOnly = false;
  MemberModel? member;

  final formKey = GlobalKey<FormState>();
  final TextEditingController memberController = TextEditingController(text: "");
  final TextEditingController activityController = TextEditingController(text: "-");
  final TextEditingController ageGroupController = TextEditingController(text: "-");
  final TextEditingController feeController = TextEditingController(text: "-");
  final TextEditingController amountController = TextEditingController(text: "");
  final TextEditingController paymentDateController = TextEditingController(text: "");

  Future<bool> fetchMember({required String search}) async {
    try {
      BaseResponseModel<ListWrapped<MemberModel>> res = await APIService<ListWrapped<MemberModel>>(url: APIS.api.member(limit: 1, page: 1, search: search))
          .get(
              fromJsonT: (json) => ListWrapped.fromJson(
                    jsonList: json,
                    fromJsonT: (p0) => MemberModel.fromJson(json: p0),
                  ))
          .onError((error, stackTrace) => BaseResponseModel(success: false, message: "Bilinmeyen bir hata oluştu"));

      if (res.success && res.data!.items.isNotEmpty) {
        member = res.data!.items.first;
        CustomRouter.instance.pushWidget(child: PagePopupInfo(title: "Bildirim", informationText: res.message.toString()), pageConfig: ConfigPopupInfo());
        return true;
      } else {
        CustomRouter.instance.pushWidget(child: PagePopupInfo(title: "Bildirim", informationText: "Üye kaydı bulunamadı."), pageConfig: ConfigPopupInfo());
        return false;
      }
    } catch (err) {
      CustomRouter.instance
          .pushWidget(child: const PagePopupInfo(title: "Bildirim", informationText: "Üye Bilgisinde problem var. Teknik Ekiple İletişime geçin."), pageConfig: ConfigPopupInfo());
      rethrow;
    }
  }

  Future<void> onSave() async {
    if (formKey.currentState!.validate() && await fetchMember(search: memberController.text)) {
      if (await CustomRouter.instance.waitForResult(
          child: const PageAlertDialog(title: "Uyarı", informationText: "Girdiğiniz bilgilere göre yeni abonelik oluşturulacaktır. Onaylıyor musunuz ?"),
          pageConfig: ConfigAlertDialog)) {
        SubscriptionModel model = SubscriptionModel(
            type: ActivityType.fromString(activityController.text),
            ageGroup: AgeGroup.fromString(ageGroupController.text),
            fee: FeeType.fromString(feeController.text),
            amount: int.tryParse(amountController.text)!,
            member: member!,
            paymentDate: dateFormat.parse(paymentDateController.text));

        BaseResponseModel res = await APIService<SubscriptionModel>(url: APIS.api.subscription())
            .post(model)
            .onError((error, stackTrace) => BaseResponseModel(success: false, message: "Bilinmeyen bir hata oluştu"));

        if (res.success) {
          //ViewModelHome.instance.resetAndFetchSubscription();
          CustomRouter.instance.replacePushWidget(
              child: PagePopupInfo(title: "Bildirim", informationText: res.message.toString(), afterDelay: () => CustomRouter.instance.pop()), pageConfig: ConfigPopupInfo());
        } else {
          CustomRouter.instance.pushWidget(child: PagePopupInfo(title: "Bildirim", informationText: res.message.toString()), pageConfig: ConfigPopupInfo());
        }
      }
    }
  }
}
