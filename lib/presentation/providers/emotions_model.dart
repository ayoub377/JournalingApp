import 'package:flutter/material.dart';
import '../../domain/entities/emotion.dart';



class EmotionsModel extends ChangeNotifier{

  String? selectedEmotion;

  final List<Emotion> emotions = [
    Emotion("Happy", "😀", Colors.yellow),
    Emotion("Sad", "😞", Colors.grey),
    Emotion("Angry", "😠", Colors.red),
    Emotion("Relaxed", "😌", Colors.green)
  ];

  void resetSelection() {
    selectedEmotion = null;
    notifyListeners();
  }

  void selectEmotion(String emotion) {
    selectedEmotion = emotion;
    notifyListeners();
  }

}