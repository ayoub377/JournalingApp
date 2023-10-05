import 'package:cached_network_image/cached_network_image.dart';
import 'package:emotions_journaling/shared/widgets/journalAppBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/widgets/custom_scafold.dart';
import '../providers/profil_model.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as firebase_ui;
import '../providers/theme_model.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
   ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ProfileModel>(context, listen: true);
    final themeModel = Provider.of<ThemeModel>(context);
    return CustomScaffold(
      appBar: const JournalAppBar(
          title: "Profile",
      ),
      body: Column(
        children: [
          const SizedBox(height: 50,),
          Stack(
            children: [
              // Assuming the avatar is here:
              CircleAvatar(
                radius: 50,
                backgroundImage: FirebaseAuth.instance.currentUser!.photoURL != null
                    ? CachedNetworkImageProvider(FirebaseAuth.instance.currentUser!.photoURL!)
                    : null,
                child: model.pickedImage == null
                    ? null
                    : FutureBuilder(
                        future: model.uploadImage(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator(); // Loading indicator
                          }
                          else if (snapshot.hasError) {
                            return const Icon(Icons.error, color: Colors.red); // Error icon
                          }
                          else {
                            return const Icon(Icons.check, color: Colors.green); // Success checkmark
                          }
                  },
                ),
              ),
              Positioned(
                right: 5,
                bottom: 5,
                child: IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () async {
                    await model.pickImage();
                    await model.uploadImage();
                  },
                ),
              ),
            ],
          ),
          ListTile(
            title: const Text('Dark Theme',style: TextStyle(color: Colors.white),),
            trailing: Switch(
              value: themeModel.currentTheme() == ThemeMode.dark,
              onChanged: (value) {
                themeModel.toggleTheme();
              },
            ),
          ),
          Expanded(
            child: firebase_ui.ProfileScreen(
              providers: [firebase_ui.EmailAuthProvider()],
              avatarSize: 100.0,
              actions: [
                firebase_ui.SignedOutAction((context) {
                  Navigator.pushReplacementNamed(context, '/');
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
