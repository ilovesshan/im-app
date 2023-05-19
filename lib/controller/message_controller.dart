import 'package:get/get.dart';
import 'package:im/model/user_model.dart';
import 'package:im/util/shared_preferences_util.dart';

class MessageController extends GetxController {
  late Rx<UserModel> userModel = UserModel(id: 0, username: "IM", image: "").obs;

  @override
  void onInit() async {
    super.onInit();
    userModel.value = await SpUtil.getUserModel();
  }
}
