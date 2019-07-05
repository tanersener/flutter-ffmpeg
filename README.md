# flutter_ffmpeg 

![GitHub release](https://img.shields.io/badge/release-v0.2.5-blue.svg)
![](https://img.shields.io/pub/v/flutter_ffmpeg.svg)

FFmpeg plugin for Flutter. Supports iOS and Android.

<img src="https://github.com/tanersener/flutter-ffmpeg/raw/development/doc/assets/flutter-ffmpeg-logo-v2-cropped.png" width="240">

### 1. Features
- Based on MobileFFmpeg
- Supports
    - Both Android (API Level 16+) and iOS (SDK 9.3+)
    - FFmpeg `v4.2-dev-x` (master) releases
    - `arm-v7a`, `arm-v7a-neon`, `arm64-v8a`, `x86` and `x86_64` architectures on Android
    - `armv7`, `armv7s`, `arm64`, `arm64e`, `i386` and `x86_64` architectures on iOS
    - 24 external libraries

        `fontconfig`, `freetype`, `fribidi`, `gmp`, `gnutls`, `kvazaar`, `lame`, `libaom`, `libass`, `libiconv`, `libilbc`, `libtheora`, `libvorbis`, `libvpx`, `libwebp`, `libxml2`, `opencore-amr`, `opus`, `shine`, `snappy`, `soxr`, `speex`, `twolame`, `wavpack`

    - 4 external libraries with GPL license

        `vid.stab`, `x264`, `x265`, `xvidcore`

    - `zlib` and `MediaCodec` Android system libraries
    - `bzip2`, `zlib` iOS system libraries and `AudioToolbox`, `CoreImage`, `VideoToolbox`, `AVFoundation` iOS system frameworks

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

Add `flutter_ffmpeg` as a dependency in your `pubspec.yaml file`.
  ```
dependencies:
    flutter_ffmpeg: ^0.2.5
  ```

#### 2.1 Packages

Installation of `FlutterFFmpeg` using `pub` enables the default package, which is based on `https` package. It is possible to enable other packages using the following steps.

1. Use the following dependency block in your `pubspec.yaml` file.
    ```
    dependencies:
      flutter_ffmpeg:
        git:
          url: git://github.com/tanersener/flutter-ffmpeg.git
          ref: v0.2.5
          path: packages/flutter_ffmpeg_<package_name>

    ```
2. Update version in `ref:` argument.

3. Set package name in `path: packages/flutter_ffmpeg_<package_name>[_lts]` section. Include `_lts` postfix only if you want to depend on an `LTS` release.

#### 2.2 LTS Releases

`flutter_ffmpeg` is published in two different variants: `Main Release` and `LTS Release`. Both releases share the same source code but is built with different settings. Below you can see the changes between the two.

In order to install the `LTS` variant, install the `flutter_ffmpeg_https_lts` package using instructions in `2.1` or append `_lts` to the package name you are using. 

<table>
<thead>
    <tr>
        <th align="center"></th>
        <th align="center">Main Release</th>
        <th align="center">LTS Release</th>
    </tr>
</thead>
<tbody>
    <tr>
        <td align="center">Android API Level</td>
        <td align="center">24</td>
        <td align="center">16</td>
    </tr>
    <tr>
        <td align="center">Android Camera Access</td>
        <td align="center">Yes</td>
        <td align="center">-</td>
    </tr>
    <tr>
        <td align="center">Android Architectures</td>
        <td align="center">arm-v7a-neon<br>arm64-v8a<br>x86<br>x86-64</td>
        <td align="center">arm-v7a<br>arm-v7a-neon<br>arm64-v8a<br>x86<br>x86-64</td>
    </tr>
    <tr>
        <td align="center">Xcode Support</td>
        <td align="center">10.1</td>
        <td align="center">7.3.1</td>
    </tr>
    <tr>
        <td align="center">iOS SDK</td>
        <td align="center">12.1</td>
        <td align="center">9.3</td>
    </tr>
    <tr>
        <td align="center">iOS Architectures</td>
        <td align="center">arm64<br>arm64e<br>x86-64</td>
        <td align="center">armv7<br>arm64<br>i386<br>x86-64</td>
    </tr>
</tbody>
</table>   

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

### 4. Tips

- You should not use double quotes (") to define your complex filters or map definitions.
    ```
     -filter_complex [0:v]scale=1280:-1[v] -map [v]
    ```

- If your commands include unnecessary quotes or space characters, your command will fail with `No such filter: ' '` errors. Please check your command and remove them.

- `flutter_ffmpeg` uses file system paths, it does not know what an assets folder or project folder is. So you can't use resources on those folders directly, you need to provide full paths of those resources.

- `flutter_ffmpeg` requires ios deployment target to be at least `9.3`. 
  So if you don't specify a deployment target or set a value smaller than `9.3` then your build will fail with the following error.
   
   ```
    Resolving dependencies of `Podfile`
    [!] CocoaPods could not find compatible versions for pod "flutter_ffmpeg":
      In Podfile:
        flutter_ffmpeg (from `.symlinks/plugins/flutter_ffmpeg/ios`)
    
    Specs satisfying the `flutter_ffmpeg (from `.symlinks/plugins/flutter_ffmpeg/ios`)` dependency were found, but they required a higher minimum
    deployment target.
    ```
    
  You can fix this issue by adding `platform :ios, '9.3'` definition to your `ios/Podfile` file.

    ```
    platform :ios, '9.3'
    ```
    
- `flutter_ffmpeg` includes native libraries that require ios deployment target to be at least `9.3`. 
  If a deployment target is not set or a value smaller than `9.3` is used then your build will fail with the following error.
   
    ```
    ld: targeted OS version does not support use of thread local variables in __gnutls_rnd_deinit for architecture x86_64
    clang: error: linker command failed with exit code 1 (use -v to see invocation)
    ```

  Unfortunately the latest versions of `Flutter` and `Cocoapods` have some issues about setting ios deployment target from `Podfile`.
  Having `platform :ios, '9.3'` in your `Podfile` is not enough. `Runner` project still uses the default value `8.0`.
  You need to open `Runner.xcworkspace` in `Xcode` and set `iOS Deployment Target` of `Runner` project to `9.3` manually.
    
    <img src="https://github.com/tanersener/flutter-ffmpeg/raw/development/doc/assets/tip_runner_deployment_target.png" width="480">

- `execute` method is overloaded and has an optional delimiter parameter. Delimiter defines how the command string will be split into arguments. 
When delimiter is not specified the space character is used as the default delimiter. 
Based on this, if one or more of your command arguments include a space character, in filename path or in `-filter_complex` block, then your command string will be split into invalid arguments and execution will fail.  
You can fix this error by splitting your command string into array yourself and calling `executeWithArguments` method or using a different delimiter character in your command string and specifying it in the `execute` call.

- Enabling `ProGuard` on releases older than `v0.2.4` causes linking errors. Please add the following rule inside your `proguard-rules.pro` file to preserve necessary method names and prevent linking errors.

    ```
    -keep class com.arthenica.mobileffmpeg.Config {
        native <methods>;
        void log(int, byte[]);
        void statistics(int, float, float, long , int, double, double);
    }
    ```

- `ffmpeg` requires a valid `fontconfig` configuration to render subtitles. Unfortunately, Android does not include a default `fontconfig` configuration. 
So if you do not register a font or specify a `fontconfig` configuration under Android, then the burning process will not produce any errors but subtitles won't be burned in your file. 
You can overcome this situation by registering a font using `setFontDirectory` method or specifying your own `fontconfig` configuration using `setFontconfigConfigurationPath` method.

- By default, Xcode compresses `PNG` files during packaging. If you use `.png` files in your commands make sure you set the following two settings to `NO`. If one of them is set to `YES`, your operations may fail with `Error while decoding stream #0:0: Generic error in an external library` error.

    <img src="https://github.com/tanersener/flutter-ffmpeg/raw/development/doc/assets/tip_png_files.png" width="720">
    
- Setting `use_frameworks!` in `Podfile` causes the following error.

    ```    
    FlutterFFmpegPlugin.h:21:9: error: include of non-modular header inside framework module 'flutter_ffmpeg.FlutterFFmpegPlugin': 
    #import <mobileffmpeg/MobileFFmpegConfig.h>
            ^
    1 error generated.
    ```
    
    You can fix this error by setting `Allow Non-modular includes in Framework Modules` to `YES` under `Build Settings -> Apple LLVM - Language - Modules`.

    <img src="https://github.com/tanersener/flutter-ffmpeg/raw/development/doc/assets/tip_use_frameworks.png" width="500">

- Some `flutter_ffmpeg` packages include `libc++_shared.so` native library. If a second library which also includes `libc++_shared.so` is added as a dependency, `gradle` fails with `More than one file was found with OS independent path 'lib/x86/libc++_shared.so'` error message.

  You can fix this error by adding the following block into your `build.gradle`.
  ```
  android {
      packagingOptions {
          pickFirst 'lib/x86/libc++_shared.so'
          pickFirst 'lib/x86_64/libc++_shared.so'
          pickFirst 'lib/armeabi-v7a/libc++_shared.so'
          pickFirst 'lib/arm64-v8a/libc++_shared.so'
      }
  }
  ```

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
