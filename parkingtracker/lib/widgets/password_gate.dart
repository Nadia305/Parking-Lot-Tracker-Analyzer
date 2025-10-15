import 'package:flutter/material.dart';
import '../core/auth_store.dart';

class PasswordGate extends StatefulWidget {
  final Widget child;
  const PasswordGate({super.key, required this.child});

  @override
  State<PasswordGate> createState() => _PasswordGateState();
}

class _PasswordGateState extends State<PasswordGate> {
  final _ctrl = TextEditingController();
  bool _obscure = true;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AuthStore.I,
      builder: (context, _) {
        if (AuthStore.I.isInitUnlocked) return widget.child;
        return Scaffold(
          appBar: AppBar(title: const Text('Admin Access Required')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Enter admin password to continue:'),
                const SizedBox(height: 12),
                TextField(
                  controller: _ctrl,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: _error,
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  onSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: _submit, child: const Text('Unlock')),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submit() {
    final ok = AuthStore.I.tryUnlock(_ctrl.text.trim());
    if (!ok) setState(() => _error = 'Incorrect password');
  }
}
