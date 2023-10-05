import 'package:emotions_journaling/presentation/pages/journal_entry_page.dart';
import 'package:emotions_journaling/presentation/pages/main_navigation_page.dart';
import 'package:emotions_journaling/presentation/providers/auth_model.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as firebase_ui;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AuthPage extends StatelessWidget {
  const AuthPage({super.key});


  @override
  Widget build(BuildContext context) {

    return Consumer<AuthModel>(
      builder: (context, authNotifier, _) {
        // User is not signed in
        if (!authNotifier.isAuthenticated) {
          return firebase_ui.SignInScreen(
            headerBuilder: (context, constraints, _) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset('lib/assets/images/appicon-style-journal-with-a-pen-design-ui-app-flat-icon.png'),
                ),
              );
            },
            providers: [firebase_ui.EmailAuthProvider()],
            actions: [
              firebase_ui.AuthStateChangeAction<firebase_ui.SignedIn>((context, state) {
                Navigator.push((context), MaterialPageRoute(builder: (context) =>  const JournalEntryPage()));
              }),
            ],
          );
        }
        // Render your application if authenticated
        return const MainNavigationPage();
      },
    );

  }
}