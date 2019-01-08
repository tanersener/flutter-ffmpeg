# flutter_ffmpeg 

[![Join the chat at https://gitter.im/flutter-ffmpeg/community](https://badges.gitter.im/flutter-ffmpeg/community.svg)](https://gitter.im/flutter-ffmpeg/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) 
![GitHub release](https://img.shields.io/badge/release-v0.1.1-blue.svg) 
![](https://img.shields.io/pub/v/flutter_ffmpeg.svg)

FFmpeg plugin for Flutter. Supports iOS and Android.

### 1. Features
- Based on MobileFFmpeg
- Supports
    - Both Android and IOS
    - FFmpeg `v4.2-dev-x` (master) releases
    - `arm-v7a`, `arm-v7a-neon`, `arm64-v8a`, `x86` and `x86_64` architectures on Android
    - `armv7`, `armv7s`, `arm64`, `arm64e`, `i386` and `x86_64` architectures on IOS
    - 24 external libraries

        `fontconfig`, `freetype`, `fribidi`, `gmp`, `gnutls`, `kvazaar`, `lame`, `libaom`, `libass`, `libiconv`, `libilbc`, `libtheora`, `libvorbis`, `libvpx`, `libwebp`, `libxml2`, `opencore-amr`, `opus`, `shine`, `snappy`, `soxr`, `speex`, `twolame`, `wavpack`

    - 4 external libraries with GPL license

        `vid.stab`, `x264`, `x265`, `xvidcore`

    - `zlib` and `MediaCodec` Android system libraries
    - `bzip2`, `zlib` IOS system libraries and `AudioToolbox`, `CoreImage`, `VideoToolbox`, `AVFoundation` IOS system frameworks

- Licensed under LGPL 3.0, can be customized to support GPL v3.0
- Includes eight different packages with different external libraries enabled in FFmpeg

<table>
<thead>
<tr>
<th align="center"></th>
<th align="center">min</th>
<th align="center">min-gpl</th>
<th align="center">https</th>
<th align="center">https-gpl</th>
<th align="center">audio</th>
<th align="center">video</th>
<th align="center">full</th>
<th align="center">full-gpl</th>
</tr>
</thead>
<tbody>
<tr>
<td align="center"><sup>external libraries</sup></td>
<td align="center">-</td>
<td align="center"><sup>vid.stab</sup><br><sup>x264</sup><br><sup>x265</sup><br><sup>xvidcore</sup></td>
<td align="center"><sup>gmp</sup><br><sup>gnutls</sup></td>
<td align="center"><sup>gmp</sup><br><sup>gnutls</sup><br><sup>vid.stab</sup><br><sup>x264</sup><br><sup>x265</sup><br><sup>xvidcore</sup></td>
<td align="center"><sup>lame</sup><br><sup>libilbc</sup><br><sup>libvorbis</sup><br><sup>opencore-amr</sup><br><sup>opus</sup><br><sup>shine</sup><br><sup>soxr</sup><br><sup>speex</sup><br><sup>twolame</sup><br><sup>wavpack</sup></td>
<td align="center"><sup>fontconfig</sup><br><sup>freetype</sup><br><sup>fribidi</sup><br><sup>kvazaar</sup><br><sup>libaom</sup><br><sup>libass</sup><br><sup>libiconv</sup><br><sup>libtheora</sup><br><sup>libvpx</sup><br><sup>libwebp</sup><br><sup>snappy</sup></td>
<td align="center"><sup>fontconfig</sup><br><sup>freetype</sup><br><sup>fribidi</sup><br><sup>gmp</sup><br><sup>gnutls</sup><br><sup>kvazaar</sup><br><sup>lame</sup><br><sup>libaom</sup><br><sup>libass</sup><br><sup>libiconv</sup><br><sup>libilbc</sup><br><sup>libtheora</sup><br><sup>libvorbis</sup><br><sup>libvpx</sup><br><sup>libwebp</sup><br><sup>libxml2</sup><br><sup>opencore-amr</sup><br><sup>opus</sup><br><sup>shine</sup><br><sup>snappy</sup><br><sup>soxr</sup><br><sup>speex</sup><br><sup>twolame</sup><br><sup>wavpack</sup></td>
<td align="center"><sup>fontconfig</sup><br><sup>freetype</sup><br><sup>fribidi</sup><br><sup>gmp</sup><br><sup>gnutls</sup><br><sup>kvazaar</sup><br><sup>lame</sup><br><sup>libaom</sup><br><sup>libass</sup><br><sup>libiconv</sup><br><sup>libilbc</sup><br><sup>libtheora</sup><br><sup>libvorbis</sup><br><sup>libvpx</sup><br><sup>libwebp</sup><br><sup>libxml2</sup><br><sup>opencore-amr</sup><br><sup>opus</sup><br><sup>shine</sup><br><sup>snappy</sup><br><sup>soxr</sup><br><sup>speex</sup><br><sup>twolame</sup><br><sup>vid.stab</sup><br><sup>wavpack</sup><br><sup>x264</sup><br><sup>x265</sup><br><sup>xvidcore</sup></td>
</tr>
<tr>
<td align="center"><sup>android system libraries</sup></td>
<td align="center" colspan=8><sup>zlib</sup><br><sup>MediaCodec</sup></td>
</tr>
<tr>
<td align="center"><sup>ios system libraries</sup></td>
<td align="center" colspan=8><sup>zlib</sup><br><sup>AudioToolbox</sup><br><sup>AVFoundation</sup><br><sup>CoreImage</sup><br><sup>VideoToolbox</sup><br><sup>bzip2</sup></td>
</tr>
</tbody>
</table>

### 2. Installation

Add `flutter_ffmpeg` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins).

#### 2.1 Packages

Installation of `FlutterFFmpeg` using `pub` enables the default package, which is based on `https` package of `LTS` release. It is possible to enable other packages using the following steps.

1. Use the following dependency block in your `pubspec.yaml` file.
    ```
    dependencies:
      flutter_ffmpeg:
        git:
          url: git://github.com/tanersener/flutter-ffmpeg.git
          ref: v0.1.1
          path: packages/flutter_ffmpeg_https

    ```
2. Update version in `ref:` argument.

3. Set package name in `path: packages/flutter_ffmpeg_<package name>[_lts]` section. Include `_lts` postfix only if you want to depend on an `LTS` release.

#### 2.2 LTS Releases

`flutter_ffmpeg` is published in two different variants: `Main Release` and `LTS Release`. Both releases share the same source code but is built with different settings. Below you can see the changes between the two.

|        | Main Release | LTS Release |
| :----: | :----: | :----: |
| Android API Level | 24 | 21 | 
| Android Camera Access | x | - |
| Android Architectures | arm-v7a-neon<br>arm64-v8a<br>x86<br>x86-64 | arm-v7a<br>arm-v7a-neon<br>arm64-v8a<br>x86<br>x86-64 |
| IOS SDK | 12.1 | 9.3 |
| Xcode Support | 10.1 | 7.3.1 |
| IOS Architectures | arm64<br>arm64e<br>x86-64 | armv7<br>arm64<br>i386<br>x86-64 |   

### 3. Using

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

### 4. Versions

#### 4.1 Releases

- `0.1.x` releases are based on `FFmpeg v4.2-dev` and `MobileFFmpeg v4.2.LTS`

### 5. Updates

Refer to [Changelog](CHANGELOG.md) for updates.

### 6. License

This project is licensed under the LGPL v3.0. However, if installation is customized to use a package with `-gpl` postfix (min-gpl, https-gpl, full-gpl) then `FlutterFFmpeg` is subject to the GPL v3.0 license.

Digital assets used in test applications are published in the public domain.

### 7. Contributing

Feel free to submit issues or pull requests.

### 8. See Also

- [FFmpeg](https://www.ffmpeg.org)
- [Mobile FFmpeg Wiki](https://github.com/tanersener/mobile-ffmpeg/wiki)
- [FFmpeg License and Legal Considerations](https://ffmpeg.org/legal.html)
