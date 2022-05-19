import 'package:dresscode/models/user.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ProfileCircleAvatar extends StatefulWidget {
  final User user;
  final void Function(String) onPictureChanged;

  const ProfileCircleAvatar({
    Key? key,
    required this.user,
    required this.onPictureChanged,
  }) : super(key: key);

  @override
  State<ProfileCircleAvatar> createState() => _ProfileCircleAvatarState();
}

class _ProfileCircleAvatarState extends State<ProfileCircleAvatar> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Stack(
      children: <Widget>[
        CircleAvatar(
          backgroundColor: colorScheme.primary,
          radius: 50.0,
          child: widget.user.picture == null
              ? Text(
                  widget.user.initials,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                )
              : null,
          backgroundImage: widget.user.picture == null
              ? null
              : FadeInImage(
                  placeholder: Image.asset(
                    'assets/loading.gif',
                    fit: BoxFit.fill,
                  ).image,
                  imageErrorBuilder: (_, __, ___) {
                    return Image.asset(
                      'assets/placeholder.png',
                      fit: BoxFit.fill,
                    );
                  },
                  image: Image.network(
                    widget.user.picture!,
                    fit: BoxFit.fill,
                    errorBuilder: (ctx, obj, stack) {
                      return Image.asset(
                        'assets/placeholder.png',
                        fit: BoxFit.fill,
                      );
                    },
                  ).image,
                  fit: BoxFit.cover,
                ).image,
        ),
        Positioned(
          bottom: 0,
          right: -25,
          child: RawMaterialButton(
            fillColor: colorScheme.onBackground,
            onPressed: () async {
              final filePickerResult =
                  await FilePicker.platform.pickFiles(type: FileType.image);
              final file = filePickerResult?.files.single.path;
              if (file != null) {
                widget.onPictureChanged(file);
              }
            },
            elevation: 2.0,
            child: Icon(
              Icons.camera_alt_outlined,
              color: colorScheme.background,
            ),
            shape: const CircleBorder(),
          ),
        ),
      ],
    );
  }
}
