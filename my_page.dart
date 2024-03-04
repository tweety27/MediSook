/// my page
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'diary_service.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _HomePageState();
}

class _HomePageState extends State<MyPage> {
  // 달력 보여주는 형식
  CalendarFormat calendarFormat = CalendarFormat.month;

  // 선택된 날짜
  DateTime selectedDate = DateTime.now();

  // create text controller
  TextEditingController createTextController = TextEditingController();

  // update text controller
  TextEditingController updateTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<DiaryService>(
      builder: (context, diaryService, child) {
        List<Diary> diaryList = diaryService.getByDate(selectedDate);
        return Scaffold(
          // 키보드가 올라올 때 화면 밀지 않도록 만들기(overflow 방지)
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Column(
              children: [
                /// 달력
                TableCalendar(
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: selectedDate,
                  calendarFormat: calendarFormat,
                  onFormatChanged: (format) {
                    // 달력 형식 변경
                    setState(() {
                      calendarFormat = format;
                    });
                  },
                  eventLoader: (date) {
                    // 각 날짜에 해당하는 diaryList 보여주기
                    return diaryService.getByDate(date);
                  },
                  calendarStyle: CalendarStyle(
                    // today 색상 제거
                    todayTextStyle: TextStyle(color: Colors.black),
                    todayDecoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  selectedDayPredicate: (day) {
                    return isSameDay(selectedDate, day);
                  },
                  onDaySelected: (_, focusedDay) {
                    setState(() {
                      selectedDate = focusedDay;
                    });
                  },
                ),
                Divider(height: 1),

                /// 선택한 날짜의 일기 목록
                Expanded(
                  child: diaryList.isEmpty
                      ? Center(
                          child: Text(
                            "복용중인 의약품을 작성해주세요.",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: diaryList.length,
                          itemBuilder: (context, index) {
                            // 역순으로 보여주기
                            int i = diaryList.length - index - 1;
                            Diary diary = diaryList[i];
                            return ListTile(
                              /// text
                              title: Text(
                                diary.text,
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                ),
                              ),

                              /// createdAt
                              trailing: Text(
                                DateFormat('kk:mm').format(diary.createdAt),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),

                              /// 클릭하여 update
                              onTap: () {
                                showUpdateDialog(diaryService, diary);
                              },

                              /// 꾹 누르면 delete
                              onLongPress: () {
                                showDeleteDialog(diaryService, diary);
                              },
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            // item 사이에 Divider 추가
                            return Divider(height: 1);
                          },
                        ),
                ),
              ],
            ),
          ),

          /// Floating Action Button
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.indigo,
            onPressed: () {
              showCreateDialog(diaryService);
            },
            child: Icon(Icons.create),
          ),
        );
      },
    );
  }

  /// 작성하기
  /// 엔터를 누르거나 작성 버튼을 누르는 경우 호출
  void createDiary(DiaryService diaryService) {
    // 앞뒤 공백 삭제
    String newText = createTextController.text.trim();
    if (newText.isNotEmpty) {
      diaryService.create(newText, selectedDate);
      createTextController.text = "";
    }
  }

  /// 수정하기
  /// 엔터를 누르거나 수정 버튼을 누르는 경우 호출
  void updateDiary(DiaryService diaryService, Diary diary) {
    // 앞뒤 공백 삭제
    String updatedText = updateTextController.text.trim();
    if (updatedText.isNotEmpty) {
      diaryService.update(
        diary.createdAt,
        updatedText,
      );
    }
  }

  /// 작성 다이얼로그 보여주기
  void showCreateDialog(DiaryService diaryService) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("복용중인 의약품"),
          content: TextField(
            controller: createTextController,
            autofocus: true,
            // 커서 색상
            cursorColor: Colors.indigo,
            decoration: InputDecoration(
              hintText: "복용중인 의약품을 등록해주세요.",
              // 포커스 되었을 때 밑줄 색상
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.indigo),
              ),
            ),
            onSubmitted: (_) {
              // 엔터 누를 때 작성하기
              createDiary(diaryService);
              Navigator.pop(context);
            },
          ),
          actions: [
            /// 취소 버튼
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "취소",
                style: TextStyle(color: Colors.indigo),
              ),
            ),

            /// 작성 버튼
            TextButton(
              onPressed: () {
                createDiary(diaryService);
                Navigator.pop(context);
              },
              child: Text(
                "작성",
                style: TextStyle(color: Colors.indigo),
              ),
            ),
          ],
        );
      },
    );
  }

  /// 수정 다이얼로그 보여주기
  void showUpdateDialog(DiaryService diaryService, Diary diary) {
    showDialog(
      context: context,
      builder: (context) {
        updateTextController.text = diary.text;
        return AlertDialog(
          title: Text("약품명 수정"),
          content: TextField(
            autofocus: true,
            controller: updateTextController,
            // 커서 색상
            cursorColor: Colors.indigo,
            decoration: InputDecoration(
              hintText: "복용중인 의약품을 작성해 주세요.",
              // 포커스 되었을 때 밑줄 색상
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.indigo),
              ),
            ),
            onSubmitted: (v) {
              // 엔터 누를 때 수정하기
              updateDiary(diaryService, diary);
              Navigator.pop(context);
            },
          ),
          actions: [
            /// 취소 버튼
            TextButton(
              child: Text(
                "취소",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.indigo,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),

            /// 수정 버튼
            TextButton(
              child: Text(
                "수정",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.indigo,
                ),
              ),
              onPressed: () {
                // 수정하기
                updateDiary(diaryService, diary);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  /// 삭제 다이얼로그 보여주기
  void showDeleteDialog(DiaryService diaryService, Diary diary) {
    showDialog(
      context: context,
      builder: (context) {
        updateTextController.text = diary.text;
        return AlertDialog(
          title: Text("의약품 삭제"),
          content: Text('"${diary.text}"를 삭제하시겠습니까?'),
          actions: [
            TextButton(
              child: Text(
                "취소",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.indigo,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),

            /// Delete
            TextButton(
              child: Text(
                "삭제",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.indigo,
                ),
              ),
              onPressed: () {
                diaryService.delete(diary.createdAt);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
