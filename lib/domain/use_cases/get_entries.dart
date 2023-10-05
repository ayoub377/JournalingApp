import 'package:emotions_journaling/domain/entities/journal_entry.dart';

import '../../data/repositories/journal_repository.dart';

class GetJournalEntries{
  final JournalRepository repository;

  GetJournalEntries(this.repository);

  Future<List<JournalEntry>> call(){
    return repository.getEntries();
  }


}