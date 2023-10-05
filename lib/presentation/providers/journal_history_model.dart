import 'package:flutter/cupertino.dart';
import '../../domain/entities/journal_entry.dart';
import '../../domain/use_cases/get_entries.dart';
import '../../domain/use_cases/remove_entry.dart';
import '../../main.dart';

class JournalHistoryModel with ChangeNotifier {

  List<JournalEntry> entries = [];
  final getJournalEntries = locator<GetJournalEntries>();
  final removeEntry = locator<RemoveEntry>();
  bool isLoading = true;
  String? errorMessage;
  bool _isSearching = false;
  bool _isFiltered = false;
  bool get isFiltered => _isFiltered;
  bool get isSearching => _isSearching;
  List<JournalEntry> searchedEntries = [];
  List<JournalEntry> filteredEntries = [];
  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now(),
  ];
  // This will track which emotions are checked or unchecked
  String? selectedEmotion;

  JournalHistoryModel();

  loadEntries() async {
    try {
      entries = (await getJournalEntries.call());
      errorMessage = null;
      isLoading = false;
      notifyListeners();  // Reset the error message after a successful fetch
    } catch (e) {
      errorMessage = "Failed to load entries. Please try again.";
      isLoading = false;
      notifyListeners();
    }
  }

  void toggleSearch() {
    _isSearching = !_isSearching;
    notifyListeners();
  }

  void setPickedDate(List<DateTime?> dates){
      _singleDatePickerValueWithDefaultValue = dates;
      notifyListeners();
  }

  List<DateTime?> getPickedDate(){
    return _singleDatePickerValueWithDefaultValue;
  }
// include to add Sorting functionality
  void sortByDate() {
    entries.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
    notifyListeners();
  }
// include to add Sorting functionality
  void sortByEmotion() {
    // Assuming your JournalEntry has a property called 'emotion' of type String
    entries.sort((a, b) => a.emotion.compareTo(b.emotion));
    notifyListeners();
  }

  Future<void> removeEntryAt(int index) async {
    JournalEntry entry = entries[index];
    entries.removeAt(index);  // First, remove from local
    notifyListeners();  // Update UI

    try {
      await removeEntry.call(entry);  // Attempt deleting from cloud
    }
    catch (e) {
      errorMessage = "Failed to delete entry. Please try again.";
      entries.insert(index, entry);  // Re-add entry to the list if cloud deletion fails
      notifyListeners();  // Update UI to reflect the re-added entry
    }
  }

  void filterByDate(DateTime? date) async {

    filteredEntries = entries.where((entry) {
      return entry.createdAt!.day == date!.day && entry.createdAt!.month == date.month && entry.createdAt!.year == date.year;
    }).toList();
    _isFiltered = true;
    notifyListeners();
  }

  void filterByEmotions(String emotion){
    filteredEntries = entries.where((entry) {
      return entry.emotion == emotion;
    }).toList();
    _isFiltered = true;
    notifyListeners();

}

  void clearSearch() {
    filteredEntries = [];
    _isFiltered = false;  // Explicitly clear the filter
    selectedEmotion = null;
    searchedEntries = [];
    _isSearching = false;  // Explicitly clear the search
    notifyListeners();
  }

  Future<void> clearFilter() async {
    filteredEntries = [];
    _isFiltered = false;  // Explicitly clear the filter
    selectedEmotion = null;
    notifyListeners();
  }

  void search(String query) async {
    searchedEntries = entries.where((entry) {
      return entry.title.toLowerCase().contains(query.toLowerCase()) || entry.content[0]["insert"]!.toLowerCase().contains(query.toLowerCase());
    }).toList();
    notifyListeners();
  }

}
