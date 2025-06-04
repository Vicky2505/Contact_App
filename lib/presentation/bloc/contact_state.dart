part of 'contact_bloc.dart';

sealed class ContactState {
  const ContactState();
}

class ContactInitial extends ContactState {
  const ContactInitial();
}

class ContactLoaded extends ContactState {
  final List<Contact> contacts;
  const ContactLoaded(this.contacts);
}
