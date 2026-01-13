import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/bottom_nav_item.dart';

/// 카카오뱅크 느낌(알약 pill + blur) 하단바 + 오른쪽 AI 버튼
/// - pill 아래에만 스크림(음영) → AI 버튼과 gap 어색함 제거
/// - 전체 톤을 조금 더 밝게(배경과 자연스럽게)
class BottomBar extends StatelessWidget {
  const BottomBar({
    super.key,
    required this.items,
    required this.index,
    required this.onChanged,
    required this.onAiTap,
    this.aiIcon = Icons.auto_awesome_rounded,
  });

  final List<BottomNavItem> items;
  final int index;
  final ValueChanged<int> onChanged;
  final VoidCallback onAiTap;
  final IconData aiIcon;

  @override
  Widget build(BuildContext context) {
    const double aiSize = 56; // AI 버튼 크기
    const double aiGap = 12;  // pill 바와 AI 버튼 사이 간격
    const double bottom = 6;  // 버튼 바닥 위치

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // ✅ pill만 오른쪽 AI 영역만큼 비워서 배치
          Padding(
            padding: const EdgeInsets.only(right: aiSize + aiGap),
            child: _PillNav(
              items: items,
              index: index,
              onChanged: onChanged,
            ),
          ),

          // ✅ AI 버튼은 독립된 유리 버튼
          Positioned(
            right: 0,
            bottom: bottom,
            child: _AiButton(
              icon: aiIcon,
              onTap: onAiTap,
            ),
          ),
        ],
      ),
    );
  }
}

/// ---- 내부 구현(파일 내부 전용) ----

class _PillNav extends StatelessWidget {
  const _PillNav({
    required this.items,
    required this.index,
    required this.onChanged,
  });

  final List<BottomNavItem> items;
  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Stack(
        children: [
          // ✅ 0) pill 아래에만 아주 은은한 스크림(밝게 조정)
          // AI 버튼쪽 gap에는 영향 없음
          Positioned(
            left: -10,
            right: -10,
            bottom: -18,
            child: IgnorePointer(
              child: Container(
                height: 88,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Color(0x07000000), // 아주 약하게
                      Color(0x0C000000), // 아래쪽만 살짝
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ✅ 1) 블러(유리 느낌)
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                // 기존보다 살짝 더 밝게
                color: Colors.white.withOpacity(0.84),
                borderRadius: BorderRadius.circular(28),
                // 테두리도 더 은은하게(검정 대신 흰색 계열)
                border: Border.all(
                  color: Colors.white.withOpacity(0.55),
                  width: 1,
                ),
              ),
            ),
          ),

          // ✅ 2) pill 내부 하이라이트/음영 (너무 어둡지 않게)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.20),
                      Colors.black.withOpacity(0.03),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ✅ 3) 실제 탭 내용
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                // pill 자체 그림자도 살짝 줄여서 더 밝게
                BoxShadow(
                  blurRadius: 16,
                  offset: const Offset(0, 10),
                  color: Colors.black.withOpacity(0.10),
                ),
              ],
            ),
            child: Row(
              children: List.generate(items.length, (i) {
                final selected = i == index;
                final item = items[i];

                return Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () => onChanged(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      curve: Curves.easeOut,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: selected
                            ? Colors.black.withOpacity(0.06)
                            : Colors.transparent,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item.icon,
                            size: 22,
                            color: selected ? Colors.black : Colors.black54,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.1,
                              fontWeight:
                                  selected ? FontWeight.w700 : FontWeight.w500,
                              color: selected ? Colors.black : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _AiButton extends StatelessWidget {
  const _AiButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Stack(
        children: [
          // ✅ AI 버튼도 유리 느낌(밝게)
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.90),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.white.withOpacity(0.55),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 16,
                    offset: const Offset(0, 12),
                    color: Colors.black.withOpacity(0.14),
                  ),
                ],
              ),
            ),
          ),

          // ✅ 내부 하이라이트(과하지 않게)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.18),
                      Colors.black.withOpacity(0.04),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ✅ 터치
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(28),
              child: SizedBox(
                width: 56,
                height: 56,
                child: Icon(icon, size: 26, color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
