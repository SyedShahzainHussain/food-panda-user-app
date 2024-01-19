import "package:url_launcher/url_launcher.dart";

class MapsUtils {
  static Future<void> openMap(String fullAddress) async {
    String address = Uri.encodeComponent(fullAddress);
    String googleMapUrl =
        'https://www.google.com/maps/search/?api=1&query=$address';
    if (await canLaunchUrl(Uri.parse(googleMapUrl))) {
      await launchUrl(Uri.parse(googleMapUrl),
          mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open the map.';
    }
  }

  static Future<void> openMapWithLatLng(double lat, double lng) async {
    String googleMapUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunchUrl(Uri.parse(googleMapUrl))) {
      await launchUrl(Uri.parse(googleMapUrl));
    } else {
      throw 'Could not open the map.';
    }
  }
}
