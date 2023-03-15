import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


final Uri whatsappUri = Uri.parse("whatsapp://send?phone=201010831303");

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _launchUrl,
                icon: Image.asset('images/whatsappicon.png'),
                iconSize: 70,
              ),
              const Text("01010831303"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () async {
                      await launchUrl(Uri.parse("fb://facewebmodal/f?href=https://www.facebook.com/profile.php?id=100090738654947"));
                  },
                  icon: Image.asset("images/fbicon.png"),
                  iconSize: 70,
              ),
              const Text("Facebook Page"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () async {
                  await launchUrl(Uri.parse("mailto:kidsbuddy023@gmail.com"));
                },
                icon: const Icon(Icons.mail),
                iconSize: 50,
              ),
              const Text("kidsbuddy023@gmail.com"),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> _launchUrl() async {
  if (await canLaunchUrl(whatsappUri)) {
    await launchUrl(whatsappUri, mode: LaunchMode.platformDefault);
  } else {
    throw Exception('Could not launch $whatsappUri');
  }
}
