import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ImagePick extends StatefulWidget {
  const ImagePick({Key? key}) : super(key: key);

  @override
  State<ImagePick> createState() => _ImagePickState();
}

class _ImagePickState extends State<ImagePick> {
  File? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Gambar',
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(
            height: 5,
          ),
          GestureDetector(
            onTap: () async {
              try {
                final image =
                await ImagePicker().pickImage(source: ImageSource.gallery);
                // print(image?.readAsBytes());
                if (image == null) return;

                final imageTemporary = File(image.path);
                setState(() => this.image = imageTemporary);
                // print(image.path);

                // final bytes = File(image.path).readAsBytesSync();

                // String img64 = base64Encode(bytes);
                // print(img64);
              } on PlatformException catch (e) {
                ('$e');
              }
            },
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xff63B1F2),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: image != null
                  ? Container(
                margin: const EdgeInsets.only(top: 5, bottom: 5),
                child: Column(
                  children: [
                    Image.file(image!),
                    ElevatedButton(
                        onPressed: () {}, child: const Text('Ganti'))
                  ],
                ),
              )
                  : Icon(
                Icons.cloud_upload_outlined,
                size: 100,
                color: Colors.blue.shade300,
              ),
            ),
          )
        ],
      ),
    );
  }
}