import 'dart:typed_data';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/domain/database_service.dart';
import 'package:instagram_clone/utils/image_picker.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _captionController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _postImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text('Add Post'),
          leading: IconButton(
            icon: const Icon(Icons.clear_rounded),
            onPressed: (() {
              setState(() {
                _postImage = null;
                _captionController.clear();
              });
            }),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                await DatabaseService()
                    .storePost(_postImage, _captionController.text);
                setState(() {
                  _postImage = null;
                  _captionController.clear();
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
          ]),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: InkWell(
              onTap: () async {
                _postImage = await pickImage(ImageSource.gallery);
                setState(() {});
              },
              child: Neumorphic(
                  style: NeumorphicStyle(
                      depth: 8,
                      color: Colors.white,
                      surfaceIntensity: 0,
                      shadowLightColor: Colors.white,
                      shape: NeumorphicShape.concave,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(12))),
                  child: _postImage != null
                      ? Image.memory(_postImage!)
                      : const SizedBox(
                          width: double.infinity,
                          height: 300,
                          child: Icon(
                            Icons.edit_rounded,
                            color: Colors.blue,
                          ),
                        )),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Neumorphic(
                style: NeumorphicStyle(
                  shape: NeumorphicShape.convex,
                  depth: 0,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(8.0)),
                ),
                child: TextFormField(
                    maxLines: 4,
                    controller: _captionController,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Add Caption',
                        contentPadding: EdgeInsets.all(10))),
              ))
        ],
      ))),
    );
  }
}
