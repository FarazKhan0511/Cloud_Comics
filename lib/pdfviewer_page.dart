import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:page_turn/page_turn.dart';
import 'package:path/path.dart';

class PDFViewerPage extends StatefulWidget {
  final PdfDocument pdfDocument;
  final String FileName;

  const PDFViewerPage({
    Key? key,
    required this.pdfDocument, required this.FileName,
  }) : super(key: key);

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  final _controller = GlobalKey<PageTurnState>();

  late Future<List<Uint8List>> myFuture;

  Future<List<Uint8List>> getAllPagesFromDocument() async {
    List<Uint8List> allPages = [];
    print("widget.pdfDocument.pagesCount");
    print(widget.pdfDocument.pagesCount);
    for(int i=1;i<=widget.pdfDocument.pagesCount;i++){
      print("On Page $i");
      PdfPage page = await widget.pdfDocument.getPage(1);
      print("On Page $i");
      PdfPageImage? pageImage = await page.render(width: page.width, height: page.height);
      print("On Page $i");
      print(pageImage!.bytes);
      print("On Page $i");
      await page.close();
      allPages.add(pageImage.bytes);

    }
    print("Completed Rendering all pages");
    return allPages;
  }


  bool showAppBar = true;

  @override
  void initState() {
    myFuture = getAllPagesFromDocument();
    setState(() {
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: myFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Uint8List>> snapshot){
          if(snapshot.hasData)
            return Scaffold(
              appBar: showAppBar?AppBar(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                backgroundColor:Color(0xff9AC5D2) ,
                title: Text(widget.FileName,style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'NunitoR',
                ),),
                centerTitle: true,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      showAppBar = false;
                      setState(() {

                      });
                      //_showSnackBar(context, "You pressed 2");
                      //showDialog(context: context,builder: (context) => _onTapInfo(context)); // Call the Dialog.
                    },
                  )
                ],
              ):null,
            body: SafeArea(
              child: PageTurn(
                key: _controller,
                backgroundColor: Colors.white,
                showDragCutoff: false,
                lastPage: Container(
                  color: Colors.black,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("The End!",style:TextStyle(
                        fontFamily: "NunitoR",
                        color:Colors.white,
                        fontSize:50.0,
                      )),
                    ],
                  ),
                ),
                children: <Widget>[
                  for (int i = 0; i < widget.pdfDocument.pagesCount; i++) Image(image: MemoryImage(snapshot.data![1]),),
                ],
              ),
            )
          );
          return Scaffold(body: Center(child: Container(child: CircularProgressIndicator(color: Colors.green,),)));
        }
    );
  }

}