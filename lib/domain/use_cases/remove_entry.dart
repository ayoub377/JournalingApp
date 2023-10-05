


import 'package:emotions_journaling/data/repositories/journal_repository.dart';
import 'package:emotions_journaling/domain/entities/journal_entry.dart';

class RemoveEntry {
  final JournalRepository _journalRepository;

  RemoveEntry(this._journalRepository);

  Future<void> call(JournalEntry entry) async {
    return await _journalRepository.removeEntry(entry);
  }
}