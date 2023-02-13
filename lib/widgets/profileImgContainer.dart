// import 'package:flutter/material.dart';
// import 'package:digginfront/models/userModel.dart';
// import 'dart:io';

// class ProfileImgContainer extends StatefulWidget {
//   ProfileImgContainer({
//     super.key,
//     required this.user,
//     this.profileImage,
//     this.backgroundImage,
//   });

//   final userModel user;
//   File? profileImage;
//   File? backgroundImage;

//   @override
//   State<ProfileImgContainer> createState() => _ProfileImgContainerState();
// }

// class _ProfileImgContainerState extends State<ProfileImgContainer> {
//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//       onPressed: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute<void>(
//             builder: (BuildContext context) => (
//               whichImage: profileImage
//               setImage: setImage,
//             ),
//           ),
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border.all(width: 2),
//           color: Colors.black,
//           shape: BoxShape.circle,
//           image: DecorationImage(
//               fit: BoxFit.cover,
//               image: (widget.user.image != null)
//                   ? NetworkImage(
//                       'http://diggin.kro.kr:4000/${widget.user.image}')
//                   : const NetworkImage(
//                       'http://diggin.kro.kr:4000/media/profile_image/default_profile.png')),
//         ),
//       ),
//     );
//   }
// }
