import 'package:flutter/material.dart';
import 'package:wwf_apps/colors/app_colors.dart';

class ImageViewer extends StatefulWidget {
  String URL="";

  ImageViewer(this.URL);

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.black,
      body: Container(
        child: Column(
          children: [
            Container(
              height: 70,
              width: double.infinity,
              color: AppTheme.colors.black,

              child: Container(
                margin: EdgeInsets.only(top: 23),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Icon(Icons.arrow_back, color: AppTheme.colors.newWhite, size: 20,),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text("View",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppTheme.colors.newWhite,
                            fontSize: 14,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: widget.URL != "null" && widget.URL != "" ? FadeInImage(
                    image: NetworkImage(widget.URL),
                    placeholder: AssetImage("archive/images/no_image.jpg"),
                  ) : Image.asset("archive/images/no_image.jpg",
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
