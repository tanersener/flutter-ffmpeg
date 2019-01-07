# flutter_ffmpeg_example

Demonstrates how to use the flutter_ffmpeg plugin.

## Getting Started

1. Execute commands.
    ```
    import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

    final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();

    _flutterFFmpeg.execute("-i file1.mp4 -c:v mpeg4 file2.mp4").then((rc) => print("FFmpeg process exited with rc $rc"));
    ```

2. Check execution output.
    ```
    _flutterFFmpeg.getLastReturnCode().then((rc) => print("Last rc: $rc"));
    _flutterFFmpeg.getLastCommandOutput().then((output) => print("Last command output: $output"));
    ```

3. Stop an ongoing operation.
    ```
    _flutterFFmpeg.cancel();
    ```

4. Get media information for a file.
    ```
    _flutterFFmpeg.getMediaInformation('<file path or uri>').then((info) => print(info));
    ```

5. List enabled external libraries.
    ```
    _flutterFFmpeg.getExternalLibraries().then((packageList) {
         packageList.forEach((value) => print("External library: $value"));
    });
    ```

6. Enable log callback.
    ```
    void logCallback(int level, String message) {
        print(message);
    }
    ...
    _flutterFFmpeg.enableLogCallback(this.logCallback);
    ```

7. Enable statistics callback.
    ```
    void statisticsCallback(int time, int size, double bitrate, double speed, int videoFrameNumber, double videoQuality, double videoFps) {
        print("Statistics: time: $time, size: $size, bitrate: $bitrate, speed: $speed, videoFrameNumber: $videoFrameNumber, videoQuality: $videoQuality, videoFps: $videoFps");
    }
    ...
    _flutterFFmpeg.enableStatisticsCallback(this.statisticsCallback);
    ```

8. Get last received statistics.
    ```
    _flutterFFmpeg.getLastReceivedStatistics().then((stats) => print(stats));
    ```

9. Set log level.
    ```
    _flutterFFmpeg.setLogLevel(LogLevel.AV_LOG_WARNING);
    ```

10. Register custom fonts directory.
    ```
    _flutterFFmpeg.setFontDirectory("<folder with fonts>");
    ```
