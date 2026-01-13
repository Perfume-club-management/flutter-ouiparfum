import 'package:flutter/material.dart';
import 'package:minix_flutter/controllers/TweetController.dart';
import 'package:minix_flutter/controllers/auth_controller.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:get/get.dart';
import './app.dart';
import 'services/api_service.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

    //의존성 주입
  Get.put(ApiService());
  Get.put(AuthController());
  Get.lazyPut(() => TweetController(),fenix: true);

  timeago.setLocaleMessages('ko', timeago.KoMessages());

  runApp(const MyApp());
}
