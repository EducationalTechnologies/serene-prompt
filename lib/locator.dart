import 'package:get_it/get_it.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/services/firebase_service.dart';
import 'package:serene/services/user_service.dart';

GetIt services = GetIt.instance;

void setupLocator() {
  services.registerSingleton<UserService>(UserService());
  services.registerSingleton<DataService>(DataService());
  services.registerSingleton<FirebaseService>(FirebaseService());
}
