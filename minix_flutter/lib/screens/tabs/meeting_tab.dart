import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minix_flutter/controllers/TweetController.dart';
import '../../widgets/tweet_card.dart';
import '../login_screen.dart';

class MeetingTab extends StatelessWidget{
  const MeetingTab({super.key});

  @override
  Widget build(BuildContext context){

    final tweetcontroller = Get.find<TweetController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F7FB),
        title: const Text('영화랑'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: (){
              Get.toNamed('/profile');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: (){
              Get.offAllNamed('/');
            },
          ),
        ],
      ),
    );
  }
}
