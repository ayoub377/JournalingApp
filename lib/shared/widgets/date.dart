
import 'package:flutter/material.dart';
import '../themes/app_theme.dart';



class Date extends StatelessWidget {
  const Date({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Text(
      DateTime.now().toString().substring(0, 10),
      style: AppTheme.dateText,
    );
  }
}
