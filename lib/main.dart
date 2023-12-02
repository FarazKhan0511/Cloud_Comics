import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_comics/HomePage.dart';
import 'package:cloud_comics/LoadingPage.dart';
import 'package:cloud_comics/LoginPage.dart';
import 'package:cloud_comics/pdfviewer_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:path/path.dart';

//https://i.etsystatic.com/7434544/r/il/50f372/1637920754/il_570xN.1637920754_4zhg.jpg

import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp();

  runApp(MyApp());
}
/*Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp();
  try {
    final url = 'files/Aashiq Parinda_220422_040117.pdf';
    final file = await loadFirebase(url);
    final document = await PdfDocument.openData(file);
    final page = await document.getPage(1);
    final pageImage = await page.render(width: page.width, height: page.height);
    await page.close();
    runApp(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Image(
                image: MemoryImage(pageImage!.bytes),
              ),
            ),
          ),
          color: Colors.white,
        )
    );
  } on PlatformException catch (error) {
    print("error");
    print(error);
  }
  //runApp(MyApp());
}*/

loadFirebase(String url) async {
  try {
    final refPDF = FirebaseStorage.instance.ref().child(url);
    final bytes = await refPDF.getData();

    //return _storeFile(url, bytes!);
    return bytes;
  } catch (e) {
    print(e);
    return null;
  }
}

_storeFile(String url, Uint8List bytes) async {
  final filename = basename(url);
  final dir = await getApplicationDocumentsDirectory();

  final file = File('${dir.path}/$filename');
  await file.writeAsBytes(bytes, flush: true);
  return file;
}


