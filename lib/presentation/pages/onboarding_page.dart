import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_navigation_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  OnboardingPageState createState() => OnboardingPageState();
}

class OnboardingPageState extends State<OnboardingPage> {
  List<ContentConfig> slides = [];

  @override
  void initState() {
    super.initState();

    slides.add(
      const ContentConfig(
        title: "Welcome",
        description: "Dive into a space tailored just for your thoughts. Start your personal journaling journey with us today.",
        pathImage: "lib/assets/images/a-journal-diary-with-a-pen-for-design.png",
        backgroundColor: Color(0xffFFDAB9),
      ),
    );

    slides.add(
      const ContentConfig(
        title: "Explore",
        description: "Rediscover memories, organize thoughts, and capture fleeting moments. Every entry is a new adventure waiting to unfold",
        pathImage: "lib/assets/images/a-journal-diary-with-a-pen-for-design.png",
        backgroundColor: Color(0xffFFB6C1),
      ),
    );
  }

  void onDonePress() async {
    // Mark onboarding as done and navigate to your main screen.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onBoardingDone', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute (builder: (BuildContext context) => const MainNavigationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      listContentConfig: slides,
      onDonePress: onDonePress,
      // You can customize other properties, check the documentation.
    );
  }
}
