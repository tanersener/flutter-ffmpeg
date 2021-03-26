# flutter_ffmpeg 

![GitHub release](https://img.shields.io/badge/release-v0.4.0-blue.svg)
![](https://img.shields.io/pub/v/flutter_ffmpeg.svg)

FFmpeg plugin for Flutter. Supports iOS and Android.

<img src="https://github.com/tanersener/flutter-ffmpeg/raw/development/doc/assets/flutter-ffmpeg-logo-v2-cropped.png" width="240">

### 1. Features
- Based on `MobileFFmpeg`
- Includes both `FFmpeg` and `FFprobe`
- Supports
    - Both `Android` and `iOS`
    - Both Android (API Level 16+) and iOS (SDK 9.3+)
    - FFmpeg `v4.1`, `v4.2`, `v4.3` and `v4.4-dev` releases
    - `arm-v7a`, `arm-v7a-neon`, `arm64-v8a`, `x86` and `x86_64` architectures on Android
    - `armv7`, `armv7s`, `arm64`, `arm64e`, `i386` and `x86_64` architectures on iOS
    - 25 external libraries

        `fontconfig`, `freetype`, `fribidi`, `gmp`, `gnutls`, `kvazaar`, `lame`, `libaom`, `libass`, `libiconv`, `libilbc`, `libtheora`, `libvorbis`, `libvpx`, `libwebp`, `libxml2`, `opencore-amr`, `opus`, `shine`, `snappy`, `soxr`, `speex`, `twolame`, `vo-amrwbenc`, `wavpack`

    - 4 external libraries with GPL license

        `vid.stab`, `x264`, `x265`, `xvidcore`

    - Concurrent execution
    - `zlib` and `MediaCodec` Android system libraries
    - `bzip2`, `iconv`, `libuuid`, `zlib` system libraries and `AudioToolbox`, `VideoToolbox`, `AVFoundation` system frameworks

- Licensed under LGPL 3.0, can be customized to support GPL v3.0

### 2. Installation

Add `flutter_ffmpeg` as a dependency in your `pubspec.yaml file`.
  ```
dependencies:
    flutter_ffmpeg: ^0.4.0
  ```

#### 2.1 Packages

`ffmpeg` includes built-in encoders for some popular formats. However, there are certain external libraries that needs 
to be enabled in order to encode specific formats/codecs. For example, to encode an `mp3` file you need `lame` or 
`shine` library enabled. You have to install a `flutter_ffmpeg` package that has at least one of them inside. 
To encode an `h264` video, you need to install a package with `x264` inside. To encode `vp8` or `vp9` videos, you need 
a `flutter_ffmpeg` package with `libvpx` inside.

`flutter_ffmpeg` provides eight packages that include different sets of external libraries. These packages are named 
according to the external libraries included in them. Below you can see which libraries are enabled in each package. 

<table>
<thead>
<tr>
<th align="center"></th>
<th align="center"><sup>min</sup></th>
<th align="center"><sup>min-gpl</sup></th>
<th align="center"><sup>https</sup></th>
<th align="center"><sup>https-gpl</sup></th>
<th align="center"><sup>audio</sup></th>
<th align="center"><sup>video</sup></th>
<th align="center"><sup>full</sup></th>
<th align="center"><sup>full-gpl</sup></th>
</tr>
</thead>
<tbody>
<tr>
<td align="center"><sup>external libraries</sup></td>
<td align="center">-</td>
<td align="center"><sup>vid.stab</sup><br><sup>x264</sup><br><sup>x265</sup><br><sup>xvidcore</sup></td>
<td align="center"><sup>gmp</sup><br><sup>gnutls</sup></td>
<td align="center"><sup>gmp</sup><br><sup>gnutls</sup><br><sup>vid.stab</sup><br><sup>x264</sup><br><sup>x265</sup><br><sup>xvidcore</sup></td>
<td align="center"><sup>lame</sup><br><sup>libilbc</sup><br><sup>libvorbis</sup><br><sup>opencore-amr</sup><br><sup>opus</sup><br><sup>shine</sup><br><sup>soxr</sup><br><sup>speex</sup><br><sup>twolame</sup><br><sup>vo-amrwbenc</sup><br><sup>wavpack</sup></td>
<td align="center"><sup>fontconfig</sup><br><sup>freetype</sup><br><sup>fribidi</sup><br><sup>kvazaar</sup><br><sup>libaom</sup><br><sup>libass</sup><br><sup>libiconv</sup><br><sup>libtheora</sup><br><sup>libvpx</sup><br><sup>libwebp</sup><br><sup>snappy</sup></td>
<td align="center"><sup>fontconfig</sup><br><sup>freetype</sup><br><sup>fribidi</sup><br><sup>gmp</sup><br><sup>gnutls</sup><br><sup>kvazaar</sup><br><sup>lame</sup><br><sup>libaom</sup><br><sup>libass</sup><br><sup>libiconv</sup><br><sup>libilbc</sup><br><sup>libtheora</sup><br><sup>libvorbis</sup><br><sup>libvpx</sup><br><sup>libwebp</sup><br><sup>libxml2</sup><br><sup>opencore-amr</sup><br><sup>opus</sup><br><sup>shine</sup><br><sup>snappy</sup><br><sup>soxr</sup><br><sup>speex</sup><br><sup>twolame</sup><br><sup>vo-amrwbenc</sup><br><sup>wavpack</sup></td>
<td align="center"><sup>fontconfig</sup><br><sup>freetype</sup><br><sup>fribidi</sup><br><sup>gmp</sup><br><sup>gnutls</sup><br><sup>kvazaar</sup><br><sup>lame</sup><br><sup>libaom</sup><br><sup>libass</sup><br><sup>libiconv</sup><br><sup>libilbc</sup><br><sup>libtheora</sup><br><sup>libvorbis</sup><br><sup>libvpx</sup><br><sup>libwebp</sup><br><sup>libxml2</sup><br><sup>opencore-amr</sup><br><sup>opus</sup><br><sup>shine</sup><br><sup>snappy</sup><br><sup>soxr</sup><br><sup>speex</sup><br><sup>twolame</sup><br><sup>vid.stab</sup><br><sup>vo-amrwbenc</sup><br><sup>wavpack</sup><br><sup>x264</sup><br><sup>x265</sup><br><sup>xvidcore</sup></td>
</tr>
<tr>
<td align="center"><sup>android system libraries</sup></td>
<td align="center" colspan=8><sup>zlib</sup><br><sup>MediaCodec</sup></td>
</tr>
<tr>
<td align="center"><sup>ios system libraries</sup></td>
<td align="center" colspan=8><sup>zlib</sup><br><sup>AudioToolbox</sup><br><sup>AVFoundation</sup><br><sup>iconv</sup><br><sup>VideoToolbox</sup><br><sup>bzip2</sup></td>
</tr>
</tbody>
</table>

Installation of `FlutterFFmpeg` using `pub` enables the default package, which is based on `https` package. It is 
possible to enable other `flutter_ffmpeg` packages using the following steps.


##### 2.1.0 When releasing app
As of flutter v2.0, the native code is being getting deleted to decrease size of app and
due to that, many package functionalities are crashing. Same is the case of camera plugin.
It is requested to add `proguard-rules.pro` files in app folder:

```
## Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-dontwarn io.flutter.embedding.**

## Gson rules
# Gson uses generic type information stored in a class file when working with fields. Proguard
# removes such information by default, so configure it to keep all of it.
-keepattributes Signature

# For using GSON @Expose annotation
-keepattributes *Annotation*

# Gson specific classes
-dontwarn sun.misc.**
#-keep class com.google.gson.stream.** { *; }

# Prevent proguard from stripping interface information from TypeAdapter, TypeAdapterFactory,
# JsonSerializer, JsonDeserializer instances (so they can be used in @JsonAdapter)
-keep class * extends com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Prevent R8 from leaving Data object members always null
-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}

## flutter_local_notification plugin rules
-keep class com.dexterous.** { *; }
-keep class com.arthenica.mobileffmpeg.Config {
    native <methods>;
    void log(long, int, byte[]);
    void statistics(long, int, float, float, long , int, double, double);
}

-keep class com.arthenica.mobileffmpeg.AbiDetect {
    native <methods>;
}
```


##### 2.1.1 Android

- Edit `android/build.gradle` file and specify the package name in `ext.flutterFFmpegPackage` variable.

    ```
    ext {
        flutterFFmpegPackage  = "<flutter ffmpeg package name listed in section 2.1>"
    }

    ```
##### 2.1.2 iOS (Flutter >= 2.x)

- Edit `ios/Podfile`, add the following block **before** `target 'Runner do` and specify the package name in
  `<package name>` section :

    ```
    # "fork" of method flutter_install_plugin_pods (in fluttertools podhelpers.rb) to get lts version of ffmpeg
    def flutter_install_plugin_pods(application_path = nil, relative_symlink_dir, platform)
      # defined_in_file is set by CocoaPods and is a Pathname to the Podfile.
      application_path ||= File.dirname(defined_in_file.realpath) if self.respond_to?(:defined_in_file)
      raise 'Could not find application path' unless application_path

      # Prepare symlinks folder. We use symlinks to avoid having Podfile.lock
      # referring to absolute paths on developers' machines.

      symlink_dir = File.expand_path(relative_symlink_dir, application_path)
      system('rm', '-rf', symlink_dir) # Avoid the complication of dependencies like FileUtils.

      symlink_plugins_dir = File.expand_path('plugins', symlink_dir)
      system('mkdir', '-p', symlink_plugins_dir)

      plugins_file = File.join(application_path, '..', '.flutter-plugins-dependencies')
      plugin_pods = flutter_parse_plugins_file(plugins_file, platform)
      plugin_pods.each do |plugin_hash|
        plugin_name = plugin_hash['name']
        plugin_path = plugin_hash['path']
        if (plugin_name && plugin_path)
          symlink = File.join(symlink_plugins_dir, plugin_name)
          File.symlink(plugin_path, symlink)

          if plugin_name == 'flutter_ffmpeg'
            pod 'flutter_ffmpeg/<package name>', :path => File.join(relative_symlink_dir, 'plugins', plugin_name, platform)
          else
            pod plugin_name, :path => File.join(relative_symlink_dir, 'plugins', plugin_name, platform)
          end
        end
      end
    end
    ```

##### 2.1.3 iOS (Flutter >= 1.20.x) && (Flutter < 2.x)

- Edit `ios/Podfile`, add the following block **before** `target 'Runner do` and specify the package name in
`<package name>` section :

    ```
    # "fork" of method flutter_install_ios_plugin_pods (in fluttertools podhelpers.rb) to get lts version of ffmpeg
    def flutter_install_ios_plugin_pods(ios_application_path = nil)
      # defined_in_file is set by CocoaPods and is a Pathname to the Podfile.
      ios_application_path ||= File.dirname(defined_in_file.realpath) if self.respond_to?(:defined_in_file)
      raise 'Could not find iOS application path' unless ios_application_path

      # Prepare symlinks folder. We use symlinks to avoid having Podfile.lock
      # referring to absolute paths on developers' machines.

      symlink_dir = File.expand_path('.symlinks', ios_application_path)
      system('rm', '-rf', symlink_dir) # Avoid the complication of dependencies like FileUtils.

      symlink_plugins_dir = File.expand_path('plugins', symlink_dir)
      system('mkdir', '-p', symlink_plugins_dir)

      plugins_file = File.join(ios_application_path, '..', '.flutter-plugins-dependencies')
      plugin_pods = flutter_parse_plugins_file(plugins_file)
      plugin_pods.each do |plugin_hash|
        plugin_name = plugin_hash['name']
        plugin_path = plugin_hash['path']

        if (plugin_name && plugin_path)
          symlink = File.join(symlink_plugins_dir, plugin_name)
          File.symlink(plugin_path, symlink)

          if plugin_name == 'flutter_ffmpeg'
            pod plugin_name+'/<package name>', :path => File.join('.symlinks', 'plugins', plugin_name, 'ios')
          else
            pod plugin_name, :path => File.join('.symlinks', 'plugins', plugin_name, 'ios')
          end
        end
      end
    end
    ```
- Ensure that `flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))` function is called within 
`target 'Runner' do` block. In that case, it is mandatory that the added function is named 
`flutter_install_ios_plugin_pods` and that you **do not** make an explicit call within that block.

##### 2.1.4 iOS (Flutter < 1.20.x)

- Edit `ios/Podfile` file and modify the default `# Plugin Pods` block as follows. Do not forget to specify the package 
name in `<package name>` section.

    ```
    # Prepare symlinks folder. We use symlinks to avoid having Podfile.lock
    # referring to absolute paths on developers' machines.
    system('rm -rf .symlinks')
    system('mkdir -p .symlinks/plugins')
    plugin_pods = parse_KV_file('../.flutter-plugins')
    plugin_pods.each do |name, path|
      symlink = File.join('.symlinks', 'plugins', name)
      File.symlink(path, symlink)
      if name == 'flutter_ffmpeg'
        pod name+'/<package name>', :path => File.join(symlink, 'ios')
      else
        pod name, :path => File.join(symlink, 'ios')
      end
    end
    ```

##### 2.1.5 Package Names

The following table shows all package names defined for `flutter_ffmpeg`.
    
| Package | Main Release | LTS Release |
| :----: | :----: | :----: |
| min | min  | min-lts |
| min-gpl | min-gpl | min-gpl-lts |
| https | https | https-lts |
| https-gpl | https-gpl | https-gpl-lts |
| audio | audio | audio-lts |
| video | video | video-lts |
| full | full | full-lts |
| full-gpl | full-gpl | full-gpl-lts |


#### 2.2 Existing Applications

It is possible to add `flutter_ffmpeg` to existing applications using 
[Add-to-App](https://github.com/flutter/flutter/wiki/Add-Flutter-to-existing-apps) guide.

Please execute the following additional steps if you are integrating into an iOS application.

1. Go to `Build Phases` of `Pods` -> `FlutterPluginRegistrant` target and add all frameworks under the 
`Pods/mobile-ffmpeg-<package name>` directory to the `Link Binary With Libraries` section

2. Go to `Build Phases` of `Pods` -> `FlutterPluginRegistrant` target and add all system libraries/frameworks listed 
in Step 4 of [Importing-Frameworks](https://github.com/tanersener/mobile-ffmpeg/wiki/Importing-Frameworks) guide to 
the `Link Binary With Libraries` section

3. Go to `Build Phases` of `Pods` -> `FlutterPluginRegistrant` target and add `AVFoundation` system framework to the 
`Link Binary With Libraries` section

#### 2.3 LTS Releases

`flutter_ffmpeg` is published in two different variants: `Main Release` and `LTS Release`. Both releases share the same
source code but is built with different settings. Below you can see the differences between the two.

In order to install the `LTS` variant, install the `https-lts` package using instructions in `2.1` or append `-lts` to 
the package name you are using. 

|        | Main Release | LTS Release |
| :----: | :----: | :----: |
| Android API Level | 24 | 16 | 
| Android Camera Access | Yes | - |
| Android Architectures | arm-v7a-neon<br/>arm64-v8a<br/>x86<br/>x86-64 | arm-v7a<br/>arm-v7a-neon<br/>arm64-v8a<br/>x86<br/>x86-64 |
| Xcode Support | 10.1 | 7.3.1 |
| iOS SDK | 11.0 | 9.3 |
| iOS AVFoundation | Yes | - |
| iOS Architectures | arm64<br/>x86-64<br/>x86-64-mac-catalyst | armv7<br/>arm64<br/>i386<br/>x86-64 |

### 3. Using

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
    
### 4. Example Application
You can see how `FlutterFFmpeg` is used inside an application by running example application provided under the 
`example` folder. It supports command execution, video encoding, accessing https, encoding audio, burning subtitles, 
video stabilisation, pipe operations and concurrent command execution.

<img src="https://github.com/tanersener/flutter-ffmpeg/raw/development/doc/assets/flutter_test_app.gif" width="240">

### 5. Tips

- `flutter_ffmpeg` uses file system paths, it does not know what an `assets` folder or a `project` folder is. So you 
can't use resources on those folders directly, you need to provide full paths of those resources.

- `flutter_ffmpeg` requires ios deployment target to be at least `11.0` for Main releases and `9.3` for LTS releases. 
  If you don't specify a deployment target or set a value smaller than the required one then your build may fail with 
  the following error.
   
   ```
    Resolving dependencies of `Podfile`
    [!] CocoaPods could not find compatible versions for pod "flutter_ffmpeg":
      In Podfile:
        flutter_ffmpeg (from `.symlinks/plugins/flutter_ffmpeg/ios`)
    
    Specs satisfying the `flutter_ffmpeg (from `.symlinks/plugins/flutter_ffmpeg/ios`)` dependency were found, but they required a higher minimum
    deployment target.
    ```
    
  You can fix this issue by adding the following definition to your `ios/Podfile` file.

    - `Main` releases
    ```
    platform :ios, '11.0'
    ```
    - `LTS` releases
    ```
    platform :ios, '9.3'
    ```

- If `flutter_ffmpeg` release builds on Android fail with the following exception, make sure that `mavenCentral()` is
  defined as a repository in your `build.gradle` and it is listed before `jcenter()`.

  ```
  E/flutter (14793): [ERROR:flutter/shell/platform/android/platform_view_android_jni_impl.cc(43)] java.lang.UnsatisfiedLinkError: Bad JNI version returned from JNI_OnLoad in "/data/app/com.arthenica.flutter.ffmpeg.FlutterFFmpegExample-DV2qVHHlZArnXoQYMowxVQ==/base.apk!/lib/arm64-v8a/libmobileffmpeg.so": 0
  E/flutter (14793): 	at java.lang.Runtime.loadLibrary0(Runtime.java:1071)
  E/flutter (14793): 	at java.lang.Runtime.loadLibrary0(Runtime.java:1007)
  E/flutter (14793): 	at java.lang.System.loadLibrary(System.java:1668)
  E/flutter (14793): 	at com.arthenica.mobileffmpeg.Config.<clinit>(Unknown Source:148)
  E/flutter (14793): 	at com.arthenica.mobileffmpeg.Config.c(Unknown Source:0)
  E/flutter (14793): 	at b.a.a.a.d.onMethodCall(Unknown Source:323)
  E/flutter (14793): 	at io.flutter.plugin.common.MethodChannel$IncomingMethodCallHandler.onMessage(Unknown Source:17)
  E/flutter (14793): 	at io.flutter.embedding.engine.dart.DartMessenger.handleMessageFromDart(Unknown Source:57)
  E/flutter (14793): 	at io.flutter.embedding.engine.FlutterJNI.handlePlatformMessage(Unknown Source:4)
  E/flutter (14793): 	at android.os.MessageQueue.nativePollOnce(Native Method)
  E/flutter (14793): 	at android.os.MessageQueue.next(MessageQueue.java:363)
  E/flutter (14793): 	at android.os.Looper.loop(Looper.java:173)
  E/flutter (14793): 	at android.app.ActivityThread.main(ActivityThread.java:8178)
  E/flutter (14793): 	at java.lang.reflect.Method.invoke(Native Method)
  E/flutter (14793): 	at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:513)
  E/flutter (14793): 	at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:1101)
  E/flutter (14793):
  F/flutter (14793): [FATAL:flutter/shell/platform/android/platform_view_android_jni_impl.cc(942)] Check failed: CheckException(env).
  ```

- `flutter_ffmpeg` includes native libraries that require ios deployment target to be at least `9.3`. If a deployment 
target is not set or a value smaller than `9.3` is used then your build will fail with the following error.
   
    ```
    ld: targeted OS version does not support use of thread local variables in __gnutls_rnd_deinit for architecture x86_64
    clang: error: linker command failed with exit code 1 (use -v to see invocation)
    ```

  Some versions of `Flutter` and `Cocoapods` have issues about setting ios deployment target from `Podfile`. On those 
  versions, having `platform :ios, '9.3'` in your `Podfile` is not enough. `Runner` project still uses the default 
  value `8.0`. You need to open `Runner.xcworkspace` in `Xcode` and set `iOS Deployment Target` of `Runner` project to 
  `9.3` manually or create a new project.
    
    <img src="https://github.com/tanersener/flutter-ffmpeg/raw/development/doc/assets/tip_runner_deployment_target.png" width="480">

- Enabling `ProGuard` on releases older than `v0.2.4` causes linking errors. Please add the following rule inside your 
`proguard-rules.pro` file to preserve necessary method names and prevent linking errors.

    ```
    -keep class com.arthenica.mobileffmpeg.Config {
        native <methods>;
        void log(int, byte[]);
        void statistics(int, float, float, long , int, double, double);
    }
    ```

- `ffmpeg` requires a valid `fontconfig` configuration to render subtitles. Unfortunately, Android does not include a 
default `fontconfig` configuration. So, if you do not register a font or specify a `fontconfig` configuration under 
Android, then the burning process will not produce any errors but subtitles won't be burned in your file. You can 
overcome this behaviour by registering a font using `setFontDirectory` method or specifying your own `fontconfig` 
configuration using `setFontconfigConfigurationPath` method.

- By default, Xcode compresses `PNG` files during packaging. If you use `.png` files in your commands make sure you 
set the following two settings to `NO`. If one of them is set to `YES`, your operations may fail with 
`Error while decoding stream #0:0: Generic error in an external library` error.

    <img src="https://github.com/tanersener/flutter-ffmpeg/raw/development/doc/assets/tip_png_files.png" width="720">

- Some `flutter_ffmpeg` packages include `libc++_shared.so` native library. If a second library which also includes 
`libc++_shared.so` is added as a dependency, `gradle` fails with 
`More than one file was found with OS independent path 'lib/x86/libc++_shared.so'` error message.

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

### 6. Updates

Refer to [Changelog](CHANGELOG.md) for updates.

### 7. License

This project is licensed under the LGPL v3.0. However, if installation is customized to use a package with `-gpl` 
postfix (min-gpl, https-gpl, full-gpl) then `FlutterFFmpeg` is subject to the GPL v3.0 license.

In test application; embedded fonts are licensed under the
[SIL Open Font License](https://opensource.org/licenses/OFL-1.1), other digital assets are published in the public
domain.

### 8. Patents

It is not clearly explained in their documentation but it is believed that `FFmpeg`, `kvazaar`, `x264` and `x265`
include algorithms which are subject to software patents. If you live in a country where software algorithms are
patentable then you'll probably need to pay royalty fees to patent holders. We are not lawyers though, so we recommend
that you seek legal advice first. See [FFmpeg Patent Mini-FAQ](https://ffmpeg.org/legal.html).

### 9. Contributing

Feel free to submit issues or pull requests.

Please note that `master` branch includes only the latest released source code. Changes planned for the next release 
are implemented under the `development` branch. Therefore, if you want to create a pull request, please open it against
the `development`.

### 10. See Also

- [FFmpeg](https://www.ffmpeg.org)
- [Mobile FFmpeg Wiki](https://github.com/tanersener/mobile-ffmpeg/wiki)
- [FFmpeg License and Legal Considerations](https://ffmpeg.org/legal.html)
