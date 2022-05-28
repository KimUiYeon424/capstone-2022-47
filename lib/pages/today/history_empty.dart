import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yaksok_project/components/yaksok_constants.dart';

class HistoryEmpty extends StatelessWidget {
  const HistoryEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Center(child: Text('아직 약을 복용한 기록이 없어요~😥')),
        const SizedBox(height: s_size_space),
        Text(
          '약과 영양제를 복용하고 기록을 남겨보세요!',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        const SizedBox(height: l_size_space),
        const SizedBox(height: s_size_space),
        const Icon(CupertinoIcons.arrow_down),
        const SizedBox(height: 30),
      ],
    );
  }
}