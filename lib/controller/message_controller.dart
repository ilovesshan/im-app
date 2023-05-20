import 'package:get/get.dart';
import 'package:im/model/user_model.dart';
import 'package:im/util/shared_preferences_util.dart';

class MessageController extends GetxController {
  var userModel = UserModel(id: 0, username: "IM", image: "").obs;

  @override
  void onInit() async {
    super.onInit();

    final String userId = await SpUtil.getValue("userId");
    final String username = await SpUtil.getValue("username");
    final String image = await SpUtil.getValue("image");

    userModel.update((val) {
     val!.id = int.parse(userId);
     val.username = username;
     val.image = image;
    });
  }
}
