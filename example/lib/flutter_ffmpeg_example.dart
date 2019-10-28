import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_ffmpeg/log_level.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(FlutterFFmpegTestApp());

class FlutterFFmpegTestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFFF46842),
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  FlutterFFmpegTestAppState createState() => new FlutterFFmpegTestAppState();
}

class DecoratedTabBar extends StatelessWidget implements PreferredSizeWidget {
  DecoratedTabBar({@required this.tabBar, @required this.decoration});

  final TabBar tabBar;
  final BoxDecoration decoration;

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Container(decoration: decoration)),
        tabBar,
      ],
    );
  }
}

class VideoUtil {
  static Future<Directory> get tempDirectory async {
    return await getTemporaryDirectory();
  }

  static Future<File> copyFileAssets(String assetName, String localName) async {
    final ByteData assetByteData = await rootBundle.load(assetName);

    final List<int> byteList = assetByteData.buffer
        .asUint8List(assetByteData.offsetInBytes, assetByteData.lengthInBytes);

    final String fullTemporaryPath =
        join((await tempDirectory).path, localName);

    return new File(fullTemporaryPath)
        .writeAsBytes(byteList, mode: FileMode.writeOnly, flush: true);
  }

  static Future<String> assetPath(String assetName) async {
    return join((await tempDirectory).path, assetName);
  }

  static String generateEncodeVideoScript(
      String image1Path,
      String image2Path,
      String image3Path,
      String videoFilePath,
      String videoCodec,
      String customOptions) {
    return "-hide_banner    -y -loop   1 -i '" +
        image1Path +
        "' " +
        "-loop   1 -i \"" +
        image2Path +
        "\" " +
        "-loop 1   -i \"" +
        image3Path +
        "\" " +
        "-filter_complex " +
        "\"[0:v]setpts=PTS-STARTPTS,scale=w='if(gte(iw/ih,640/427),min(iw,640),-1)':h='if(gte(iw/ih,640/427),-1,min(ih,427))',scale=trunc(iw/2)*2:trunc(ih/2)*2,setsar=sar=1/1,split=2[stream1out1][stream1out2];" +
        "[1:v]setpts=PTS-STARTPTS,scale=w='if(gte(iw/ih,640/427),min(iw,640),-1)':h='if(gte(iw/ih,640/427),-1,min(ih,427))',scale=trunc(iw/2)*2:trunc(ih/2)*2,setsar=sar=1/1,split=2[stream2out1][stream2out2];" +
        "[2:v]setpts=PTS-STARTPTS,scale=w='if(gte(iw/ih,640/427),min(iw,640),-1)':h='if(gte(iw/ih,640/427),-1,min(ih,427))',scale=trunc(iw/2)*2:trunc(ih/2)*2,setsar=sar=1/1,split=2[stream3out1][stream3out2];" +
        "[stream1out1]pad=width=640:height=427:x=(640-iw)/2:y=(427-ih)/2:color=#00000000,trim=duration=3,select=lte(n\\,90)[stream1overlaid];" +
        "[stream1out2]pad=width=640:height=427:x=(640-iw)/2:y=(427-ih)/2:color=#00000000,trim=duration=1,select=lte(n\\,30)[stream1ending];" +
        "[stream2out1]pad=width=640:height=427:x=(640-iw)/2:y=(427-ih)/2:color=#00000000,trim=duration=2,select=lte(n\\,60)[stream2overlaid];" +
        "[stream2out2]pad=width=640:height=427:x=(640-iw)/2:y=(427-ih)/2:color=#00000000,trim=duration=1,select=lte(n\\,30),split=2[stream2starting][stream2ending];" +
        "[stream3out1]pad=width=640:height=427:x=(640-iw)/2:y=(427-ih)/2:color=#00000000,trim=duration=2,select=lte(n\\,60)[stream3overlaid];" +
        "[stream3out2]pad=width=640:height=427:x=(640-iw)/2:y=(427-ih)/2:color=#00000000,trim=duration=1,select=lte(n\\,30)[stream3starting];" +
        "[stream2starting][stream1ending]blend=all_expr='if(gte(X,(W/2)*T/1)*lte(X,W-(W/2)*T/1),B,A)':shortest=1[stream2blended];" +
        "[stream3starting][stream2ending]blend=all_expr='if(gte(X,(W/2)*T/1)*lte(X,W-(W/2)*T/1),B,A)':shortest=1[stream3blended];" +
        "[stream1overlaid][stream2blended][stream2overlaid][stream3blended][stream3overlaid]concat=n=5:v=1:a=0,scale=w=640:h=424,format=yuv420p[video]\"" +
        " -map [video] -vsync 2 -async 1 " +
        customOptions +
        "-c:v " +
        videoCodec +
        " -r 30 " +
        videoFilePath;
  }
}

