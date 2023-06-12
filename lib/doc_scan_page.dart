import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:doc_scan_assignment_app/doc_list_page.dart';
import 'package:flutter/material.dart';

class DocumentScanScreen extends StatefulWidget {
  const DocumentScanScreen({Key? key}) : super(key: key);

  @override
  State<DocumentScanScreen> createState() => _DocumentScanScreenState();
}

class _DocumentScanScreenState extends State<DocumentScanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade200.withOpacity(0.6),
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade200,
        title: const Text('Document Scanner'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
              height: 600,
              child: Image.asset(
                'assets/images/background.jpg',
                fit: BoxFit.cover,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo.shade200,
                fixedSize: const Size(200, 50),
              ),
              onPressed: () {
                onPressed(context);
              },
              child: const Text(
                "Scan Document",
                style: TextStyle(fontSize: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onPressed(BuildContext context) async {
    List<String> pictures;

    try {
      pictures = await CunningDocumentScanner.getPictures() ?? [];
      if (mounted) {
        setState(() {});
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DocumentListScreen(imageList: pictures),
          ),
        );
      }
    } catch (exception) {
      // Handle exception here
    }
  }
}
