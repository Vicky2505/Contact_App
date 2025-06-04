import 'package:uuid/uuid.dart';
import '../../domain/entities/contact.dart';
import '../../domain/repositories/contact_repository.dart';

class ContactRepositoryImpl implements ContactRepository {
  final _store = <Contact>[];
  final _uuid = const Uuid();

  @override
  List<Contact> getAll() => List.unmodifiable(_store);

  @override
  void add(Contact contact) {
    final newContact = contact.id.isEmpty
        ? contact.copyWith(id: _uuid.v4())
        : contact;

    _store.add(newContact);
  }

  @override
  void update(Contact contact) {
    final index = _store.indexWhere((c) => c.id == contact.id);
    if (index != -1) {
      _store[index] = contact;
    }
  }

  @override
  void delete(String id) {
    _store.removeWhere((c) => c.id == id);
  }
}