class MyApp extends StatelessWidget {
  static final String title = 'Firebase Upload';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    theme: ThemeData(primarySwatch: Colors.blueGrey),
    //home: LoginPage(),
    initialRoute: '/',
    routes: {
      // When navigating to the "/" route, build the FirstScreen widget.
      '/': (context) => LoadingPage(),
      // When navigating to the "/second" route, build the SecondScreen widget.
      '/Login': (context) => LoginPage(),
      '/Home':(context) => HomePage(),
    },
  );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  UploadTask? task,task2;
  File? file;
  File? coverFile;

  TextEditingController comicNameTextEditingController = TextEditingController();
  TextEditingController comicDescTextEditingController = TextEditingController();

  FilePickerResult? result;
  FilePickerResult? coverImage;

  @override
  Widget build(BuildContext context) {

    final fileName = file != null ? basename(file!.path) : 'Comic Name';
    final fileDesc = file != null ? basename(file!.path) : 'Comic Desc';
    final coverFileUrl = coverFile != null ? basename(coverFile!.path) : 'Comic Desc';

    //comicNameTextEditingController.text = fileName;
    //comicDescTextEditingController.text = fileDesc;

    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(32),
        child: Center(
          child:SingleChildScrollView(
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: size.height*0.5,
                  child: Stack(
                    children: <Widget>[
                      Card(
                        color: Colors.black,
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child:ShaderMask(
                          shaderCallback: (rect) {
                            return LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.white, Colors.transparent],
                            ).createShader(Rect.fromLTRB(0, 0, rect.width, 450.0));
                          },
                          blendMode: BlendMode.dstIn,
                          child:
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(coverFile??File("assets/images/Simple_Comic.png")),
                                fit: BoxFit.fitWidth,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        margin: EdgeInsets.all(10),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0,left: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextField(
                              style:TextStyle(
                                fontSize:size.width*0.06,
                                fontWeight: FontWeight.bold,
                                fontFamily: "NunitoR",
                                color: Colors.white,
                              ),
                              controller: comicNameTextEditingController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintStyle:TextStyle(
                                  fontSize:size.width*0.06,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "NunitoR",
                                  color: Colors.white,
                                ),
                                hintText: "$fileName",
                                prefixIcon: Icon(Icons.edit,color: Colors.white,),
                              ),
                            ),
                            TextField(
                              style:TextStyle(
                                fontSize:size.width*0.03,
                                fontFamily: "NunitoR",
                                color: Colors.white,
                              ),
                              controller: comicDescTextEditingController,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                  fontSize:size.width*0.03,
                                  fontFamily: "NunitoR",
                                  color: Colors.white,
                                ),
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.edit,color: Colors.white,),
                                hintText: "$fileDesc",
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              coverImage = await FilePicker.platform.pickFiles(type: FileType.custom,allowMultiple: false,
                                allowedExtensions: ['jpg','png','jpeg'],);
                              if (coverImage == null) return;
                              final path = coverImage?.files.single.path!;

                              setState(() => coverFile = File(path!));
                            },
                            child: Icon( //<-- SEE HERE
                              coverFile==null?Icons.add:Icons.edit,
                              color: Colors.white,
                              size: size.width*0.07,
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(), //<-- SEE HERE
                              padding: EdgeInsets.all(20),
                            ),
                          ),
                          SizedBox(height: 8,),
                          Text(coverFile==null?"Add Cover Image":"Replace Cover Image",style:TextStyle(
                            fontSize:size.width*0.035,
                            fontFamily: "NunitoR",
                            color: Colors.white,
                          ),)
                        ],
                      ))
                    ],
                  ),
                ),
                /*ButtonWidget(
                text: 'Firebase PDF',
                onClicked: () async {
                  final url = 'files/Aashiq Parinda_220422_040117.pdf';
                  final BYTE = await loadFirebase(url);
                  final document = await PdfDocument.openData(BYTE!);
                  if (BYTE == null){
                    print("Null");
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PDFViewerPage(pdfDocument: document, FileName: '',)),
                  );
                }, icon: Icons.download,
              ),*/
                ButtonWidget(
                  text: 'Select Comic PDF',
                  icon: Icons.attach_file,
                  onClicked: selectFile,
                ),
                SizedBox(height: 18),
                ButtonWidget(
                  text: 'Upload Comic',
                  icon: Icons.cloud_upload_outlined,
                  onClicked: uploadFile,
                ),
                SizedBox(height: 20),
                task != null ? buildUploadStatus(task!) : Container(),
              ],
            ),
          )
        ),
      ),
    );
  }

  Future<Widget> myPAGE() async {
    final document = await PdfDocument.openAsset('assets/sample.pdf');
    final page = await document.getPage(1);
    final pageImage = await page.render(width: page.width, height: page.height);
    await page.close();
    return Center(
      child: Image(
        image: MemoryImage(pageImage!.bytes),
      ),
    );
  }

  static Future<File> _storeFile(String url, List<int> bytes) async {
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  static Future<Uint8List?> loadFirebase(String url) async {
    try {
      final refPDF = FirebaseStorage.instance.ref().child(url);
      final bytes = await refPDF.getData();

      return bytes;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future selectFile() async {
    result = await FilePicker.platform.pickFiles(type: FileType.custom,allowMultiple: false,
      allowedExtensions: ['pdf'],);

    if (result == null) return;
    final path = result?.files.single.path!;

    setState(() => file = File(path!));
  }

  Future uploadFile() async {
    if (file == null) return;

    //final fileName = basename(file!.path);
    final fileName = comicNameTextEditingController.text;
    final destinationForPDF = 'files/$fileName/comicPDF';
    final destinationForImage = 'files/$fileName/coverImage';

    task = FirebaseApi.uploadFile(destinationForPDF, file!);
    task2 = FirebaseApi.uploadFile(destinationForImage, coverFile!);
    setState(() {});

    if (task == null) return;
    if (task2 == null) return;

    final snapshot = await task!.whenComplete(() {});
    final snapshot2 = await task2!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    final urlDownload2 = await snapshot2.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
    print('Download-Link: $urlDownload2');

    print("Now Let's Have a Name");

    final CollectionReference postsRef = FirebaseFirestore.instance.collection('/comicBooks');

    await postsRef.doc().set({"comicName":comicNameTextEditingController.text,"comicDesc":comicDescTextEditingController.text,"coverURL":urlDownload2,"comicPDFURL":urlDownload});

    print("files/$fileName" + "Files Added Successfully");

  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
    stream: task.snapshotEvents,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final snap = snapshot.data!;
        final progress = snap.bytesTransferred / snap.totalBytes;
        final percentage = (progress * 100).toStringAsFixed(2);

        return Text(
          '$percentage %',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        );
      } else {
        return Container();
      }
    },
  );


}




class ButtonWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.icon,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
    style: ElevatedButton.styleFrom(
      primary: Colors.blueGrey,
      minimumSize: Size.fromHeight(50),
    ),
    child: buildContent(),
    onPressed: onClicked,
  );

  Widget buildContent() => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 28),
      SizedBox(width: 16),
      Text(
        text,
        style: TextStyle(fontSize: 22, color: Colors.white),
      ),
    ],
  );
}

class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  static UploadTask? uploadBytes(String destination, Uint8List data) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putData(data);
    } on FirebaseException catch (e) {
      return null;
    }
  }
}


