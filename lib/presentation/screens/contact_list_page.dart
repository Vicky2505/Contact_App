import 'package:contacts_app/domain/entities/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../bloc/contact_bloc.dart';
import 'add_edit_contact_page.dart';

class ContactListPage extends StatelessWidget {
  const ContactListPage({super.key});

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Contacts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.lightBlue,
        // ignore: deprecated_member_use
        shadowColor: Colors.lightBlue.withOpacity(0.4),
        shape: const Border(
          bottom: BorderSide(color: Colors.lightBlue, width: 1.5),
        ),
        actions: [
          Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: IconButton(
              icon: const Icon(Icons.search, size: 26),
              tooltip: 'Search contacts',
              splashRadius: 24,
              onPressed: () async {
                final q = await showSearch(
                  context: context,
                  delegate: _ContactSearchDelegate(),
                );
                if (q != null && q.isNotEmpty) {
                  // ignore: use_build_context_synchronously
                  context.read<ContactBloc>().add(SearchContactEvt(q));
                }
              },
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: BlocBuilder<ContactBloc, ContactState>(
        builder: (context, state) {
          if (state is! ContactLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          final list = state.contacts;
          if (list.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 230,
                    child: Lottie.asset(
                      'assets/empty_animation.json',
                      fit: BoxFit.fill,
                      repeat: true,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'No contacts found',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add new contacts using the + button below',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final c = list[i];
              return Material(
                color: Colors.transparent,
                elevation: 4,
                // ignore: deprecated_member_use
                shadowColor: Colors.blueGrey.withOpacity(.20),
                borderRadius: BorderRadius.circular(18),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  // ignore: deprecated_member_use
                  splashColor: Colors.blueGrey.withOpacity(.12),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddEditContactPage(contact: c),
                    ),
                  ),
                  onLongPress: () => _confirmDelete(context, c),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Theme.of(context).cardColor,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue.shade100,
                          child: Text(
                            c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                c.phone,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 18,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditContactPage()),
          );
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Contact',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

// Function to confirm deletion of a contact
void _confirmDelete(BuildContext context, Contact c) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titlePadding: const EdgeInsets.only(top: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      title: Center(
        child: Lottie.asset(
          'assets/delete_confirm_animation.json',
          height: 140,
          repeat: true,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Delete Contact?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Are you sure you want to delete ${c.name}?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text(
            'Cancel',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton.icon(
          label: const Text(
            'Delete',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            context.read<ContactBloc>().add(DeleteContactEvt(c.id));
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

// Search delegate for searching contacts
class _ContactSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () {
        if (query.isEmpty) {
          close(context, null);
        } else {
          query = '';
          showSuggestions(context);
        }
      },
    ),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, null),
  );

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

  @override
  Widget buildSuggestions(BuildContext context) {
    context.read<ContactBloc>().add(SearchContactEvt(query));

    return BlocBuilder<ContactBloc, ContactState>(
      builder: (_, state) {
        if (state is! ContactLoaded) {
          return const Center(child: CircularProgressIndicator());
        }
        final results = state.contacts;

        if (results.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 160,
                    child: Lottie.asset('assets/search_animation.json'),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'No matching contacts found',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Try searching with a different name or number.',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: results.length,
          separatorBuilder: (_, __) => const Divider(height: 1, thickness: 0.1),
          itemBuilder: (_, i) {
            final c = results[i];
            return Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => close(context, c.name),
                // ignore: deprecated_member_use
                splashColor: Colors.blueGrey.withOpacity(0.2),
                // ignore: deprecated_member_use
                highlightColor: Colors.blueGrey.withOpacity(0.1),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.blue.shade100,
                        child: Text(
                          c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              c.phone,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
