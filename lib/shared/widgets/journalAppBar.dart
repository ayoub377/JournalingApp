import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/providers/theme_model.dart';



class JournalAppBar extends StatelessWidget implements PreferredSizeWidget {

  final String title;
  final List<Widget>? actions;
  const JournalAppBar({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (context, themeModel, child) {
        return AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(title, style: const TextStyle(color: Colors.white))
            ),
            ),
          actions: actions,
          );
      }
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // This is the default AppBar height
}
