import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repositories/contact_repository_impl.dart';
import 'presentation/bloc/contact_bloc.dart';
import 'presentation/screens/contact_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final contactRepository = ContactRepositoryImpl();

    return BlocProvider(
      create: (_) => ContactBloc(contactRepository)..add(const LoadContacts()),
      child: MaterialApp(
        title: 'Flutter Contacts Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        darkTheme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
        ),
        themeMode: ThemeMode.system,
        home: const ContactListPage(),
      ),
    );
  }
}
