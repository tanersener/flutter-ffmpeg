# flutter_ffmpeg_example

Demonstrates how to use the flutter_ffmpeg plugin.

## Getting Started

1. Execute synchronous FFmpeg commands.

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
2. Execute asynchronous FFmpeg commands.

    ```
    _flutterFFmpeg.executeAsync(ffmpegCommand, (int executionId, int returnCode) {
      print("FFmpeg process for executionId $executionId exited with rc $returnCode");
    }).then((executionId) => print("Async FFmpeg process started with executionId $executionId."));
    ```

3. Execute FFprobe commands.

    - Use execute() method with a single command line  
    ```
    import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

    final FlutterFFprobe _flutterFFprobe = new FlutterFFprobe();

    _flutterFFprobe.execute("-i file1.mp4").then((rc) => print("FFprobe process exited with rc $rc"));
    ```
    
    - Use executeWithArguments() method with an array of arguments  

    ```
    import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

    final FlutterFFprobe _flutterFFprobe = new FlutterFFprobe();

    var arguments = ["-i", "file1.mp4"];
    _flutterFFprobe.executeWithArguments(arguments).then((rc) => print("FFprobe process exited with rc $rc"));
    ```

4. Check execution output. Zero represents successful execution, 255 means user cancel and non-zero values represent failure.
    ```
   
    final FlutterFFmpegConfig _flutterFFmpegConfig = new FlutterFFmpegConfig();
   
    _flutterFFmpegConfig.getLastReturnCode().then((rc) => print("Last rc: $rc"));

    _flutterFFmpegConfig.getLastCommandOutput().then((output) => print("Last command output: $output"));
    ```

5. Stop ongoing FFmpeg operations. Note that these two functions do not wait for termination to complete and return immediately.
    - Stop all executions
        ```
        _flutterFFmpeg.cancel();
        ```
    - Stop a specific execution
        ```
        _flutterFFmpeg.cancelExecution(executionId);
        ```

6. Get media information for a file.
    - Print all fields
    ```
    final FlutterFFprobe _flutterFFprobe = new FlutterFFprobe();

    _flutterFFprobe.getMediaInformation("<file path or uri>").then((info) => print(info));
    ```
    - Print selected fields
    ```
    final FlutterFFprobe _flutterFFprobe = new FlutterFFprobe();
    //add this line to get the chapters from a m4b file
    _flutterFFprobe.executeWithArguments(['-show_chapters']);
    _flutterFFprobe.getMediaInformation("<file path or uri>").then((info) {
        print("Media Information");

        print("Path: ${info.getMediaProperties()['filename']}");
        print("Format: ${info.getMediaProperties()['format_name']}");
        print("Duration: ${info.getMediaProperties()['duration']}");
        print("Start time: ${info.getMediaProperties()['start_time']}");
        print("Bitrate: ${info.getMediaProperties()['bit_rate']}");
        Map<dynamic, dynamic> tags = info.getMediaProperties()['tags'];
        if (tags != null) {
            tags.forEach((key, value) {
                print("Tag: " + key + ":" + value + "\n");
            });
        }

        if (info.getStreams() != null) {
            List<StreamInformation> streams = info.getStreams();

            if (streams.length > 0) {
                for (var stream in streams) {
                    print("Stream id: ${stream.getAllProperties()['index']}");
                    print("Stream type: ${stream.getAllProperties()['codec_type']}");
                    print("Stream codec: ${stream.getAllProperties()['codec_name']}");
                    print("Stream full codec: ${stream.getAllProperties()['codec_long_name']}");
                    print("Stream format: ${stream.getAllProperties()['pix_fmt']}");
                    print("Stream width: ${stream.getAllProperties()['width']}");
                    print("Stream height: ${stream.getAllProperties()['height']}");
                    print("Stream bitrate: ${stream.getAllProperties()['bit_rate']}");
                    print("Stream sample rate: ${stream.getAllProperties()['sample_rate']}");
                    print("Stream sample format: ${stream.getAllProperties()['sample_fmt']}");
                    print("Stream channel layout: ${stream.getAllProperties()['channel_layout']}");
                    print("Stream sar: ${stream.getAllProperties()['sample_aspect_ratio']}");
                    print("Stream dar: ${stream.getAllProperties()['display_aspect_ratio']}");
                    print("Stream average frame rate: ${stream.getAllProperties()['avg_frame_rate']}");
                    print("Stream real frame rate: ${stream.getAllProperties()['r_frame_rate']}");
                    print("Stream time base: ${stream.getAllProperties()['time_base']}");
                    print("Stream codec time base: ${stream.getAllProperties()['codec_time_base']}");

                    Map<dynamic, dynamic> tags = stream.getAllProperties()['tags'];
                    if (tags != null) {
                      tags.forEach((key, value) {
                        print("Stream tag: " + key + ":" + value + "\n");
                      });
                    }
                }
            }
        }
    });
    ```

7. Enable log callback and redirect all `FFmpeg`/`FFprobe` logs to a console/file/widget.
    ```
    void logCallback(Log log) {
        print("${log.executionId}:${log.message}");
    }
    ...
    _flutterFFmpegConfig.enableLogCallback(this.logCallback);
    ```

8. Enable statistics callback and follow the progress of an ongoing `FFmpeg` operation.
    ```
    void statisticsCallback(Statistics statistics) {
        print("Statistics: executionId: ${statistics.executionId}, time: ${statistics.time}, size: ${statistics.size}, bitrate: ${statistics.bitrate}, speed: ${statistics.speed}, videoFrameNumber: ${statistics.videoFrameNumber}, videoQuality: ${statistics.videoQuality}, videoFps: ${statistics.videoFps}");
    }
    ...
    _flutterFFmpegConfig.enableStatisticsCallback(this.statisticsCallback);
    ```

9. Poll statistics without implementing statistics callback.
    ```
    _flutterFFmpegConfig.getLastReceivedStatistics().then((stats) => print(stats));
    ```

10. List ongoing executions.
    ```
    _flutterFFmpeg.listExecutions().then((ffmpegExecutions) {
      ffmpegExecutions.forEach((execution) {
        ffprint(
            "Execution id:${execution.executionId}, startTime:${execution.command}, command:${execution.startTime}.");
      });
    });
    ```

11. Set log level.
    ```
    _flutterFFmpegConfig.setLogLevel(LogLevel.AV_LOG_WARNING);
    ```

12. Register your own fonts by specifying a custom fonts directory, so they are available to use in `FFmpeg` filters. Please note that this function can not work on relative paths, you need to provide full file system path.
    ```
    _flutterFFmpegConfig.setFontDirectory("<folder with fonts>");
    ```

13. Use your own `fontconfig` configuration.
    ```
    _flutterFFmpegConfig.setFontconfigConfigurationPath("<fontconfig configuration directory>");
    ```

14. Disable log functionality of the library. Logs will not be printed to console and log callback will be disabled.
    ```
    _flutterFFmpegConfig.disableLogs();
    ```

15. Disable statistics functionality of the library. Statistics callback will be disabled but the last received statistics data will be still available.
    ```
    _flutterFFmpegConfig.disableStatistics();
    ```

16. Create new `FFmpeg` pipe. 
    ```
    _flutterFFmpegConfig.registerNewFFmpegPipe().then((path) {
         then((stats) => print("New ffmpeg pipe at $path"));
    });
    ```
