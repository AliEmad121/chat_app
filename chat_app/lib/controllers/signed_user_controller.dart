import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SignedUserController extends GetxController {
  final _isSignedIn = false.obs;
  final _username = ''.obs;

  bool get isSignedIn => _isSignedIn.value;
  String get username => _username.value;

  @override
  void onInit() {
    // Fetch user data from storage on initialization
    _isSignedIn.value = _loadSignInStatus();
    _username.value = _loadUsername();
    super.onInit();
  }

  void signIn(String username) {
    // Simulate signing in by setting values and saving to storage
    _isSignedIn.value = true;
    _username.value = username;

    _saveSignInStatus();
    _saveUsername();
  }

  void signOut() {
    // Simulate signing out by resetting values and clearing storage
    _isSignedIn.value = false;
    _username.value = '';

    _clearSignInStatus();
    _clearUsername();
  }

  // Private methods to interact with storage

  bool _loadSignInStatus() {
    return GetStorage().read<bool>('isSignedIn') ?? false;
  }

  void _saveSignInStatus() {
    GetStorage().write('isSignedIn', _isSignedIn.value);
  }

  void _clearSignInStatus() {
    GetStorage().remove('isSignedIn');
  }

  String _loadUsername() {
    return GetStorage().read<String>('username') ?? '';
  }

  void _saveUsername() {
    GetStorage().write('username', _username.value);
  }

  void _clearUsername() {
    GetStorage().remove('username');
  }
}
