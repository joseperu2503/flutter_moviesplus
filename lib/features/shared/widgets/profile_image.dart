import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    super.key,
    required this.path,
  });

  final String? path;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: 60,
        height: 60,
        child: path != null
            ? Image.network(
                'https://image.tmdb.org/t/p/w500$path',
                fit: BoxFit.cover,
              )
            : Image.asset(
                'assets/images/no-profile-photo.png',
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
