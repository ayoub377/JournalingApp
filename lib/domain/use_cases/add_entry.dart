import '../../data/repositories/journal_repository.dart';
import '../entities/journal_entry.dart';



class AddJournalEntry {

  final JournalRepository repository;

  AddJournalEntry(this.repository);

  Future<void> call(JournalEntry entry) {

    return repository.addEntry(entry);
  }

}
