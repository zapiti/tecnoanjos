
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tecnoanjosclient/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/avaliation/models/avaliation.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

class DetailAvaliationPage extends StatelessWidget {
  final Avaliation evaluation;

  DetailAvaliationPage(this.evaluation);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(StringFile.detalheAvaliacao),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[200],
                        child: Image.network(this.evaluation.isReceiver
                            ? (evaluation.imageUrlReceiver ?? "")
                            : (evaluation.imageUrlSender ?? ""),
                          fit: BoxFit.fill,

                          width: 100,
                          height: 100,
                          // placeholder: (context, url) =>
                          //     new CircularProgressIndicator(),
                          // errorWidget: (context, url, error) =>
                          //     new Icon(Icons.error_outline),
                        )))),
            evaluation.rating == null
                ? SizedBox()
                : RatingBar(
                    initialRating: evaluation.rating ?? 0.0,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    ignoreGestures: true,
                    itemSize: 28,
                    itemCount: 5,
                    itemPadding:
                        EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    ratingWidget: RatingWidget(
                        full: Icon(
                          Icons.star,
                          color: AppThemeUtils.colorPrimary,
                        ),
                        half: Icon(
                          Icons.star,
                          color: AppThemeUtils.colorPrimary,
                        ),
                        empty: Icon(
                          Icons.star_border,
                          color: AppThemeUtils.colorPrimary,
                        )),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
            lineViewWidget(),
            Container(
                margin: EdgeInsets.all(10),
                child: Text(
                  this.evaluation.isReceiver
                      ? (evaluation.userNameReceiver ?? "")
                      : evaluation.userNameSander ?? "",
                  style: AppThemeUtils.normalBoldSize(
                      fontSize: 20, color: AppThemeUtils.colorPrimary),
                )),
            lineViewWidget(),
            Container(
                margin: EdgeInsets.all(15),
                child: Text(
                  (evaluation?.description ?? "").isEmpty
                      ? StringFile.semDepoimento
                      : (evaluation?.description ?? ""),
                  textAlign: TextAlign.start,
                  style: AppThemeUtils.normalSize(fontSize: 14),
                )),
          ],
        ));
  }
}
