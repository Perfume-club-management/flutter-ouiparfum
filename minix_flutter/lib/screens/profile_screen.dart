import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minix_flutter/models/tweet.dart';
import 'package:minix_flutter/screens/webview_screen.dart';

import '../controllers/auth_controller.dart';
import '../services/api_service.dart';
import '../widgets/tweet_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState(); 
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authController = Get.find<AuthController>();
  final _api = Get.find<ApiService>();

  List<Tweet> _myTweets = []; // 내 트윗 목록
  bool _isLoading = true; // 로딩 상태

  @override
  void initState() {
    super.initState();
    _loadData(); // 화면 진입시 데이터 로드
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      // 서버에서 내 트윗 목록 가져오기
      final tweetsData = await _api.getMyTweets();
      _myTweets = (tweetsData as List)
          .map((json) => Tweet.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (e) {
      Get.snackbar('오류', '데이터 로드 실패');
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필'),
        actions: [
          // 로그아웃 버튼
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _authController.logout(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    return Obx(() {
      final user = _authController.user.value;
      if (user == null) return const SizedBox();

      return SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),

            // 프로필 이미지 (이름 첫 글자로 대체)
            CircleAvatar(
              radius: 50,
              backgroundColor: const Color.fromARGB(255, 46, 80, 183),
              child: Text(
                user.name[0].toUpperCase(),
                style: const TextStyle(fontSize: 40),
              ),
            ),

            const SizedBox(height: 16),

            // 이름
            Text(
              user.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            // 사용자명
            Text(
              '@${user.username}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 24),

            // (옵션) 링크 버튼 - import 사용도 겸해서 최소만
            TextButton(
              onPressed: () {
                Get.to(() => const WebViewScreen(
                      title: '이용약관',
                      url: 'https://banawy.store',
                    ));
              },
              child: const Text('이용약관 보기'),
            ),

            const SizedBox(height: 24),
            const Divider(),

            // 내 트윗 개수
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    '내 트윗 ${_myTweets.length}개',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // 내 트윗 목록
            if (_myTweets.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text('작성한 트윗이 없습니다'),
              )
            else
              ListView.separated(
                shrinkWrap: true, // Column 안에서 사용하려면 필요
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _myTweets.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  return TweetCard(
                    tweet: _myTweets[index],
                    onLike: () {}, // 프로필에서는 좋아요 비활성화(원하시면 연결 가능)
                    onDelete: () {}, // 필요 없으면 TweetCard 파라미터에 맞춰 제거
                  );
                },
              ),
          ],
        ),
      );
    });
  }
}
