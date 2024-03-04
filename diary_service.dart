import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class Diary {
  String text; // 내용
  DateTime createdAt; // 작성 시간

  Diary({
    required this.text,
    required this.createdAt,
  });

  /// Diary -> Map 변경
  Map<String, dynamic> toJson() {
    return {
      "text": text,
      // DateTime은 문자열로 변경해야 jsonString으로 변환 가능합니다.
      "createdAt": createdAt.toString(),
    };
  }

  /// Map -> Diary 변경
  factory Diary.fromJson(Map<String, dynamic> jsonMap) {
    return Diary(
      text: jsonMap['text'],
      // 문자열로 넘어온 시간을 DateTime으로 다시 바꿔줍니다.
      createdAt: DateTime.parse(jsonMap['createdAt']),
    );
  }
}

class DiaryService extends ChangeNotifier {
  /// 생성자
  DiaryService(this.prefs) {
    // 생성자가 호출될 때 SharedPreferences로 저장해 둔 diaryList를 불러옵니다.
    // 저장할 때와 반대로 String -> Map -> Diary로 변환합니다.
    List<String> strintDiaryList = prefs.getStringList("diaryList") ?? [];
    for (String stringDiary in strintDiaryList) {
      // String -> Map
      Map<String, dynamic> jsonMap = jsonDecode(stringDiary);

      // Map -> Diary
      Diary diary = Diary.fromJson(jsonMap);
      diaryList.add(diary);
    }
  }

  /// SharedPreferences 인스턴스
  SharedPreferences prefs;

  /// Diary 목록
  List<Diary> diaryList = [];

  /// 특정 날짜의 diary 조회
  List<Diary> getByDate(DateTime date) {
    return diaryList
        .where((diary) => isSameDay(date, diary.createdAt))
        .toList();
  }

  /// Diary 작성
  void create(String text, DateTime selectedDate) {
    DateTime now = DateTime.now();

    // 선택된 날짜(selectedDate)에 현재 시간으로 추가
    DateTime createdAt = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      now.hour,
      now.minute,
      now.second,
    );

    Diary diary = Diary(
      text: text,
      createdAt: createdAt,
    );
    diaryList.add(diary);
    notifyListeners();

    // diary 정보가 변경될 때 마다 저장
    _saveDiaryList();
  }

  /// Diary 수정
  void update(DateTime createdAt, String newContent) {
    // createdAt은 중복될 일이 없기 때문에 createdAt을 고유 식별자로 사용
    // createdAt이 일치하는 diary 조회
    Diary diary = diaryList.firstWhere((diary) => diary.createdAt == createdAt);

    // text 수정
    diary.text = newContent;
    notifyListeners();

    // diary 정보가 변경될 때 마다 저장
    _saveDiaryList();
  }

  /// Diary 삭제
  void delete(DateTime createdAt) {
    // createdAt은 중복될 일이 없기 때문에 createdAt을 고유 식별자로 사용
    // createdAt이 일치하는 diary 삭제
    diaryList.removeWhere((diary) => diary.createdAt == createdAt);
    notifyListeners();

    // diary 정보가 변경될 때 마다 저장
    _saveDiaryList();
  }

  /// 변경된 Diary SharedPreferences로 저장
  void _saveDiaryList() {
    List<String> stringDiaryList = [];
    for (Diary diary in diaryList) {
      // Diary -> Map
      Map<String, dynamic> jsonMap = diary.toJson();

      // Map -> String
      String stringDiary = jsonEncode(jsonMap);
      stringDiaryList.add(stringDiary);
    }
    prefs.setStringList("diaryList", stringDiaryList);
  }
}
