import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ProgressDialog {
  static OverlayEntry? currentLoader;
  static bool isShowing = false;

  static void show(BuildContext context) {
    if (!isShowing) {
      currentLoader = OverlayEntry(
        builder: (context) => WillPopScope(
          onWillPop: () async => false,
          child: GestureDetector(
            child: Container(
              color: Colors.black26,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: getCircularProgressIndicator(),
                      width: 60,
                      height: 60,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white,
                          border: Border.all(
                              width: 1, color: const Color(0xFF24224D))),
                    )
                  ],
                ),
              ),
            ),
            onTap: () {
              // do nothing
            },
            onDoubleTap: () {
              ProgressDialog.hide();
            },
          ),
        ),
      );
      Overlay.of(context)?.insert(currentLoader!);
      isShowing = true;
    }
  }

  static void hide() {
    if (currentLoader != null) {
      currentLoader?.remove();
      isShowing = false;
      currentLoader = null;
    }
  }

  static getCircularProgressIndicator({double? height, double? width}) {
    height ??= 40.0;
    width ??= 40.0;
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        child: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF24224D)),
        ),
        height: height,
        width: width,
      ),
    );
  }

  static getErrorWidget() {
    return Container(
      alignment: Alignment.center,
      child: const SizedBox(
        child: Text("Oops! Something went wrong."),
      ),
    );
  }
}
