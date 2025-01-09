import 'package:Movie_Night/src/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Provider/allproviders.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({super.key});

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  @override
  Widget build(BuildContext context) {
    var fetchuserdata = Provider.of<UserData>(context, listen: true);
    var currentUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder<Users?>(
      stream: fetchuserdata.getUserDataStream(currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: Theme.of(context).splashColor,
            strokeWidth: 3,
          ));
        } else if (snapshot.hasError) {
          return Text('Something went wrong');
        } else {
          return Consumer<UserData>(
            builder: (context, userData, child) {
              return SizedBox(
                height: 115,
                width: 115,
                child: Stack(
                  fit: StackFit.expand,
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          "${snapshot.data!.ProfilePic}?${DateTime.now().millisecondsSinceEpoch}"),
                    ),
                    Positioned(
                      right: -16,
                      bottom: 0,
                      child: SizedBox(
                        height: 46,
                        width: 46,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side: BorderSide(color: Colors.white),
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor: Color(0xFFF5F6F9),
                          ),
                          onPressed: () async {
                            await (fetchuserdata.updateimage(
                                currentUser.uid, currentUser));
                          },
                          child: Icon(Icons.camera_alt, color: Colors.black),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
