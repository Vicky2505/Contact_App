import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/contact_bloc.dart';
import '../../domain/entities/contact.dart';

class AddEditContactPage extends StatefulWidget {
  final Contact? contact;

  const AddEditContactPage({super.key, this.contact});

  @override
  State<AddEditContactPage> createState() => _AddEditContactPageState();
}

class _AddEditContactPageState extends State<AddEditContactPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact?.name ?? '');
    _phoneController = TextEditingController(text: widget.contact?.phone ?? '');
    _emailController = TextEditingController(text: widget.contact?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveContact() {
    if (_formKey.currentState!.validate()) {
      final contact = Contact(
        id: widget.contact?.id ?? '',
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
      );

      final bloc = context.read<ContactBloc>();
      if (widget.contact == null) {
        bloc.add(AddContactEvt(contact));
      } else {
        bloc.add(UpdateContactEvt(contact));
      }

      Navigator.pop(context);
    }
  }

  InputDecoration _inputDecoration(String label) {
    final theme = Theme.of(context);
    return InputDecoration(
      labelText: label,
      labelStyle: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEdit = widget.contact != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Contact' : 'Add Contact',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.lightBlue,
        // ignore: deprecated_member_use
        shadowColor: Colors.lightBlue.withOpacity(0.4),
        shape: const Border(
          bottom: BorderSide(width: 1.5, color: Colors.lightBlue),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: theme.shadowColor.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            constraints: const BoxConstraints(maxWidth: 450),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isEdit) ...[
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        widget.contact!.name.isNotEmpty
                            ? widget.contact!.name[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  TextFormField(
                    controller: _nameController,
                    decoration: _inputDecoration('Name'),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Required'
                        : null,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _phoneController,
                    decoration: _inputDecoration('Phone'),
                    keyboardType: TextInputType.phone,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Required'
                        : null,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: _inputDecoration('Email (optional)'),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _saveContact,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 5,
                        // ignore: deprecated_member_use
                        shadowColor: Colors.blue.withOpacity(0.5),
                      ),
                      child: const Text(
                        'Add Contact',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
    );
  }
}
