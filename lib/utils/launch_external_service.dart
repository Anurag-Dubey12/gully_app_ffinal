import 'package:url_launcher/url_launcher.dart';

void launchPhone(String phoneNumber) async {
  final url = 'tel:$phoneNumber';
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  }
}

void launchEmail(String email) async {
  final url = 'mailto:$email';
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  }
}

void launchMaps(double lat, double lng) async {
  final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch Maps';
  }
}

void launchWebsite(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri,
        mode: LaunchMode.externalApplication); 
  } else {
    throw 'Could not launch Website';
  }
}
