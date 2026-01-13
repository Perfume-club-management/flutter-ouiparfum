import 'package:get/get.dart';
import '../models/tweet.dart';
import '../services/api_service.dart';

class TweetController extends GetxController{
  final _api = Get.find<ApiService>();

  final RxList<Tweet> tweets = <Tweet>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit(){
    super.onInit();
    loadTimeline();
  }

  Future<void> loadTimeline() async{
    isLoading.value = true;

    try{
      final data = await _api.getTimeline();

      tweets.value = data.map((json)=> Tweet.fromJson(json)).toList();
    }catch(e){
      Get.snackbar('오류', '타임라인을 불러올 수 없습니다.');
    }finally {
      isLoading.value = false;
    }
  }

  Future<bool> createTweet(String content) async{
    if(content.trim().isEmpty) return false;

    try{
      final res = await _api.createTweet(content);
      if(res.statusCode == 201){
        await loadTimeline();

        return true;
      }
    }catch(e){
      Get.snackbar('오류', '트윗 작성 실패');
    }
    return false;
  }

  Future<void> deleteTweet(int id) async{
    try{
      final succes = await _api.deleteTweet(id);

      if(succes){
        tweets.removeWhere((t)=> t.id == id);
        Get.snackbar('완료', '트윗이 삭제되었습니다');
      }
    } catch(e){
        Get.snackbar('오류', '삭제 실패');
    }
  }

  Future<void> toggleLike(int tweetId) async{
    try{
      final result = await _api.toggleLike(tweetId);

      if(result != null){
        final index = tweets.indexWhere((t)=> t.id == tweetId);
        if(index != -1){
          tweets[index] = tweets[index].copyWith(
            isLiked: result['liked'],
            likeCount: result['like_count'],
          );
        }
      }
    } catch(e){
      Get.snackbar('오류', '좋아요 실패');
    }
  }
}