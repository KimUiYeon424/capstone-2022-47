import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:yaksok_project/components/yaksok_constants.dart';
import 'package:yaksok_project/models/medicine_history_model.dart';
import 'package:yaksok_project/pages/today/history_empty.dart';
import 'package:yaksok_project/pages/today/today_take_tile.dart';

import 'package:yaksok_project/models/medicine_model.dart';
import '../../main.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // 좌측 정렬
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
          child:
              Text('잘 복용하셨네요!👍', style: Theme.of(context).textTheme.headline4),
        ),
        const SizedBox(height: r_size_space),
        const Divider(height: 1, thickness: 0.5, color: Colors.green,),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: history_repository.history_box.listenable(),
            builder: _buildListView,
          ),
        ),
      ],
    );
  }

  Widget _buildListView(context, Box<MedicineHistory> history_box, _) {
    final histories = history_box.values
        .toList()
        .reversed
        .toList(); // 최신 데이터가 위에 있도록 하기 위해서. toList로 다시 반환

    if (histories.isEmpty) {
      //history page empty 창
      return const HistoryEmpty();
    }
    return ListView.builder(
      itemCount: histories.length,
      itemBuilder: (context, index) {
        final history = histories[index];
        return _TimeTile(history: history);
      },
    );
  }
}

class _TimeTile extends StatelessWidget {
  const _TimeTile({
    Key? key,
    required this.history,
  }) : super(key: key);

  final MedicineHistory history;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 1. 0000년 00월.00일 요일
        Expanded(
          // Expanded로 감싸주면 텍스트가 넘쳐도 개행, flex는 Row 축의 남은 공간을 차지함.
          flex: 1,
          child: Text(
            DateFormat('yyyy\nMM.dd E', 'ko').format(history.history_take_time),
            // ko_KR 또는 ko= locale 값, main.dart, takeTime - medicine_history.dart
            textAlign: TextAlign.center, // 가운데 정렬
            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  height: 1.6, // 각 날짜 공간 크기
                  leadingDistribution: TextLeadingDistribution
                      .even, // 텍스트가 하단에 정렬되는데 가운데로, https://api.flutter.dev/flutter/painting/TextStyle-class.html
                ),
          ),
        ),
        const SizedBox(width: s_size_space),

        // 2. 날짜 구분 세로선과 원
        Stack(
          alignment: const Alignment(0.0, -0.3), // 가운데 정렬, 위치 처리
          children: const [
            SizedBox(
              // 자식 위젯의 size 조절
              height: 130,
              child: VerticalDivider(
                width: 1,
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0,27,0,0),
              child: CircleAvatar(
                // 비어있는 원
                radius: 4,
                child: CircleAvatar(
                  radius: 3,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),

        // 3. 세로선 오른쪽 부분, 이미지와 복용 기록,
        Expanded(
          flex: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // 메인 축을 center로
            children: [
              // if문과 동일한 widget 표현, 이미지 값이 없을 경우 이미지 출력 x
              Visibility(
                  visible: medicine.medicine_image_path != null,
                  child: MedicineImageButton(
                      image_path: medicine.medicine_image_path) //해당하는 ID의 image 출력
                  ),
              SizedBox(width: s_size_space),
              Text(
                DateFormat('a hh:mm', 'ko').format(
                        history.history_take_time) + //a : 오전/오후, locale 없앨 시 AM/PM
                    '\n' +
                    medicine.medicine_name,
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      height: 1.6,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

// history id elements id가 같으면 singleWhere(List 구성요소 중 제시한 조건을 부합하는 첫번째 요소를 반환) 객체 리턴
// singleWhere는 조건에 맞는 요소가 2개 이상이거나 없으면 error return하므로 orElse로 예외 처리
// Id와 Key값이 일치하면 같은 약.
  Medicine get medicine {
    return medicine_repository.medicine_box.values.singleWhere(
      (element) =>
          element.medicine_id == history.history_medicine_id &&
          element.key == history.history_medicine_key,
      orElse: () => Medicine(
        medicine_alarms: [],
        medicine_id: -1,
        medicine_image_path: history.history_image_path,
        medicine_name: history.history_name,
      ),
    );
  }
}
