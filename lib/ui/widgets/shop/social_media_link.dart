import 'package:flutter/material.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:gully_app/ui/widgets/shop/social_field.dart';

class SocialMedia extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Map<String, dynamic> formData;

  const SocialMedia({Key? key, required this.formKey, required this.formData})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SocialMediaState();
}

class _SocialMediaState extends State<SocialMedia> {
  List<Map<String, String>> socialLinks = [];

  @override
  void initState() {
    super.initState();
    if (widget.formData['socialLinks'] != null) {
      socialLinks =
          List<Map<String, String>>.from(widget.formData['socialLinks']);
    }
    if (socialLinks.isEmpty) {
      addSocialLink();
    }
  }

  void addSocialLink() {
    setState(() {
      socialLinks.add({'url': ''});
    });
  }

  void removeSocialLink(int index) {
    setState(() {
      socialLinks.removeAt(index);
      if (socialLinks.isEmpty) {
        addSocialLink();
      }
    });
  }

  String getDomainFromUrl(String url) {
    Uri uri = Uri.parse(url);
    String domain = uri.host;
    List<String> parts = domain.split('.');
    if (parts.length > 1) {
      return parts[parts.length - 2].capitalize();
    }
    return domain.capitalize();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: 100,
              height: 40,
              child: PrimaryButton(
                onTap: addSocialLink,
                title: 'Add More Url',
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: socialLinks.length,
              itemBuilder: (context, index) {
                return SocialLinkField(
                  key: ValueKey(index),
                  initialValue: socialLinks[index]['url'] ?? '',
                  onChanged: (value) {
                    socialLinks[index]['url'] = value;
                    widget.formData['socialLinks'] = socialLinks;
                  },
                  onRemove: () => removeSocialLink(index),
                );
              },
            ),
            // ElevatedButton.icon(
            //   onPressed: addSocialLink,
            //   icon: const Icon(Icons.add),
            //   label: const Text('Add More'),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.green,
            //   ),
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //
            //     ElevatedButton.icon(
            //       onPressed: () {
            //         if (widget.formKey.currentState!.validate()) {
            //           widget.formKey.currentState!.save();
            //           print('Social links saved: $socialLinks');
            //         }
            //       },
            //       icon: const Icon(Icons.check),
            //       label: const Text('Save'),
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.blue,
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
