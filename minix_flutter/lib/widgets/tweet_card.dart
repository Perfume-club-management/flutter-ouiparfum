import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/tweet.dart';

class TweetCard extends StatelessWidget{
  final Tweet tweet;
  final VoidCallback onLike;
  final VoidCallback? onDelete;

  const TweetCard({super.key,required this.tweet, required this.onLike, this.onDelete});

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 프로필 이미지
          const CircleAvatar(
            radius: 24,
            child: Icon(Icons.person),
            backgroundColor: const Color.fromARGB(255, 46, 80, 183),
          ),
          const SizedBox(width: 12,),
          // 트윗 내용
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      tweet.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '@${tweet.username}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '· ${timeago.format(tweet.createdAt, locale:'ko')}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const Spacer(),
                    if(onDelete != null)
                      PopupMenuButton<String>(
                        icon:const Icon(Icons.more_vert, size : 16),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('삭제', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                        onSelected: (value){
                          if(value == 'delete') onDelete!();
                        },
                      )
                  ],
                ),
                const SizedBox(height: 4),
                // 본문
                Text(tweet.content),
                const SizedBox(height: 8),
                // 액션 버튼
                Row(
                  children: [
                    InkWell(
                      onTap: onLike,
                      child: Row(
                        children: [
                          Icon(
                            tweet.isLiked
                              ? Icons.favorite
                              : Icons.favorite_border,
                            size:18,
                            color: tweet.isLiked ? Colors.red : Colors.grey,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${tweet.likeCount}',
                            style: TextStyle(
                              color: tweet.isLiked ? Colors.red : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
        ],
      ),
    );
  }

  String _formatDate(DateTime date){
    final now = DateTime.now();
    final diff = now.difference(date);

    if(diff.inMinutes < 1){
      return '방금';
    } else if(diff.inMinutes < 60){
      return '${diff.inMinutes}분';
    } else if(diff.inHours < 24){
      return '${diff.inHours}시간';
    } else if(diff.inDays < 7){
      return '${diff.inDays}일';
    } else{
      return '${date.month}월 ${date.day}일';
    }
  }
}
