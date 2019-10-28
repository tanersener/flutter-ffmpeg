# flutter_ffmpeg_example

Demonstrates how to use the flutter_ffmpeg plugin.

## Getting Started

1. Execute commands.

    - Use execute() method with a single command line  
    ```
    import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

    final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();

    _flutterFFmpeg.execute("-i file1.mp4 -c:v mpeg4 file2.mp4").then((rc) => print("FFmpeg process exited with rc $rc"));
    ```
    
    - Use executeWithArguments() method with an array of arguments  

    ```
    import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

    final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();

    var arguments = ["-i", "file1.mp4", "-c:v", "mpeg4", "file2.mp4"];
    _flutterFFmpeg.executeWithArguments(arguments).then((rc) => print("FFmpeg process exited with rc $rc"));
    ```

2. Check execution output. Zero represents successful execution, non-zero values represent failure.
    ```
    _flutterFFmpeg.getLastReturnCode().then((rc) => print("Last rc: $rc"));

    _flutterFFmpeg.getLastCommandOutput().then((output) => print("Last command output: $output"));
    ```

3. Stop an ongoing operation. Note that this function does not wait for termination to complete and returns immediately.
    ```
    _flutterFFmpeg.cancel();
    ```

4. Get media information for a file.
    - Print all fields
    ```
    _flutterFFmpeg.getMediaInformation("<file path or uri>").then((info) => print(info));
    ```
    - Print selected fields
    ```
    _flutterFFmpeg.getMediaInformation("<file path or uri>").then((info) {
        print("Media Information");

        print("Path: ${info['path']}");
        print("Format: ${info['format']}");
        print("Duration: ${info['duration']}");
        print("Start time: ${info['startTime']}");
        print("Bitrate: ${info['bitrate']}");

        if (info['streams'] != null) {
            final streamsInfoArray = info['streams'];

            if (streamsInfoArray.length > 0) {
                for (var streamsInfo in streamsInfoArray) {
                    print("Stream id: ${streamsInfo['index']}");
                    print("Stream type: ${streamsInfo['type']}");
                    print("Stream codec: ${streamsInfo['codec']}");
                    print("Stream full codec: ${streamsInfo['fullCodec']}");
                    print("Stream format: ${streamsInfo['format']}");
                    print("Stream full format: ${streamsInfo['fullFormat']}");
                    print("Stream width: ${streamsInfo['width']}");
                    print("Stream height: ${streamsInfo['height']}");
                    print("Stream bitrate: ${streamsInfo['bitrate']}");
                    print("Stream sample rate: ${streamsInfo['sampleRate']}");
                    print("Stream sample format: ${streamsInfo['sampleFormat']}");
                    print("Stream channel layout: ${streamsInfo['channelLayout']}");
                    print("Stream sar: ${streamsInfo['sampleAspectRatio']}");
                    print("Stream dar: ${streamsInfo['displayAspectRatio']}");
                    print("Stream average frame rate: ${streamsInfo['averageFrameRate']}");
                    print("Stream real frame rate: ${streamsInfo['realFrameRate']}");
                    print("Stream time base: ${streamsInfo['timeBase']}");
                    print("Stream codec time base: ${streamsInfo['codecTimeBase']}");
                }
            }
        }

    ```

5. Enable log callback and redirect all `FFmpeg` logs to a console/file/widget.
    ```
    void logCallback(int level, String message) {
        print(message);
    }
    ...
    _flutterFFmpeg.enableLogCallback(this.logCallback);
    ```

6. Enable statistics callback and follow the progress of an ongoing operation.
    ```
    void statisticsCallback(int time, int size, double bitrate, double speed, int videoFrameNumber, double videoQuality, double videoFps) {
        print("Statistics: time: $time, size: $size, bitrate: $bitrate, speed: $speed, videoFrameNumber: $videoFrameNumber, videoQuality: $videoQuality, videoFps: $videoFps");
    }
    ...
    _flutterFFmpeg.enableStatisticsCallback(this.statisticsCallback);
    ```

7. Poll statistics without implementing statistics callback.
    ```
    _flutterFFmpeg.getLastReceivedStatistics().then((stats) => print(stats));
    ```

8. Reset statistics before starting a new operation.
    ```
    _flutterFFmpeg.resetStatistics();
    ```

9. Set log level.
    ```
    _flutterFFmpeg.setLogLevel(LogLevel.AV_LOG_WARNING);
    ```

10. Register your own fonts by specifying a custom fonts directory, so they are available to use in `FFmpeg` filters.
    ```
    _flutterFFmpeg.setFontDirectory("<folder with fonts>");
    ```

11. Use your own `fontconfig` configuration.
    ```
    _flutterFFmpeg.setFontconfigConfigurationPath("<fontconfig configuration directory>");
    ```

12. Disable log functionality of the library. Logs will not be printed to console and log callback will be disabled.
    ```
    _flutterFFmpeg.disableLogs();
    ```

13. Disable statistics functionality of the library. Statistics callback will be disabled but the last received statistics data will be still available.
    ```
    _flutterFFmpeg.disableStatistics();
    ```

14. List enabled external libraries.
    ```
    _flutterFFmpeg.getExternalLibraries().then((packageList) {
         packageList.forEach((value) => print("External library: $value"));
    });
    ```
15. Create new `FFmpeg` pipe. 
    ```
    _flutterFFmpeg.registerNewFFmpegPipe().then((path) {
         then((stats) => print("New ffmpeg pipe at $path"));
    });
    ```

