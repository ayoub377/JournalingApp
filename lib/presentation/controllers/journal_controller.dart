import 'package:emotions_journaling/domain/entities/journal_entry.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/use_cases/add_entry.dart';
import '../../domain/use_cases/get_entries.dart';
import '../providers/emotions_model.dart';


class JournalController {

   XFile? pickedFile;
   String? _emotion;
   final AddJournalEntry _addJournalEntry;
   final GetJournalEntries _getJournalEntries;

   JournalController(this._addJournalEntry, this._getJournalEntries);

   void setEmotion(String? emotion) {
    _emotion = emotion;
  }

   Future<void> saveEntry(List<dynamic> content,String title,String? imageUrl,EmotionsModel emotionsModel) async
  {
    if (content.isNotEmpty && _emotion != null) {
      JournalEntry entry = JournalEntry(content: content, emotion: _emotion!,title: title,imageUrl: imageUrl);
      await _addJournalEntry.call(entry);
       emotionsModel.resetSelection();
    }
    else
    {
      throw Exception("Text and emotion must be set");
    }
  }

   Future<List<JournalEntry>> getEntries() async
  {
    return await _getJournalEntries.call();
  }

   Future<XFile?> pickImage() async {
     pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
     return pickedFile;
   }

}
