import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<void> createPdf()async{

   PdfDocument document = PdfDocument();
   final page = document.pages.add();

  
   page.graphics.drawString('PRODUCTOS', PdfStandardFont( PdfFontFamily.helvetica, 20));
   page.graphics.drawString('Bunemann\'s Spelunke', PdfStandardFont( PdfFontFamily.helvetica, 10));


   List<int> bytes = document.saveSync();
   document.dispose();

   saveAndLaunchFile(bytes, 'output.pdf');
}
Future<void> saveAndLaunchFile(List<int> bytes, String fileName)async{

  final path =(await getExternalStorageDirectory())!.path;
  final file = File('$path/$fileName');
  await file.writeAsBytes(bytes,flush: true);
  OpenFile.open('$path/$fileName');
}

