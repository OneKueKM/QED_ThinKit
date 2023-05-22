import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tabler_icons/tabler_icons.dart';

class MySlidable extends StatelessWidget {
  Function(BuildContext) editFunction;
  Function(BuildContext) deleteFunction;
  Widget widget;

  MySlidable(
      {Key? key,
      required this.editFunction,
      required this.deleteFunction,
      required this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollable(
      viewportBuilder: (BuildContext context, ViewportOffset position) {
        return Slidable(
          closeOnScroll: true,
          endActionPane: ActionPane(
              extentRatio: 0.3,
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                    onPressed: editFunction,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    autoClose: true,
                    icon: TablerIcons.edit),
                SlidableAction(
                    onPressed: deleteFunction,
                    backgroundColor: Colors.white,
                    foregroundColor: const Color.fromARGB(255, 255, 0, 100),
                    autoClose: true,
                    icon: TablerIcons.eraser)
              ]),
          child: widget,
        );
      },
    );
  }
}
