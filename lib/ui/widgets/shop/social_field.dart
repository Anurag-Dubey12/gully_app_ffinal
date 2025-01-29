import 'package:flutter/material.dart';
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
class SocialLinkField extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;
  final VoidCallback onRemove;

  const SocialLinkField({
    Key? key,
    required this.initialValue,
    required this.onChanged,
    required this.onRemove,
  }) : super(key: key);

  @override
  _SocialLinkFieldState createState() => _SocialLinkFieldState();
}

class _SocialLinkFieldState extends State<SocialLinkField> {
  late TextEditingController _controller;
  String _domain = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _updateDomain();
  }

  void _updateDomain() {
    setState(() {
      _domain = getDomainFromUrl(_controller.text);
    });
  }

  String getDomainFromUrl(String url) {
    if (url.isEmpty) return '';
    try {
      Uri uri = Uri.parse(url);
      String domain = uri.host;
      List<String> parts = domain.split('.');
      if (parts.length > 1) {
        return parts[parts.length - 2].capitalize();
      }
      return domain.capitalize();
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_domain.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                _domain,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 12.0,
                    ),
                    hintText: 'Enter social media URL',
                    hintStyle: const TextStyle(fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    isDense: true,
                  ),
                  onChanged: (value) {
                    widget.onChanged(value);
                    _updateDomain();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid URL';
                    }
                    return null;
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 25),
                onPressed: widget.onRemove,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}