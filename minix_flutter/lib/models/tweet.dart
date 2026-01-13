import 'package:get/get.dart';

class Tweet{
  final int id;
  final int userId;
  final String content;
  final String? image;
  final DateTime createdAt;
  final String name;
  final String username;
  final String? profileImage;
  final int likeCount;
  final bool isLiked;

  Tweet({
    required this.id,
    required this.userId,
    required this.content,
    this.image,
    required this.createdAt,
    required this.name,
    required this.username,
    this.profileImage,
    required this.likeCount,
    required this.isLiked,
  });

   factory Tweet.fromJson(Map<String, dynamic> json) {
  final author = (json['author'] is Map<String, dynamic>)
      ? json['author'] as Map<String, dynamic>
      : <String, dynamic>{};

  return Tweet(
    id: json['id'] as int,
    userId: (author['id'] ?? 0) as int, // ✅ author.id 사용
    content: (json['content'] ?? '') as String,
    image: json['image'] as String?,    // 서버가 없으면 null OK
    createdAt: DateTime.parse((json['created_at'] ?? '').toString()),
    name: (author['name'] ?? '') as String,
    username: (author['username'] ?? '') as String,
    profileImage: author['profile_image'] as String?,
    likeCount: (json['like_count'] ?? 0) as int,
    isLiked: json['is_liked'] == true || json['is_liked'] == 1,
  );
}

 // copyWith: 일부 값만 바꾼 새 객체 생성 (좋아요 토글용)
 Tweet copyWith({int? likeCount, bool? isLiked}) {
   return Tweet(
     id: id, userId: userId, content: content, image: image,
     createdAt: createdAt, name: name, username: username,
     profileImage: profileImage,
     likeCount: likeCount ?? this.likeCount,
     isLiked: isLiked ?? this.isLiked,
   );
 }
}

