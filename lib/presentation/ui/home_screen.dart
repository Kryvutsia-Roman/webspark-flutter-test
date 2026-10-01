import 'package:flutter/material.dart';

import 'process_screen.dart';

/// Screen 1: Home Screen for entering API base URL.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _urlController = TextEditingController(
    text: 'https://flutter.webspark.dev/flutter/api',
  );
  String? _errorMessage;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  /// Validates whether the provided string is a valid HTTP/HTTPS URL.
  bool _isValidUrl(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return false;
    final uri = Uri.tryParse(trimmed);
    return uri != null &&
        uri.hasAbsolutePath &&
        (uri.isScheme('http') || uri.isScheme('https'));
  }

  void _onStartCounting() {
    final inputUrl = _urlController.text.trim();

    if (!_isValidUrl(inputUrl)) {
      setState(() {
        _errorMessage = 'Invalid URL. Please enter a valid HTTP/HTTPS address.';
      });
      return;
    }

    setState(() {
      _errorMessage = null;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProcessScreen(baseUrl: inputUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home screen'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Set valid API base URL in order to continue',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _urlController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.compare_arrows),
                  border: const OutlineInputBorder(),
                  labelText: 'API Base URL',
                  errorText: _errorMessage,
                ),
                onChanged: (_) {
                  if (_errorMessage != null) {
                    setState(() {
                      _errorMessage = null;
                    });
                  }
                },
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _onStartCounting,
                  child: const Text('Start counting process'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
