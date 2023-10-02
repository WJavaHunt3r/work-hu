import 'package:injectable/injectable.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/utils.dart';


@lazySingleton
class UserService{
  UserModel? user;

  UserService();

  setUser(UserModel? user){
    Utils.saveData("username", "");
    Utils.saveData("password", "");
    this.user = user;
  }

  UserModel? get currentUser=> user;

}