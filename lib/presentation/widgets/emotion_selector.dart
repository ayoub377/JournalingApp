import 'package:emotions_journaling/presentation/providers/emotions_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmotionSelector extends StatelessWidget {

  const EmotionSelector({ super.key });

  @override
  Widget build(BuildContext context) {

    return Consumer<EmotionsModel>(
      builder: (context, emotionsModel, child) {
        return SizedBox(
          height: 80, // You can adjust the height as needed
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            scrollDirection: Axis.horizontal,
            itemCount: emotionsModel.emotions.length,
            itemBuilder: (context, index) {
              bool isSelected = emotionsModel.emotions[index].name ==
                  emotionsModel.selectedEmotion;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: isSelected
                        ? emotionsModel.emotions[index].color
                        : Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (isSelected) {
                      emotionsModel.resetSelection();
                    } else {
                      emotionsModel.selectEmotion(emotionsModel.emotions[index]
                          .name);
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        emotionsModel.emotions[index].emoji,
                        style: const TextStyle(fontSize: 32.0),
                      ),
                      const SizedBox(height: 4),
                      Text(emotionsModel.emotions[index].name),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

}
