
import 'package:mec/Configs/Enum.dart';
import 'package:mec/Configs/app_constants.dart';
import 'package:mec/Screens/calling_screen/pickup_layout.dart';
import 'package:mec/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PDFViewerCachedFromUrl extends StatelessWidget {
  const PDFViewerCachedFromUrl(
      {Key? key,
      required this.url,
      required this.title,
      required this.prefs,
      required this.isregistered})
      : super(key: key);
  final SharedPreferences prefs;
  final String? url;
  final String title;
  final bool isregistered;

  @override
  Widget build(BuildContext context) {
    return isregistered == false
        ? Scaffold(
            appBar: AppBar(
              elevation: DESIGN_TYPE == Themetype.messenger ? 0.4 : 1,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.keyboard_arrow_left,
                  size: 30,
                  color: DESIGN_TYPE == Themetype.whatsapp
                      ? mecWhite
                      : mecBlack,
                ),
              ),
              title: Text(
                title,
                style: TextStyle(
                    color: DESIGN_TYPE == Themetype.whatsapp
                        ? mecWhite
                        : mecBlack,
                    fontSize: 18),
              ),
              backgroundColor: DESIGN_TYPE == Themetype.whatsapp
                  ? mecDeepGreen
                  : mecWhite,
            ),
            body: const PDF().cachedFromUrl(
              url!,
              placeholder: (double progress) =>
                  Center(child: Text('$progress %')),
              errorWidget: (dynamic error) =>
                  Center(child: Text(error.toString())),
            ),
          )
        : PickupLayout(
            prefs: prefs,
            scaffold: mec.getNTPWrappedWidget(Scaffold(
              appBar: AppBar(
                elevation: DESIGN_TYPE == Themetype.messenger ? 0.4 : 1,
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.keyboard_arrow_left,
                    size: 30,
                    color: DESIGN_TYPE == Themetype.whatsapp
                        ? mecWhite
                        : mecBlack,
                  ),
                ),
                title: Text(
                  title,
                  style: TextStyle(
                      color: DESIGN_TYPE == Themetype.whatsapp
                          ? mecWhite
                          : mecBlack,
                      fontSize: 18),
                ),
                backgroundColor: DESIGN_TYPE == Themetype.whatsapp
                    ? mecDeepGreen
                    : mecWhite,
              ),
              body: const PDF().cachedFromUrl(
                url!,
                placeholder: (double progress) =>
                    Center(child: Text('$progress %')),
                errorWidget: (dynamic error) =>
                    Center(child: Text(error.toString())),
              ),
            )));
  }
}