class FlutterFFmpegTestAppState extends State<MainPage>
    with TickerProviderStateMixin {
  static const String ASSET_1 = "1.jpg";
  static const String ASSET_2 = "2.jpg";
  static const String ASSET_3 = "3.jpg";

  final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();

  TextEditingController _commandController;
  TabController _controller;
  String _commandOutput;
  String _encodeOutput;
  String _currentCodec;
  List<DropdownMenuItem<String>> _codecDropDownMenuItems;

  @override
  void initState() {
    super.initState();

    _commandController = TextEditingController();
    _controller = TabController(length: 2, vsync: this);
    _commandOutput = "";
    _encodeOutput = "";

    _codecDropDownMenuItems = _getCodecDropDownMenuItems();
    _currentCodec = _codecDropDownMenuItems[0].value;

    startupTests();

    prepareAssets();
  }

  void startupTests() {
    getFFmpegVersion().then((version) => print("FFmpeg version: $version"));
    getPlatform().then((platform) => print("Platform: $platform"));
    getLogLevel().then(
        (level) => print("Old log level: " + LogLevel.levelToString(level)));
    setLogLevel(LogLevel.AV_LOG_INFO);
    getLogLevel().then(
        (level) => print("New log level: " + LogLevel.levelToString(level)));
    getPackageName().then((packageName) => print("Package name: $packageName"));
    getExternalLibraries().then((packageList) {
      packageList.forEach((value) => print("External library: $value"));
    });
  }

  void prepareAssets() {
    VideoUtil.copyFileAssets('assets/pyramid.jpg', ASSET_1)
        .then((path) => print('Loaded asset $path.'));
    VideoUtil.copyFileAssets('assets/colosseum.jpg', ASSET_2)
        .then((path) => print('Loaded asset $path.'));
    VideoUtil.copyFileAssets('assets/tajmahal.jpg', ASSET_3)
        .then((path) => print('Loaded asset $path.'));
  }

  void testParseArguments() {
    testParseSimpleCommand();
    testParseSingleQuotesInCommand();
    testParseDoubleQuotesInCommand();
    testParseDoubleQuotesAndEscapesInCommand();
  }

  void testRunCommand() {
    getLastReturnCode().then((rc) => print("Last rc: $rc"));
    getLastCommandOutput().then((output) => debugPrint("Last command output: \"$output\"", wrapWidth: 1024));

    print("Testing ParseArguments.");

    testParseArguments();
    registerNewFFmpegPipe().then((path) => print("New FFmpeg pipe: $path"));

    print("Testing COMMAND.");

    // ENABLE LOG CALLBACK ON EACH CALL
    _flutterFFmpeg.enableLogCallback(commandOutputLogCallback);
    _flutterFFmpeg.enableStatisticsCallback(statisticsCallback);

    // CLEAR OUTPUT ON EACH EXECUTION
    _commandOutput = "";

    // COMMENT OPTIONAL TESTS
    // VideoUtil.tempDirectory.then((tempDirectory) {
    //    Map<String, String> mapNameMap = new Map();
    //    mapNameMap["my_custom_font"] = "my custom font";
    //    setFontDirectory(tempDirectory.path, null);
    // });

    VideoUtil.tempDirectory.then((tempDirectory) {
      setFontconfigConfigurationPath(tempDirectory.path);
    });

    // disableRedirection();

    // disableLogs();
    // enableLogs();

    execute(_commandController.text)
        .then((rc) => print("FFmpeg process exited with rc $rc"));
    // executeWithArguments(_commandController.text.split(" ")).then((rc) => print("FFmpeg process exited with rc $rc"));

    setState(() {});
  }

  void testGetMediaInformation(String mediaPath) {
    print("Testing Get Media Information.");

    // ENABLE LOG CALLBACK ON EACH CALL
    _flutterFFmpeg.enableLogCallback(commandOutputLogCallback);
    _flutterFFmpeg.enableStatisticsCallback(null);

    // CLEAR OUTPUT ON EACH EXECUTION
    _commandOutput = "";

    VideoUtil.assetPath(mediaPath).then((image1Path) {
      getMediaInformation(image1Path).then((info) {
        print('Media Information');

        print('Path: ${info['path']}');
        print('Format: ${info['format']}');
        print('Duration: ${info['duration']}');
        print('Start time: ${info['startTime']}');
        print('Bitrate: ${info['bitrate']}');

        if (info['streams'] != null) {
          final streamsInfoArray = info['streams'];

          if (streamsInfoArray.length > 0) {
            for (var streamsInfo in streamsInfoArray) {
              print('Stream id: ${streamsInfo['index']}');
              print('Stream type: ${streamsInfo['type']}');
              print('Stream codec: ${streamsInfo['codec']}');
              print('Stream full codec: ${streamsInfo['fullCodec']}');
              print('Stream format: ${streamsInfo['format']}');
              print('Stream full format: ${streamsInfo['fullFormat']}');
              print('Stream width: ${streamsInfo['width']}');
              print('Stream height: ${streamsInfo['height']}');
              print('Stream bitrate: ${streamsInfo['bitrate']}');
              print('Stream sample rate: ${streamsInfo['sampleRate']}');
              print('Stream sample format: ${streamsInfo['sampleFormat']}');
              print('Stream channel layout: ${streamsInfo['channelLayout']}');
              print('Stream sar: ${streamsInfo['sampleAspectRatio']}');
              print('Stream dar: ${streamsInfo['displayAspectRatio']}');
              print(
                  'Stream average frame rate: ${streamsInfo['averageFrameRate']}');
              print('Stream real frame rate: ${streamsInfo['realFrameRate']}');
              print('Stream time base: ${streamsInfo['timeBase']}');
              print('Stream codec time base: ${streamsInfo['codecTimeBase']}');

              final metadataMap = streamsInfo['metadata'];
              if (metadataMap != null) {
                print('Stream metadata encoder: ${metadataMap['encoder']}');
                print('Stream metadata rotate: ${metadataMap['rotate']}');
                print(
                    'Stream metadata creation time: ${metadataMap['creation_time']}');
                print(
                    'Stream metadata handler name: ${metadataMap['handler_name']}');
              }

              final sideDataMap = streamsInfo['sidedata'];
              if (sideDataMap != null) {
                print(
                    'Stream side data displaymatrix: ${sideDataMap['displaymatrix']}');
              }
            }
          }
        }
      });
    });

    setState(() {});
  }

  void testEncodeVideo() {
    print("Testing VIDEO.");

    // ENABLE LOG CALLBACK ON EACH CALL
    _flutterFFmpeg.enableLogCallback(encodeOutputLogCallback);
    _flutterFFmpeg.enableStatisticsCallback(statisticsCallback);

    // CLEAR OUTPUT ON EACH EXECUTION
    _encodeOutput = "";

    disableStatistics();
    enableStatistics();

    VideoUtil.assetPath(ASSET_1).then((image1Path) {
      VideoUtil.assetPath(ASSET_2).then((image2Path) {
        VideoUtil.assetPath(ASSET_3).then((image3Path) {
          final String videoPath = getVideoPath();
          final String customOptions = getCustomEncodingOptions();
          final String ffmpegCodec = getFFmpegCodecName();

          VideoUtil.assetPath(videoPath).then((fullVideoPath) {
            execute(VideoUtil.generateEncodeVideoScript(image1Path, image2Path,
                    image3Path, fullVideoPath, ffmpegCodec, customOptions))
                .then((rc) {
              if (rc == 0) {
                getLastCommandOutput().then((output) => debugPrint("Last command output: \"$output\"", wrapWidth: 1024));
              }
            });

            // resetStatistics();

            getLastReceivedStatistics().then((lastStatistics) {
              if (lastStatistics == null) {
                print('No last statistics');
              } else {
                print('Last statistics');

                int time = lastStatistics['time'];
                int size = lastStatistics['size'];

                double bitrate = _doublePrecision(lastStatistics['bitrate'], 2);
                double speed = _doublePrecision(lastStatistics['speed'], 2);
                int videoFrameNumber = lastStatistics['videoFrameNumber'];
                double videoQuality =
                    _doublePrecision(lastStatistics['videoQuality'], 2);
                double videoFps =
                    _doublePrecision(lastStatistics['videoFps'], 2);

                statisticsCallback(time, size, bitrate, speed, videoFrameNumber,
                    videoQuality, videoFps);
              }
            });
          });
        });
      });
    });

    setState(() {});
  }

  void commandOutputLogCallback(int level, String message) {
    _commandOutput += message;
    setState(() {});
  }

  void encodeOutputLogCallback(int level, String message) {
    _encodeOutput += message;
    setState(() {});
  }

  void statisticsCallback(int time, int size, double bitrate, double speed,
      int videoFrameNumber, double videoQuality, double videoFps) {
    print(
        "Statistics: time: $time, size: $size, bitrate: $bitrate, speed: $speed, videoFrameNumber: $videoFrameNumber, videoQuality: $videoQuality, videoFps: $videoFps");
  }

  Future<String> getFFmpegVersion() async {
    return await _flutterFFmpeg.getFFmpegVersion();
  }

  Future<String> getPlatform() async {
    return await _flutterFFmpeg.getPlatform();
  }

  Future<int> executeWithArguments(List arguments) async {
    return await _flutterFFmpeg.executeWithArguments(arguments);
  }

  Future<int> execute(String command) async {
    return await _flutterFFmpeg.execute(command);
  }

  Future<void> cancel() async {
    return await _flutterFFmpeg.cancel();
  }

  Future<void> disableRedirection() async {
    return await _flutterFFmpeg.disableRedirection();
  }

  Future<int> getLogLevel() async {
    return await _flutterFFmpeg.getLogLevel();
  }

  Future<void> setLogLevel(int logLevel) async {
    return await _flutterFFmpeg.setLogLevel(logLevel);
  }

  Future<void> enableLogs() async {
    return await _flutterFFmpeg.enableLogs();
  }

  Future<void> disableLogs() async {
    return await _flutterFFmpeg.disableLogs();
  }

  Future<void> enableStatistics() async {
    return await _flutterFFmpeg.enableStatistics();
  }

  Future<void> disableStatistics() async {
    return await _flutterFFmpeg.disableStatistics();
  }

  Future<Map<dynamic, dynamic>> getLastReceivedStatistics() async {
    return await _flutterFFmpeg.getLastReceivedStatistics();
  }

  Future<void> resetStatistics() async {
    return await _flutterFFmpeg.resetStatistics();
  }

  Future<void> setFontconfigConfigurationPath(String path) async {
    return await _flutterFFmpeg.setFontconfigConfigurationPath(path);
  }

  Future<void> setFontDirectory(
      String fontDirectory, Map<String, String> fontNameMap) async {
    return await _flutterFFmpeg.setFontDirectory(fontDirectory, fontNameMap);
  }

  Future<String> getPackageName() async {
    return await _flutterFFmpeg.getPackageName();
  }

  Future<List<dynamic>> getExternalLibraries() async {
    return await _flutterFFmpeg.getExternalLibraries();
  }

  Future<int> getLastReturnCode() async {
    return await _flutterFFmpeg.getLastReturnCode();
  }

  Future<String> getLastCommandOutput() async {
    return await _flutterFFmpeg.getLastCommandOutput();
  }

  Future<Map<dynamic, dynamic>> getMediaInformation(String path) async {
    return await _flutterFFmpeg.getMediaInformation(path);
  }

  Future<String> registerNewFFmpegPipe() async {
    return await _flutterFFmpeg.registerNewFFmpegPipe();
  }

  void _changedCodec(String selectedCodec) {
    setState(() {
      _currentCodec = selectedCodec;
    });
  }

  String getFFmpegCodecName() {
    String ffmpegCodec = _currentCodec;

    // VIDEO CODEC MENU HAS BASIC NAMES, FFMPEG NEEDS LONGER LIBRARY NAMES.
    if (ffmpegCodec == "x264") {
      ffmpegCodec = "libx264";
    } else if (ffmpegCodec == "x265") {
      ffmpegCodec = "libx265";
    } else if (ffmpegCodec == "xvid") {
      ffmpegCodec = "libxvid";
    } else if (ffmpegCodec == "vp8") {
      ffmpegCodec = "libvpx";
    } else if (ffmpegCodec == "vp9") {
      ffmpegCodec = "libvpx-vp9";
    }

    return ffmpegCodec;
  }

  String getVideoPath() {
    String ffmpegCodec = _currentCodec;

    String videoPath;
    if ((ffmpegCodec == "vp8") || (ffmpegCodec == "vp9")) {
      videoPath = "video.webm";
    } else {
      // mpeg4, x264, x265, xvid
      videoPath = "video.mp4";
    }

    return videoPath;
  }

  String getCustomEncodingOptions() {
    String videoCodec = _currentCodec;

    if (videoCodec == "x265") {
      return "-crf 28 -preset fast ";
    } else if (videoCodec == "vp8") {
      return "-b:v 1M -crf 10 ";
    } else if (videoCodec == "vp9") {
      return "-b:v 2M ";
    } else {
      return "";
    }
  }

  List<DropdownMenuItem<String>> _getCodecDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();

    items.add(new DropdownMenuItem(value: "mpeg4", child: new Text("mpeg4")));
    items.add(new DropdownMenuItem(value: "x264", child: new Text("x264")));
    items.add(new DropdownMenuItem(value: "x265", child: new Text("x265")));
    items.add(new DropdownMenuItem(value: "xvid", child: new Text("xvid")));
    items.add(new DropdownMenuItem(value: "vp8", child: new Text("vp8")));
    items.add(new DropdownMenuItem(value: "vp9", child: new Text("vp9")));

    return items;
  }

  double _doublePrecision(double value, int precision) {
    if (value == null) {
      return 0;
    } else {
      return num.parse(value.toStringAsFixed(precision));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('FlutterFFmpeg Test'),
          centerTitle: true,
        ),
        bottomNavigationBar: Material(
          child: DecoratedTabBar(
            tabBar: TabBar(
              tabs: <Tab>[
                Tab(text: "COMMAND"),
                Tab(
                  text: "VIDEO",
                )
              ],
              controller: _controller,
              labelColor: Color(0xFF1e90ff),
              unselectedLabelColor: Color(0xFF808080),
            ),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(0xFF808080),
                  width: 1.0,
                ),
                bottom: BorderSide(
                  width: 0.0,
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
                  child: TextField(
                    controller: _commandController,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFF3498DB)),
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(5),
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFF3498DB)),
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(5),
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFF3498DB)),
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(5),
                          ),
                        ),
                        contentPadding: EdgeInsets.fromLTRB(8, 12, 8, 12),
                        hintStyle: new TextStyle(
                            fontSize: 14, color: Colors.grey[400]),
                        hintText: "Enter command"),
                    style: new TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: new InkWell(
                    onTap: () => testRunCommand(),
                    child: new Container(
                      width: 100,
                      height: 38,
                      decoration: new BoxDecoration(
                        color: Color(0xFF2ECC71),
                        borderRadius: new BorderRadius.circular(5),
                      ),
                      child: new Center(
                        child: new Text(
                          'RUN',
                          style: new TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                      alignment: Alignment(-1.0, -1.0),
                      margin: EdgeInsets.all(20.0),
                      padding: EdgeInsets.all(4.0),
                      decoration: new BoxDecoration(
                          borderRadius:
                              BorderRadius.all(new Radius.circular(5)),
                          color: Color(0xFFF1C40F)),
                      child: SingleChildScrollView(
                          reverse: true, child: Text(_commandOutput))),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
                    child: Container(
                      width: 200,
                      alignment: Alignment(0.0, 0.0),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(155, 89, 182, 1.0),
                          borderRadius: BorderRadius.circular(5)),
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                        style: new TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        value: _currentCodec,
                        items: _codecDropDownMenuItems,
                        onChanged: _changedCodec,
                        iconSize: 0,
                        isExpanded: false,
                      )),
                    )),
                Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: new InkWell(
                    onTap: () => testEncodeVideo(),
                    child: new Container(
                      width: 100,
                      height: 38,
                      decoration: new BoxDecoration(
                        color: Color(0xFF2ECC71),
                        borderRadius: new BorderRadius.circular(5),
                      ),
                      child: new Center(
                        child: new Text(
                          'ENCODE',
                          style: new TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                      alignment: Alignment(-1.0, -1.0),
                      margin: EdgeInsets.all(20.0),
                      padding: EdgeInsets.all(4.0),
                      decoration: new BoxDecoration(
                          borderRadius:
                              BorderRadius.all(new Radius.circular(5)),
                          color: Color(0xFFF1C40F)),
                      child: SingleChildScrollView(
                          reverse: true, child: Text(_encodeOutput))),
                )
              ],
            ),
          ],
          controller: _controller,
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _commandController.dispose();
  }

  void testParseSimpleCommand() {
    var argumentArray = _flutterFFmpeg.parseArguments(
        "-hide_banner   -loop 1  -i file.jpg  -filter_complex  [0:v]setpts=PTS-STARTPTS[video] -map [video] -vsync 2 -async 1  video.mp4");

    assert(argumentArray != null);
    assert(argumentArray.length == 14);

    assert("-hide_banner" == argumentArray[0]);
    assert("-loop" == argumentArray[1]);
    assert("1" == argumentArray[2]);
    assert("-i" == argumentArray[3]);
    assert("file.jpg" == argumentArray[4]);
    assert("-filter_complex" == argumentArray[5]);
    assert("[0:v]setpts=PTS-STARTPTS[video]" == argumentArray[6]);
    assert("-map" == argumentArray[7]);
    assert("[video]" == argumentArray[8]);
    assert("-vsync" == argumentArray[9]);
    assert("2" == argumentArray[10]);
    assert("-async" == argumentArray[11]);
    assert("1" == argumentArray[12]);
    assert("video.mp4" == argumentArray[13]);
  }

  void testParseSingleQuotesInCommand() {
    var argumentArray = _flutterFFmpeg.parseArguments(
        "-loop 1 'file one.jpg'  -filter_complex  '[0:v]setpts=PTS-STARTPTS[video]'  -map  [video]  video.mp4 ");

    assert(argumentArray != null);
    assert(argumentArray.length == 8);

    assert("-loop" == argumentArray[0]);
    assert("1" == argumentArray[1]);
    assert("file one.jpg" == argumentArray[2]);
    assert("-filter_complex" == argumentArray[3]);
    assert("[0:v]setpts=PTS-STARTPTS[video]" == argumentArray[4]);
    assert("-map" == argumentArray[5]);
    assert("[video]" == argumentArray[6]);
    assert("video.mp4" == argumentArray[7]);
  }

  void testParseDoubleQuotesInCommand() {
    var argumentArray = _flutterFFmpeg.parseArguments(
        "-loop  1 \"file one.jpg\"   -filter_complex \"[0:v]setpts=PTS-STARTPTS[video]\"  -map  [video]  video.mp4 ");

    assert(argumentArray != null);
    assert(argumentArray.length == 8);

    assert("-loop" == argumentArray[0]);
    assert("1" == argumentArray[1]);
    assert("file one.jpg" == argumentArray[2]);
    assert("-filter_complex" == argumentArray[3]);
    assert("[0:v]setpts=PTS-STARTPTS[video]" == argumentArray[4]);
    assert("-map" == argumentArray[5]);
    assert("[video]" == argumentArray[6]);
    assert("video.mp4" == argumentArray[7]);

    argumentArray = _flutterFFmpeg.parseArguments(
        " -i   file:///tmp/input.mp4 -vcodec libx264 -vf \"scale=1024:1024,pad=width=1024:height=1024:x=0:y=0:color=black\"  -acodec copy  -q:v 0  -q:a   0 video.mp4");

    assert(argumentArray != null);
    assert(argumentArray.length == 13);

    assert("-i" == argumentArray[0]);
    assert("file:///tmp/input.mp4" == argumentArray[1]);
    assert("-vcodec" == argumentArray[2]);
    assert("libx264" == argumentArray[3]);
    assert("-vf" == argumentArray[4]);
    assert("scale=1024:1024,pad=width=1024:height=1024:x=0:y=0:color=black" ==
        argumentArray[5]);
    assert("-acodec" == argumentArray[6]);
    assert("copy" == argumentArray[7]);
    assert("-q:v" == argumentArray[8]);
    assert("0" == argumentArray[9]);
    assert("-q:a" == argumentArray[10]);
    assert("0" == argumentArray[11]);
    assert("video.mp4" == argumentArray[12]);
  }

  void testParseDoubleQuotesAndEscapesInCommand() {
    var argumentArray = _flutterFFmpeg.parseArguments(
        "  -i   file:///tmp/input.mp4 -vf \"subtitles=file:///tmp/subtitles.srt:force_style=\'FontSize=16,PrimaryColour=&HFFFFFF&\'\" -vcodec libx264   -acodec copy  -q:v 0 -q:a  0  video.mp4");

    assert(argumentArray != null);
    assert(argumentArray.length == 13);

    assert("-i" == argumentArray[0]);
    assert("file:///tmp/input.mp4" == argumentArray[1]);
    assert("-vf" == argumentArray[2]);
    assert(
        "subtitles=file:///tmp/subtitles.srt:force_style='FontSize=16,PrimaryColour=&HFFFFFF&'" ==
            argumentArray[3]);
    assert("-vcodec" == argumentArray[4]);
    assert("libx264" == argumentArray[5]);
    assert("-acodec" == argumentArray[6]);
    assert("copy" == argumentArray[7]);
    assert("-q:v" == argumentArray[8]);
    assert("0" == argumentArray[9]);
    assert("-q:a" == argumentArray[10]);
    assert("0" == argumentArray[11]);
    assert("video.mp4" == argumentArray[12]);

    argumentArray = _flutterFFmpeg.parseArguments(
        "  -i   file:///tmp/input.mp4 -vf \"subtitles=file:///tmp/subtitles.srt:force_style=\\\"FontSize=16,PrimaryColour=&HFFFFFF&\\\"\" -vcodec libx264   -acodec copy  -q:v 0 -q:a  0  video.mp4");

    assert(argumentArray != null);
    assert(argumentArray.length == 13);

    assert("-i" == argumentArray[0]);
    assert("file:///tmp/input.mp4" == argumentArray[1]);
    assert("-vf" == argumentArray[2]);
    assert(
        "subtitles=file:///tmp/subtitles.srt:force_style=\\\"FontSize=16,PrimaryColour=&HFFFFFF&\\\"" ==
            argumentArray[3]);
    assert("-vcodec" == argumentArray[4]);
    assert("libx264" == argumentArray[5]);
    assert("-acodec" == argumentArray[6]);
    assert("copy" == argumentArray[7]);
    assert("-q:v" == argumentArray[8]);
    assert("0" == argumentArray[9]);
    assert("-q:a" == argumentArray[10]);
    assert("0" == argumentArray[11]);
    assert("video.mp4" == argumentArray[12]);
  }
}
