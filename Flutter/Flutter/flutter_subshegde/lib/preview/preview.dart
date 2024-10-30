import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:photo_view/photo_view.dart';


class FullScreenImage extends StatelessWidget {
  final File? file;
  final String fileName;

  const FullScreenImage({Key? key, required this.file,required this.fileName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (file == null) {
      return _buildErrorView();
    }

    final fileExtension = file!.path.split('.').last.toLowerCase();

    if (fileExtension == 'jpg' || fileExtension == 'jpeg' || fileExtension == 'png' || fileExtension == 'gif') {
      return _buildImageView();
    } else if (fileExtension == 'pdf') {
      return _buildPdfView();
    } else {
      return _buildUnsupportedView();
    }
  }

  Widget _buildImageView() {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
        title:  Text('${fileName}',style: const TextStyle(color: Colors.black,fontSize: 13,fontWeight: FontWeight.w700),),
        centerTitle: true,
        ) ,
        backgroundColor: Colors.white,
        body:  PhotoView(
            imageProvider: FileImage(file!),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          
        ),
      ),
    );
  }

  Widget _buildPdfView() {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
        title:  Text('${fileName}',style: const TextStyle(color: Colors.black,fontSize: 13,fontWeight: FontWeight.w700),),
        centerTitle: true,
        ) ,
        backgroundColor: Colors.white,
        body: PDFView(
          filePath: file!.path,
        ),
      ),
    );
  }

  Widget _buildUnsupportedView() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:  const Text('Unsupported File Type',style: TextStyle(color: Colors.black,fontSize: 13,fontWeight: FontWeight.w700),),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'The selected file type is not supported for viewing.',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Error',style: TextStyle(color: Colors.black,fontSize: 13,fontWeight: FontWeight.w700),),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'No file selected or an error occurred.',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
