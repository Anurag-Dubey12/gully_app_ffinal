import 'package:flutter/material.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:gully_app/ui/widgets/shop/social_field.dart';

class SocialMedia extends StatefulWidget {
  const SocialMedia({Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SocialMediaState();
}

class _SocialMediaState extends State<SocialMedia> {
  List<Map<String, String>> socialLinks = [];

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
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
                  },
                  onRemove: () => removeSocialLink(index),
                );
              },
            ),
            socialLinks.isEmpty ?Center(child: PrimaryButton(
              onTap: addSocialLink,
              title: 'Add Social Media Url',
              fontSize: 12,
            ),):
            SizedBox(
              width: 100,
              height: 40,
              child: PrimaryButton(
                onTap: addSocialLink,
                title: 'Add More Url',
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
