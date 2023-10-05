


 class JournalUtils{

   static final Map<String, String> emotions = {
     'Happy': '😀',
     'Sad': '😞',
     'Angry': '😠',
     'Relaxed': '😌',

   };

   // the emoji that is selected in the EmotionSelector widget
   static String getEmojiForEmotion(String emotionName) {
     // Check if the emotionName exists in the emotions map, return the emoji if it does, otherwise return a default emoji or value.
     return emotions[emotionName] ?? '😃';
   }

    // This method returns a snippet of the fullText.
   static String getSnippet(String fullText, [int length = 40]) {
     // Check if the fullText is shorter than the desired length.
     if (fullText.length <= length) {
       return fullText;
     }

     // Return a substring of the desired length appended with an ellipsis.
     return '${fullText.substring(0, length)}...';
   }


}