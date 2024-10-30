import 'package:flutter/material.dart';

class ModalWidget {
  void showFullModal(BuildContext context, Widget child) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: child,
        );
      },
    );
  }
}
