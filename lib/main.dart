
import 'dart:io';
import 'dart:developer';
import 'dart:js_interop';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'dart:convert';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:html' as html; //ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'package:flutter/material.dart';
import 'package:widgets_to_image/widgets_to_image.dart';



// 1. 특정영역을 SNS공유로 공유

List<String>? items;
List<String>? items2;
List<FlSpot> flitems = <FlSpot>[];
List<FlSpot> flitems2 = <FlSpot>[];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

    // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LoveBeat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String result = "";
  var etime = 0.0;
  Uint8List? _imageFile;
  Uint8List? _imageFile1;
  late XFile xfi;
  var _imageBool = false;
  var _imageBool1 = false;

  WidgetsToImageController controller = WidgetsToImageController();
  ScreenshotController screenshotController = ScreenshotController();

  void saveImg(Uint8List? bytes, String fileName) =>
      js.context.callMethod("saveAs", [
        html.Blob([bytes]),
        fileName
      ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            const Text(
              '29th',
            ),
            Screenshot(
              controller: screenshotController,
              child: flitems.isNotEmpty || flitems2.isNotEmpty ? LineChartSample6() : const Text('CHARTY\nCHARTY!'),
            ),
            WidgetsToImage(
              controller: controller,
              child: const Text('WIDGET\nTOIMAGE!'),
            ),
            Text(
              '',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            flitems.isEmpty ?
            ElevatedButton(
              onPressed: () async {
                var res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SimpleBarcodeScannerPage(),
                    ));
                setState(() {
                  result = res;
                    items = result.trim().split(",");
                    var time = DateTime.fromMillisecondsSinceEpoch(int.parse(items![0]));
                    etime = double.parse("${time.hour}${time.minute}${time.second}");
                    items?.removeAt(0);
                    var plus15 = 0.0;
                    flitems?.clear();
                    items?.forEach((e) {
                      flitems?.add(FlSpot(etime+plus15,double.parse(e)));
                      plus15 = plus15 + 10.0;
                    });

                });
              },
              child: const Text('Scan QRCODE #1'),
            )
            :
            flitems2.isEmpty ? ElevatedButton(
              onPressed: () async {
                var res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SimpleBarcodeScannerPage(),
                    ));
                setState(() {
                  result = res;
                  items2 = result.trim().split(",");
                  var time = DateTime.fromMillisecondsSinceEpoch(int.parse(items2![0]));
                  etime = double.parse("${time.hour}${time.minute}${time.second}");
                  items2?.removeAt(0);
                  var plus15 = 0.0;
                  flitems2?.clear();
                  items2?.forEach((e) {
                    flitems2?.add(FlSpot(etime+plus15,double.parse(e)));
                    plus15 = plus15 + 10.0;
                  });

                });
                await screenshotController.capture(delay: const Duration(milliseconds: 10)).then((Uint8List? image) async {
                  if (image != null) {
                    _imageFile = image;
                  }

                });
              },
              child: const Text('Scan QRCODE #2'),
            )
                :
            ElevatedButton(
              onPressed: () {
                setState(() {
                  result = "";
                  etime = 0.0;
                  items?.clear();
                  items2?.clear();
                  flitems.clear();
                  flitems2.clear();
                                                    });
              },
              child: const Text('RENEW'),
            )
            ,
            Text(
              '',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              onPressed: ()  {
                    // final directory = await getApplicationDocumentsDirectory();
                    // xfi = XFile('/assets/lf1.PNG');
                screenshotController.capture(delay: const Duration(milliseconds: 10)).then((Uint8List? image) async {
                  if (image != null) {
                    setState(() {
                      _imageFile = image;
                      _imageBool = true;
                    });

                    // final directory = await getApplicationDocumentsDirectory();
                    // final imagePath = await File('${directory.path}/images.PNG').create();

                    // await imagePath.writeAsBytes(image);
                    // xfi = XFile(imagePath.path);
                  }

                });

                  },
              child: const Icon(Icons.share),
            ),
            InkWell(
              child: ElevatedButton(
                onPressed: () {
                  saveImg(_imageFile, "downloadImg.png");
                },
                child: const Icon(Icons.done),
              )
            ),
            !_imageBool ?
            Center(
              child: const Text(""),
            ) : Center(
              child: Image.memory(_imageFile!),
            ),
            !_imageBool1 ?
            Center(
              child: const Text(""),
            ) : Center(
              child: Image.memory(_imageFile1!),
            )
          ],

        ),
      ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// ignore: must_be_immutable
