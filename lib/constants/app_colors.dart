import 'package:flutter/material.dart';

/// 아이유 라일락 팔레트 기반 앱 색상
class AppColors {
  AppColors._();

  // Primary Lilac Colors
  static const Color primary = Color(0xFFD7ABE6);      // #d7abe6
  static const Color primaryLight = Color(0xFFF9EDFD); // #f9edfd
  static const Color primaryDark = Color(0xFF9878B7);  // #9878b7

  // Background Colors
  static const Color background = Color(0xFFFCFAFF); // 배경색
  static const Color cardBackground = Color(0xFFFFFFFF); // 카드 배경
  static const Color summaryCardBackground = Color(0xFFF5EEFF); // 요약 카드 배경

  // Text Colors
  static const Color textPrimary = Color(0xFF2D2D2D); // 주요 텍스트
  static const Color textSecondary = Color(0xFF7D7D7D); // 보조 텍스트
  static const Color textHint = Color(0xFFB0B0B0); // 힌트 텍스트

  // Category Badge Colors
  static const Color badgeSubscription = Color(0xFFE8D5F9); // 구독
  static const Color badgeCommunication = Color(0xFFD5E8F9); // 통신비
  static const Color badgeUtility = Color(0xFFF9E8D5); // 관리비
  static const Color badgeInsurance = Color(0xFFF9D5E8); // 보험

  // Badge Text Colors
  static const Color badgeTextSubscription = Color(0xFF8B5CF6);
  static const Color badgeTextCommunication = Color(0xFF5B8DEF);
  static const Color badgeTextUtility = Color(0xFFEF8B5B);
  static const Color badgeTextInsurance = Color(0xFFEF5B8D);

  // Calendar Colors
  static const Color calendarToday = Color(0xFFE9DFFF);
  static const Color calendarSelected = Color(0xFFB794F6);
  static const Color calendarSunday = Color(0xFFEF5B5B);
  static const Color calendarSaturday = Color(0xFF5B8DEF);

  // Misc
  static const Color divider = Color(0xFFEEEEEE);
  static const Color shadow = Color(0x1A000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFE53935);
}
