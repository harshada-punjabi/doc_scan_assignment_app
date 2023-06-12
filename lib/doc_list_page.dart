import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class DocumentListScreen extends StatefulWidget {
  final List<String> imageList;

  const DocumentListScreen({super.key, required this.imageList});

  @override
  State<DocumentListScreen> createState() => _DocumentListScreenState();
}

class _DocumentListScreenState extends State<DocumentListScreen> {
  String pdfFile = '';

  var pdf = pw.Document();

  List<Uint8List> imagesUInt8list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200.withOpacity(0.8),
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade200,
        title: const Text('Documents'),
        actions: [
          TextButton(
            onPressed: () async {
              await createPdfFile();
              savePdfFile();
            },
            child: const Text('Get PDF'),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.imageList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: SizedBox(
                        width: 400,
                        height: 400,
                        child: Image.file(
                          File(widget.imageList[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                );
              },
              tileColor: index % 2 == 0
                  ? Colors.indigo.shade400.withOpacity(0.5)
                  : Colors.indigo.shade200.withOpacity(0.5),
              title: index % 2 == 0
                  ? Text(
                      'This is Good image',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.black12.withOpacity(0.6),
                      ),
                    )
                  : Text(
                      'This is Better image',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.black12.withOpacity(0.6),
                      ),
                    ),
              leading: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ClipOval(
                  child: Image.file(
                    File(widget.imageList[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> getImageBytes(File image) async {
    final bytes = await image.readAsBytes();
    final byteList = Uint8List.fromList(bytes);
    imagesUInt8list.add(byteList);
  }

  Future<void> createPdfFile() async {
    for (String image in widget.imageList) {
      await getImageBytes(File(image));
    }

    final List<pw.Widget> pdfImages = imagesUInt8list.map((image) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          mainAxisSize: pw.MainAxisSize.max,
          children: [
            pw.Text(
              'Image ${imagesUInt8list.indexWhere((element) => element == image) + 1}',
              style: const pw.TextStyle(fontSize: 22),
            ),
            pw.SizedBox(height: 10),
            pw.Image(
              pw.MemoryImage(image),
              height: 400,
              fit: pw.BoxFit.fitHeight,
            ),
          ],
        ),
      );
    }).toList();

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(10),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              mainAxisSize: pw.MainAxisSize.min,
              children: [
                pw.Text(
                  'PDF',
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(fontSize: 26),
                ),
                pw.Divider(),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              mainAxisSize: pw.MainAxisSize.max,
              children: pdfImages,
            ),
          ];
        },
      ),
    );
  }

  Future<void> savePdfFile() async {
    final documentDirectory = await getApplicationDocumentsDirectory();
    final documentPath = documentDirectory.path;
    final id = DateTime.now().toString();
    final file = File("$documentPath/$id.pdf");
    file.writeAsBytesSync(await pdf.save());
    setState(() {
      pdfFile = file.path;
      pdf = pw.Document();
    });

    Fluttertoast.showToast(
        msg: 'pdf file downloaded', gravity: ToastGravity.BOTTOM);
  }
}
