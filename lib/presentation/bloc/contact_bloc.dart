// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import '../../domain/entities/contact.dart';
import '../../domain/repositories/contact_repository.dart';

part 'contact_event.dart';
part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final ContactRepository repo;

  ContactBloc(this.repo) : super(const ContactInitial()) {
    on<LoadContacts>((_, emit) => _emitSorted(repo.getAll(), emit));

    on<AddContactEvt>((e, __) {
      repo.add(e.contact);
      add(const LoadContacts());
    });

    on<UpdateContactEvt>((e, __) {
      repo.update(e.contact);
      add(const LoadContacts());
    });

    on<DeleteContactEvt>((e, __) {
      repo.delete(e.id);
      add(const LoadContacts());
    });

    on<SearchContactEvt>((e, emit) {
      final q = e.query.toLowerCase();
      final res = repo
          .getAll()
          .where((c) => c.name.toLowerCase().contains(q))
          .toList();
      _emitSorted(res, emit);
    });
  }

  void _emitSorted(List<Contact> list, Emitter<ContactState> emit) {
    list.sort((a, b) => a.name.compareTo(b.name));
    emit(ContactLoaded(list));
  }
}