import 'package:findconnect/screens/profile.dart';
import 'package:flutter/material.dart';

import '../data/user_model.dart';

class SearchTile extends StatelessWidget {
  final UserModel userModel;

  const SearchTile({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: ListTile(
          onTap: () {
            Navigator.push(context, UserProfile.route(userModel));
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(userModel.profilePic),
            radius: 30,
          ),
          title: Text(
            userModel.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '@${userModel.name}',
                style: const TextStyle(fontSize: 14),
              ),
              SizedBox(width: 20),
              Text(
                userModel.bio,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
