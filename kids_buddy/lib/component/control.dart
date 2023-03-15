
import 'package:url_launcher/url_launcher.dart';

Future<void> _launchUrl(Uri urlString) async {
  if(await canLaunchUrl(urlString)){
    await launchUrl(urlString);
  }else{

  }
}