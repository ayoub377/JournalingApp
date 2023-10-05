import 'package:emotions_journaling/presentation/controllers/journal_controller.dart';
import 'package:emotions_journaling/presentation/controllers/profile_page_controller.dart';
import 'package:emotions_journaling/presentation/pages/auth_page.dart';
import 'package:emotions_journaling/presentation/pages/journal_history_page.dart';
import 'package:emotions_journaling/presentation/pages/profile_page.dart';
import 'package:emotions_journaling/presentation/pages/onboarding_page.dart';
import 'package:emotions_journaling/presentation/providers/auth_model.dart';
import 'package:emotions_journaling/presentation/providers/emotions_model.dart';
import 'package:emotions_journaling/presentation/pages/main_navigation_page.dart';
import 'package:emotions_journaling/presentation/providers/journal_history_model.dart';
import 'package:emotions_journaling/presentation/providers/profil_model.dart';
import 'package:emotions_journaling/presentation/providers/theme_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/repositories/journal_repository.dart';
import 'data/repositories/user_repository.dart';
import 'domain/use_cases/add_entry.dart';
import 'domain/use_cases/add_profile_image.dart';
import 'domain/use_cases/get_entries.dart';
import 'domain/use_cases/remove_entry.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool onBoardingDone = prefs.getBool('onBoardingDone') ?? false;
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  setupLocator();
  runApp(
    // Providers that manage States
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => EmotionsModel()),
          ChangeNotifierProvider(create: (_) => AuthModel()),
          ChangeNotifierProvider(create: (_) => JournalHistoryModel()),
          ChangeNotifierProvider(create: (_) => ProfileModel()),
          ChangeNotifierProvider(create: (_)=> ThemeModel()),
        ],
        child: MyApp(onBoardingDone: onBoardingDone),
      ),
  );
}

final locator = GetIt.instance;

void setupLocator() {

  // register the used Dependencies to inject them in classes

  locator.registerLazySingleton(() => JournalRepository());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => AddJournalEntry(locator<JournalRepository>()));
  locator.registerLazySingleton(() => GetJournalEntries(locator<JournalRepository>()));
  locator.registerLazySingleton(() => JournalController(locator<AddJournalEntry>(),locator<GetJournalEntries>()));
  locator.registerLazySingleton(() => RemoveEntry(locator<JournalRepository>()));
  locator.registerLazySingleton(() => AddImageToProfile(locator<UserRepository>()));
  locator.registerLazySingleton(() => ProfilePageController(locator<AddImageToProfile>()));

}

void configureLoadingStyle() {
  // Configure the loading style
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = Colors.black
    ..indicatorColor = Colors.white
    ..textColor = Colors.white;
}

void configureSuccessStyle() {
  // Configure the success style
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.white
    ..textColor = Colors.white;
}

void configureErrorStyle() {
  // Configure the error style
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = Colors.red
    ..indicatorColor = Colors.white
    ..textColor = Colors.white;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  // bool that indicates if the onboarding is done or not
   final bool onBoardingDone;
   const MyApp({super.key,required this.onBoardingDone});
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (context,themeModel,child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeModel.currentTheme(),
          home: onBoardingDone ? const MainNavigationPage() : const OnboardingPage(),
          routes: {
            '/profile': (context) => const ProfilePage(),
            '/sign-in': (context) => const AuthPage(),
            '/history': (context) => const JournalHistoryPage(),
          },
          builder: EasyLoading.init(),
        );
      }
    );
  }
}
