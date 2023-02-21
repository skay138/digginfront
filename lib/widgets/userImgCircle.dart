import 'package:digginfront/services/api_services.dart';
import 'package:flutter/material.dart';
import '../models/userModel.dart';

class UserImgCircle extends StatelessWidget {
  UserImgCircle({super.key, required this.size, required this.uid});
  final double size;
  final String uid;
  late final Future<userModel> user = Account.getProfile(uid);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: user,
      builder: (context, snapshot) {
        return (snapshot.data != null)
            ? SizedBox(
                width: size,
                height: size,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    color: Colors.black,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: (snapshot.data?.image != null)
                            ? NetworkImage(
                                'http://diggin.kro.kr:4000/${snapshot.data!.image}')
                            : const NetworkImage(
                                'http://diggin.kro.kr:4000/media/profile_image/default_profile.png')),
                  ),
                ))
            : SizedBox(
                width: size,
              );
      },
    );
  }
}