class LineChartSample6 extends StatelessWidget {

  LineChartSample6({
    super.key,
    Color? line1Color1,
    Color? line1Color2,
    Color? line2Color1,
    Color? line2Color2,
  })  : line1Color1 = line1Color1 ?? Colors.orange,
        line1Color2 = line1Color2 ?? Colors.deepOrangeAccent,
        line2Color1 = line2Color1 ?? Colors.blueAccent,
        line2Color2 = line2Color2 ?? Colors.blue {
    minSpotX = spots.first.x;
    maxSpotX = spots.first.x;
    minSpotY = spots.first.y;
    maxSpotY = spots.first.y;

    for (final spot in spots) {
      if (spot.x > maxSpotX) {
        maxSpotX = spot.x;
      }

      if (spot.x < minSpotX) {
        minSpotX = spot.x;
      }

      if (spot.y > maxSpotY) {
        maxSpotY = spot.y;
      }

      if (spot.y < minSpotY) {
        minSpotY = spot.y;
      }
    }
  }

  final Color line1Color1;
  final Color line1Color2;
  final Color line2Color1;
  final Color line2Color2;


 final spots = flitems;

  final spots2 = flitems2;

  late double minSpotX;
  late double maxSpotX;
  late double minSpotY;
  late double maxSpotY;

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyle(
      color: line1Color1,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );

    final intValue = reverseY(value, minSpotY, maxSpotY).toInt();

    if (intValue == (maxSpotY + minSpotY)) {
      return Text('', style: style);
    }

    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Text(
        intValue.toString(),
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget rightTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyle(
      color: line2Color2,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );
    final intValue = reverseY(value, minSpotY, maxSpotY).toInt();

    if (intValue == (maxSpotY + minSpotY)) {
      return Text('', style: style);
    }

    return Text(intValue.toString(), style: style, textAlign: TextAlign.right);
  }

  Widget topTitleWidgets(double value, TitleMeta meta) {
    if (value % 1 != 0) {
      return Container();
    }
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.blueGrey,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(value.toInt().toString(), style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 22, bottom: 20),
      child: AspectRatio(
        aspectRatio: 2,
        child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(enabled: false),
            lineBarsData: [
              LineChartBarData(
                gradient: LinearGradient(
                  colors: [
                    line1Color1,
                    line1Color2,
                  ],
                ),
                spots: reverseSpots(spots, minSpotY, maxSpotY),
                isCurved: true,
                isStrokeCapRound: true,
                barWidth: 8,
                belowBarData: BarAreaData(
                  show: false,
                ),
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) =>
                      FlDotCirclePainter(
                        radius: 4,
                        color: Colors.transparent,
                        strokeColor: Colors.blueGrey,
                      ),
                ),
              ),
              LineChartBarData(
                gradient: LinearGradient(
                  colors: [
                    line2Color1,
                    line2Color2,
                  ],
                ),
                spots: reverseSpots(spots2, minSpotY, maxSpotY),
                isCurved: true,
                isStrokeCapRound: true,
                barWidth: 8,
                belowBarData: BarAreaData(
                  show: false,
                ),
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) =>
                      FlDotCirclePainter(
                        radius: 4,
                        color: Colors.transparent,
                        strokeColor: Colors.blueGrey,
                      ),
                ),
              ),
            ],
            minY: 0,
            maxY: maxSpotY + minSpotY,
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: leftTitleWidgets,
                  reservedSize: 38,
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: rightTitleWidgets,
                  reservedSize: 38,
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 24,
                  getTitlesWidget: topTitleWidgets,
                ),
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              checkToShowHorizontalLine: (value) {
                final intValue = reverseY(value, minSpotY, maxSpotY).toInt();

                if (intValue == (maxSpotY + minSpotY).toInt()) {
                  return false;
                }

                return true;
              },
            ),
            borderData: FlBorderData(
              show: true,
              border: const Border(
                left: BorderSide(color: Colors.white24),
                top: BorderSide(color: Colors.white24),
                bottom: BorderSide(color: Colors.transparent),
                right: BorderSide(color: Colors.transparent),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double reverseY(double y, double minX, double maxX) {
    // return (maxX + minX) - y;
    return y;
  }

  List<FlSpot> reverseSpots(List<FlSpot> inputSpots, double minY, double maxY) {
    // return inputSpots.map((spot) {
    //   return spot.copyWith(y: (maxY + minY) - spot.y);
    // }).toList();
    return inputSpots;
  }
}