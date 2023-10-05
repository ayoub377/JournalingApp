


import 'package:emotions_journaling/data/repositories/journal_repository.dart';
import 'package:emotions_journaling/domain/entities/journal_entry.dart';

class GetEntry{
  final JournalRepository repository;

  GetEntry(this.repository);

  Future<JournalEntry> call(JournalEntry entry) async {
    return await repository.getEntry(entry);
  }

}