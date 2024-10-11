import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class PDFApi{
  static Future<File> loadNetwork(String url) async{
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    return _storeFile(url, bytes);
  }

  static Future<File> _storeFile(String url, List<int> bytes) async{
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}


class LoadPdf extends StatefulWidget {
  const LoadPdf({Key? key}) : super(key: key);

  @override
  State<LoadPdf> createState() => _LoadPdfState();
}

class _LoadPdfState extends State<LoadPdf> {
  
  void openPDF(context, File file) => Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => PDFViewer(file: file)),
  );
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () async{

              },
              icon: Icon(Icons.add, size: 18),
              label: Text("Asset PDF"),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Respond to button press
              },
              icon: Icon(Icons.add, size: 18),
              label: Text("File PDF"),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                final url = 'http://noiselab.ucsd.edu/ECE228_2019/Reports/Report38.pdf';
                final file = await PDFApi.loadNetwork(url);
                openPDF(context, file);

              },
              icon: Icon(Icons.add, size: 18),
              label: Text("Network PDF"),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Respond to button press
              },
              icon: Icon(Icons.add, size: 18),
              label: Text("Firebase PDF"),
            ),
          ],
        ),
      ),
    );
  }
}

class PDFViewer extends StatefulWidget {
  final File file;
  const PDFViewer({Key? key, required this.file}) : super(key: key);

  @override
  State<PDFViewer> createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  @override
  Widget build(BuildContext context) {
    final name = basename(widget.file.path);
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: PDFView(

      ),
    );
  }
}

