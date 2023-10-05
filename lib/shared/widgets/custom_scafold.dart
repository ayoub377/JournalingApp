import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/providers/theme_model.dart';


class CustomScaffold extends StatelessWidget {

  final Widget? body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  const CustomScaffold({
    Key? key,
    this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final themeModel = Provider.of<ThemeModel>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: appBar,
      body: themeModel.isDarkTheme ? body : Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2c3e50), Color(0xFF4ca1af)],  // Just an example gradient
          ),
        ),
        child: body,
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton
    );
  }

}
