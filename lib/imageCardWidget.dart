import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_apk_news/shared/imageCard.dart';
import 'imageSlidersWidget.dart';

// to show a card image
class ImageCard extends StatelessWidget {
  final ImageListCard imageListCard;

  ImageCard({Key key, @required this.imageListCard}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 8.0,
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(16.0),
        ),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new ClipRRect(
              child: new ImageSliders(),
              borderRadius: BorderRadius.only(
                  topLeft: new Radius.circular(16.0),
                  topRight: new Radius.circular(16.0)),
            ),
            new Padding(
              padding: new EdgeInsets.all(16.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    imageListCard.imageTitle.toUpperCase(),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  new SizedBox(
                    height: 16.0,
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text(imageListCard.datePublication),
                      new Text(imageListCard.timePublication),
                      new Text(imageListCard.viewImage)
                    ],
                  )
                ],
              ),
            )
          ],
        ));
  }
}
