import '../entities/contact.dart';

abstract class ContactRepository {
  List<Contact> getAll();
  void add(Contact contact);
  void update(Contact contact);
  void delete(String id);
}