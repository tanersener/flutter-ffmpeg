# flutter_ffmpeg

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

Default installation of `FlutterFFmpeg` enables the default package, which is based on `https` package. It is possible
to enable other installed packages using the following steps.

    ```

    ```

### 3. Using

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

### 4. Versions

#### 4.1 Releases

- `0.1.0` releases is based on `FFmpeg v4.2-dev` and `MobileFFmpeg v4.2.LTS`

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
