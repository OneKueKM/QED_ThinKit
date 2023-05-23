import 'package:flutter/material.dart';

class MakeTeamSetting extends StatelessWidget {
  final TextEditingController teamNameController;

  const MakeTeamSetting({
    required this.teamNameController,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: const Color(0xfff1efef),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: '팀 이름',
                  border: InputBorder.none,
                  hoverColor: Colors.grey,
                ),
                controller: teamNameController,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
