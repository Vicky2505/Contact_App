part of 'contact_bloc.dart';

abstract class ContactEvent {
  const ContactEvent();
}

class LoadContacts extends ContactEvent {
  const LoadContacts();
}

class AddContactEvt extends ContactEvent {
  final Contact contact;
  const AddContactEvt(this.contact);
}

class UpdateContactEvt extends ContactEvent {
  final Contact contact;
  const UpdateContactEvt(this.contact);
}

class DeleteContactEvt extends ContactEvent {
  final String id;
  const DeleteContactEvt(this.id);
}

class SearchContactEvt extends ContactEvent {
  final String query;
  const SearchContactEvt(this.query);
}
