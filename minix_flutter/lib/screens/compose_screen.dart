import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minix_flutter/controllers/TweetController.dart';

class ComposeScreen extends StatefulWidget{
  const ComposeScreen({super.key});

  @override
  State<ComposeScreen> createState()=> _ComposeScreenState();
}

class _ComposeScreenState extends State<ComposeScreen>{
  final _controller = TextEditingController();
  final _tweetController = Get.find<TweetController>();
  bool _isLoading = false;

  Future<void> _submit() async{
    if(_controller.text.trim().isEmpty){
      Get.snackbar('오류', '내용을 입력해주세요');
      return;
    }

    setState(() => _isLoading = true);

    final succes = await _tweetController.createTweet(_controller.text);

    setState(() => _isLoading = false);

    if(succes){
      Get.back();
    }
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

   @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('트윗 작성'),
          actions: [
            // 게시 버튼 (로딩중이면 비활성화)
            TextButton(
              onPressed: _isLoading ? null : _submit,
              child: _isLoading
                ? const SizedBox(
                    width: 20, height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('게시'),
            ),
          ],
        ),
          body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  maxLength: 280,  // 트위터처럼 280자 제한
                  maxLines: null,  // 여러 줄 입력 가능
                  expands: true,   // 남은 공간 채우기
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    hintText: '무슨 일이 일어나고 있나요?',
                    border: InputBorder.none,
                  ),
                  // 글자수 업데이트
                  onChanged: (_) => setState(() {}),  
                ),
              ),
            ],
          ),
        ),
      );
    }
}