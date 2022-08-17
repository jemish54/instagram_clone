import 'dart:typed_data';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/domain/authentication.dart';
import 'package:instagram_clone/domain/storage_service.dart';
import 'package:instagram_clone/model/app_user.dart';
import 'package:instagram_clone/utils/image_picker.dart';
import 'package:instagram_clone/widgets/credential_field.dart';
import 'package:instagram_clone/widgets/progress_button.dart';

class EditProfileScreen extends StatefulWidget {
  final AppUser user;
  const EditProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Uint8List? profileImage;
  Uint8List? coverImage;
  bool _isLoading = false;

  @override
  void initState() {
    profileImage;
    coverImage;
    _usernameController.text = widget.user.username;
    _bioController.text = widget.user.bio;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          Consumer(
            builder: (context, ref, child) => IconButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                await ref.read(authServiceProvider).editUserDetails(
                      _usernameController.text,
                      _bioController.text,
                      profileImage,
                      coverImage,
                    );
                setState(() {
                  _isLoading = false;
                });
              },
              icon: _isLoading
                  ? const SizedBox(
                      height: 28,
                      width: 28,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.done_rounded),
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                const SizedBox(
                  height: 200,
                  width: double.infinity,
                ),
                InkWell(
                  onTap: () async {
                    coverImage = await pickImage(ImageSource.gallery);
                    setState(() {});
                  },
                  child: Positioned(
                      child: coverImage != null
                          ? Image.memory(
                              coverImage!,
                              fit: BoxFit.cover,
                              height: 160,
                              width: double.infinity,
                            )
                          : Image.network(
                              widget.user.coverImageUrl ??
                                  'https://images.unsplash.com/photo-1519638399535-1b036603ac77?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8YW5pbWV8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60',
                              fit: BoxFit.cover,
                              height: 160,
                              width: double.infinity,
                            )),
                ),
                Positioned(
                    bottom: 0,
                    child: NeumorphicButton(
                      onPressed: () async {
                        profileImage = await pickImage(ImageSource.gallery);
                        setState(() {});
                      },
                      padding: const EdgeInsets.all(0),
                      style: const NeumorphicStyle(
                        color: Colors.white,
                        depth: 8,
                        lightSource: LightSource.top,
                        border: NeumorphicBorder(color: Colors.white, width: 2),
                        boxShape: NeumorphicBoxShape.circle(),
                        shape: NeumorphicShape.convex,
                      ),
                      child: profileImage != null
                          ? Image.memory(
                              profileImage!,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              widget.user.profileImageUrl ??
                                  'https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 20),
                  CredentialField(
                      textController: _usernameController,
                      hint: "Username",
                      iconData: Icons.person_rounded,
                      inputType: TextInputType.name),
                  const SizedBox(height: 16),
                  Neumorphic(
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.convex,
                      depth: 0,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(8.0)),
                    ),
                    child: TextFormField(
                        maxLines: 4,
                        controller: _bioController,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Add Bio',
                            contentPadding: EdgeInsets.all(10))),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
