import 'package:flutter/material.dart';
import 'package:silivri_havuz/model/health_status.dart';
import 'package:silivri_havuz/model/payment_status.dart';
import '../navigator/custom_navigation_view.dart';
import '../pages/alert_dialog.dart';
import '../pages/info_popup.dart';
import '../model/member_model.dart';
import '../navigator/ui_page.dart';
import '../network/api.dart';
import '../utils/extension.dart';
import 'home.dart';

class ViewModelMemberDetails extends ChangeNotifier {
  ViewModelMemberDetails({this.readOnly = false}) {}
  ViewModelMemberDetails.fromModel({required MemberModel model, this.readOnly = true}) {
    identityController.text = model.identity;
    nameController.text = model.name;
    surnameController.text = model.surname;
    birthdateController.text = format.format(model.birthDate);
    birthPlaceController.text = model.birthPlace;
    genderController.text = model.gender;
    educationLevelController.text = model.educationLevel;
    phoneController.text = model.phoneNumber;
    emailController.text = model.email;
    addressController.text = model.address;
    emergencyNameSurnameController.text = model.emergencyContactName;
    emergencyPhoneNumberController.text = model.emergencyContactPhoneNumber;
  }

  bool readOnly;

  final formKey = GlobalKey<FormState>();
  final TextEditingController identityController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController birthPlaceController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController educationLevelController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emergencyNameSurnameController = TextEditingController();
  final TextEditingController emergencyPhoneNumberController = TextEditingController();

  void pickDate(BuildContext context) async {
    DateTime date = await selectDate(context, initialDate: birthdateController.text != "" ? format.parse(birthdateController.text) : null);
    birthdateController.text = format.format(date);
    notifyListeners();
  }

  onSave() async {
    debugPrint("onSave çalıştı.");
    if (formKey.currentState!.validate() && birthdateController.text.isNotEmpty) {
      if (await CustomRouter.instance.waitForResult(
          const PageAlertDialog(title: "Uyarı", informationText: "Üye kaydı oluşturulacaktır. Onaylıyor musunuz ?"), ConfigAlertDialog)) {
        Map<String, dynamic> json = MemberModel(
                identity: identityController.text,
                name: nameController.text,
                surname: surnameController.text,
                birthDate: format.parse(birthdateController.text),
                birthPlace: birthPlaceController.text,
                gender: genderController.text,
                educationLevel: educationLevelController.text,
                phoneNumber: phoneController.text,
                email: emailController.text,
                address: addressController.text,
                emergencyContactName: emergencyNameSurnameController.text,
                emergencyContactPhoneNumber: emergencyPhoneNumberController.text,
                paymentStatus: PaymentStatus(text: "text"),
                healthStatusCheck: HealthStatus(text: "text"))
            .toJson();

        BaseResponseModel res = await APIService<MemberModel>(url: APIS.api.member())
            .postJson(json)
            .onError((error, stackTrace) => BaseResponseModel(status: false, message: "Bilinmeyen bir hata oluştu"));

        if (res.status) {
          ViewModelHome.instance.members.notifyListeners();

          CustomRouter.instance.pushWidget(
              child: PagePopupInfo(
                title: "Bildirim",
                informationText: res.message.toString(),
                afterDelay: () => CustomRouter.instance.pop(),
              ),
              pageConfig: ConfigPopupInfo);
        } else {
          CustomRouter.instance.pushWidget(
              child: PagePopupInfo(
                title: "Bildirim",
                informationText: res.message.toString(),
              ),
              pageConfig: ConfigPopupInfo);
        }
      }
    } else {}
  }
}
