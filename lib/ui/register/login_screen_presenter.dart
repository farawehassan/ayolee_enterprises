import 'package:ayolee_stores/networking/rest_data.dart';
import 'package:ayolee_stores/model/user.dart';

abstract class LoginScreenContract {
  void onLoginSuccess(User user);
  void onLoginError(String errorTxt);
}

class LoginScreenPresenter {
  LoginScreenContract _view;
  RestDataSource api = new RestDataSource();
  LoginScreenPresenter(this._view);

  doLogin(String username, String password) {
    api.login(username, password).then((User user) {
      _view.onLoginSuccess(user);
    }).catchError((Object error) {
      print(error);
      _view.onLoginError(error.toString());
    });
  }
}