/*
 * Copyright (c) 2019-2020 Taner Sener
 *
 * This file is part of FlutterFFmpeg.
 *
 * FlutterFFmpeg is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * FlutterFFmpeg is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with FlutterFFmpeg.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_ffmpeg/ffmpeg_execution.dart';
import 'package:flutter_ffmpeg/log.dart';
import 'package:flutter_ffmpeg/media_information.dart';
import 'package:flutter_ffmpeg/statistics.dart';

typedef LogCallback = void Function(Log log);
typedef StatisticsCallback = void Function(Statistics statistics);
typedef ExecuteCallback = void Function(int executionId, int returnCode);

class FlutterFFmpegConfig {
  static const MethodChannel _methodChannel =
      const MethodChannel('flutter_ffmpeg');
  static const EventChannel _eventChannel =
      const EventChannel('flutter_ffmpeg_event');
  static final Map<int, ExecuteCallback> executeCallbackMap = new Map();

  LogCallback logCallback;
  StatisticsCallback statisticsCallback;

  FlutterFFmpegConfig() {
    logCallback = null;
    statisticsCallback = null;

    print("Loading flutter-ffmpeg.");

    _eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);

    enableLogs();
    enableStatistics();
    enableRedirection();

    getPlatform().then((name) => print("Loaded flutter-ffmpeg-$name."));
  }

  void _onEvent(Object event) {
    if (event is Map<dynamic, dynamic>) {
      final Map<String, dynamic> eventMap = event.cast();
      final Map<dynamic, dynamic> logEvent =
          eventMap['FlutterFFmpegLogCallback'];
      final Map<dynamic, dynamic> statisticsEvent =
          eventMap['FlutterFFmpegStatisticsCallback'];
      final Map<dynamic, dynamic> executeEvent =
          eventMap['FlutterFFmpegExecuteCallback'];

      if (logEvent != null) {
        handleLogEvent(logEvent);
      }

      if (statisticsEvent != null) {
        handleStatisticsEvent(statisticsEvent);
      }

      if (executeEvent != null) {
        handleExecuteEvent(executeEvent);
      }
    }
  }

  void _onError(Object error) {
    print('Event error: $error');
  }

  double _doublePrecision(double value, int precision) {
    if (value == null) {
      return 0;
    } else {
      return num.parse(value.toStringAsFixed(precision));
    }
  }

  static void addExecuteCallback(int executionId, ExecuteCallback newCallback) {
    executeCallbackMap[executionId] = newCallback;
  }

  void handleLogEvent(Map<dynamic, dynamic> logEvent) {
    int executionId = logEvent['executionId'];
    int level = logEvent['level'];
    String message = logEvent['log'];

    if (this.logCallback == null) {
      if (message.length > 0) {
        // PRINT ALREADY ADDS A NEW LINE. SO REMOVE THE EXISTING ONE
        if (message.endsWith('\n')) {
          print(message.substring(0, message.length - 1));
        } else {
          print(message);
        }
      }
    } else {
      this.logCallback(new Log(executionId, level, message));
    }
  }

  void handleStatisticsEvent(Map<dynamic, dynamic> statisticsEvent) {
    if (this.statisticsCallback != null) {
      this.statisticsCallback(eventToStatistics(statisticsEvent));
    }
  }

  void handleExecuteEvent(Map<dynamic, dynamic> executeEvent) {
    int executionId = executeEvent['executionId'];
    int returnCode = executeEvent['returnCode'];

    ExecuteCallback executeCallback = executeCallbackMap[executionId];
    if (executeCallback != null) {
      executeCallback(executionId, returnCode);
    }
  }

  /// Creates a new [Statistics] instance from event map.
  Statistics eventToStatistics(Map<dynamic, dynamic> eventMap) {
    if (eventMap.length == 0) {
      return null;
    } else {
      int executionId = eventMap['executionId'];
      int videoFrameNumber = eventMap['videoFrameNumber'];
      double videoFps = _doublePrecision(eventMap['videoFps'], 2);
      double videoQuality = _doublePrecision(eventMap['videoQuality'], 2);
      int time = eventMap['time'];
      int size = eventMap['size'];
      double bitrate = _doublePrecision(eventMap['bitrate'], 2);
      double speed = _doublePrecision(eventMap['speed'], 2);

      return new Statistics(executionId, videoFrameNumber, videoFps,
          videoQuality, size, time, bitrate, speed);
    }
  }

  /// Returns FFmpeg version bundled within the library.
  Future<String> getFFmpegVersion() async {
    try {
      final Map<dynamic, dynamic> result =
          await _methodChannel.invokeMethod('getFFmpegVersion');
      return result['version'];
    } on PlatformException catch (e, stack) {
      print("Plugin getFFmpegVersion error: ${e.message}");
      return Future.error("getFFmpegVersion failed.", stack);
    }
  }

  /// Returns platform name in which library is loaded.
  Future<String> getPlatform() async {
    try {
      final Map<dynamic, dynamic> result =
          await _methodChannel.invokeMethod('getPlatform');
      return result['platform'];
    } on PlatformException catch (e, stack) {
      print("Plugin getPlatform error: ${e.message}");
      return Future.error("getPlatform failed.", stack);
    }
  }

  /// Enables log and statistics redirection.
  Future<void> enableRedirection() async {
    try {
      await _methodChannel.invokeMethod('enableRedirection');
    } on PlatformException catch (e) {
      print("Plugin enableRedirection error: ${e.message}");
    }
  }

  /// Disables log and statistics redirection.
  ///
  /// By default redirection is enabled in constructor. When redirection is
  /// enabled FFmpeg logs are printed to console and can be routed further to a
  /// callback function.
  /// By disabling redirection, logs are redirected to stderr.
  ///
  /// Statistics redirection behaviour is similar. It is enabled by default.
  /// They are not printed but it is possible to define a statistics callback
  /// function. When statistics redirection is disabled they are not printed
  /// anywhere and only saved as lastReceivedStatistics data which can be
  /// polled with [getLastReceivedStatistics()] method.
  Future<void> disableRedirection() async {
    try {
      await _methodChannel.invokeMethod('disableRedirection');
    } on PlatformException catch (e) {
      print("Plugin disableRedirection error: ${e.message}");
    }
  }

  /// Returns log level.
  Future<int> getLogLevel() async {
    try {
      final Map<dynamic, dynamic> result =
          await _methodChannel.invokeMethod('getLogLevel');
      return result['level'];
    } on PlatformException catch (e, stack) {
      print("Plugin getLogLevel error: ${e.message}");
      return Future.error("getLogLevel failed.", stack);
    }
  }

  /// Sets log level.
  Future<void> setLogLevel(int logLevel) async {
    try {
      await _methodChannel.invokeMethod('setLogLevel', {'level': logLevel});
    } on PlatformException catch (e) {
      print("Plugin setLogLevel error: ${e.message}");
    }
  }

  /// Enables log events.
  Future<void> enableLogs() async {
    try {
      await _methodChannel.invokeMethod('enableLogs');
    } on PlatformException catch (e) {
      print("Plugin enableLogs error: ${e.message}");
    }
  }

  /// Disables log functionality of the library. Logs will not be printed to
  /// console and log callback will be disabled.
  /// Note that log functionality is enabled by default.
  Future<void> disableLogs() async {
    try {
      await _methodChannel.invokeMethod('disableLogs');
    } on PlatformException catch (e) {
      print("Plugin disableLogs error: ${e.message}");
    }
  }

  /// Enables statistics events.
  Future<void> enableStatistics() async {
    try {
      await _methodChannel.invokeMethod('enableStatistics');
    } on PlatformException catch (e) {
      print("Plugin enableStatistics error: ${e.message}");
    }
  }

  /// Disables statistics functionality of the library. Statistics callback
  /// will be disabled but the last received statistics data will be still
  /// available.
  /// Note that statistics functionality is enabled by default.
  Future<void> disableStatistics() async {
    try {
      await _methodChannel.invokeMethod('disableStatistics');
    } on PlatformException catch (e) {
      print("Plugin disableStatistics error: ${e.message}");
    }
  }

  /// Sets a callback to redirect FFmpeg logs. [newCallback] is the new log
  /// callback function, use null to disable a previously defined callback.
  void enableLogCallback(LogCallback newCallback) {
    try {
      this.logCallback = newCallback;
    } on PlatformException catch (e) {
      print("Plugin enableLogCallback error: ${e.message}");
    }
  }

  /// Sets a callback to redirect FFmpeg statistics. [newCallback] is the new
  /// statistics callback function, use null to disable a previously defined
  /// callback.
  void enableStatisticsCallback(StatisticsCallback newCallback) {
    try {
      this.statisticsCallback = newCallback;
    } on PlatformException catch (e) {
      print("Plugin enableStatisticsCallback error: ${e.message}");
    }
  }

  /// Returns the last received [Statistics] instance.
  Future<Statistics> getLastReceivedStatistics() async {
    try {
      return await _methodChannel
          .invokeMethod('getLastReceivedStatistics')
          .then((event) => eventToStatistics(event));
    } on PlatformException catch (e, stack) {
      print("Plugin getLastReceivedStatistics error: ${e.message}");
      return Future.error("getLastReceivedStatistics failed.", stack);
    }
  }

  /// Resets last received statistics. It is recommended to call it before
  /// starting a new execution.
  Future<void> resetStatistics() async {
    try {
      await _methodChannel.invokeMethod('resetStatistics');
    } on PlatformException catch (e) {
      print("Plugin resetStatistics error: ${e.message}");
    }
  }

  /// Sets and overrides fontconfig configuration directory.
  Future<void> setFontconfigConfigurationPath(String path) async {
    try {
      await _methodChannel
          .invokeMethod('setFontconfigConfigurationPath', {'path': path});
    } on PlatformException catch (e) {
      print("Plugin setFontconfigConfigurationPath error: ${e.message}");
    }
  }

  /// Registers fonts inside the given [fontDirectory], so they will be
  /// available to use in FFmpeg filters.
  Future<void> setFontDirectory(
      String fontDirectory, Map<String, String> fontNameMap) async {
    var parameters;
    if (fontNameMap == null) {
      parameters = {'fontDirectory': fontDirectory};
    } else {
      parameters = {'fontDirectory': fontDirectory, 'fontNameMap': fontNameMap};
    }

    try {
      await _methodChannel.invokeMethod('setFontDirectory', parameters);
    } on PlatformException catch (e) {
      print("Plugin setFontDirectory error: ${e.message}");
    }
  }

  /// Returns FlutterFFmpeg package name.
  Future<String> getPackageName() async {
    try {
      final Map<dynamic, dynamic> result =
          await _methodChannel.invokeMethod('getPackageName');
      return result['packageName'];
    } on PlatformException catch (e, stack) {
      print("Plugin getPackageName error: ${e.message}");
      return Future.error("getPackageName failed.", stack);
    }
  }

  /// Returns supported external libraries.
  Future<List<dynamic>> getExternalLibraries() async {
    try {
      final List<dynamic> result =
          await _methodChannel.invokeMethod('getExternalLibraries');
      return result;
    } on PlatformException catch (e, stack) {
      print("Plugin getExternalLibraries error: ${e.message}");
      return Future.error("getExternalLibraries failed.", stack);
    }
  }

  /// Returns return code of the last executed command.
  Future<int> getLastReturnCode() async {
    try {
      final Map<dynamic, dynamic> result =
          await _methodChannel.invokeMethod('getLastReturnCode');
      return result['lastRc'];
    } on PlatformException catch (e, stack) {
      print("Plugin getLastReturnCode error: ${e.message}");
      return Future.error("getLastReturnCode failed.", stack);
    }
  }

  /// Returns the log output of last executed command. Please note that
  /// [disableRedirection()] method also disables this functionality.
  ///
  /// This method does not support executing multiple concurrent commands. If
  /// you execute multiple commands at the same time, this method will return
  /// output from all executions.
  Future<String> getLastCommandOutput() async {
    try {
      final Map<dynamic, dynamic> result =
          await _methodChannel.invokeMethod('getLastCommandOutput');
      return result['lastCommandOutput'];
    } on PlatformException catch (e, stack) {
      print("Plugin getLastCommandOutput error: ${e.message}");
      return Future.error("getLastCommandOutput failed.", stack);
    }
  }

  /// Creates a new FFmpeg pipe and returns its path.
  Future<String> registerNewFFmpegPipe() async {
    try {
      final Map<dynamic, dynamic> result =
          await _methodChannel.invokeMethod('registerNewFFmpegPipe');
      return result['pipe'];
    } on PlatformException catch (e, stack) {
      print("Plugin registerNewFFmpegPipe error: ${e.message}");
      return Future.error("registerNewFFmpegPipe failed.", stack);
    }
  }

  /// Sets an environment variable.
  Future<void> setEnvironmentVariable(
      String variableName, String variableValue) async {
    try {
      var parameters = {
        'variableName': variableName,
        'variableValue': variableValue
      };
      await _methodChannel.invokeMethod('setEnvironmentVariable', parameters);
    } on PlatformException catch (e) {
      print("Plugin setEnvironmentVariable error: ${e.message}");
    }
  }
}

class FlutterFFmpeg {
  static const MethodChannel _methodChannel =
      const MethodChannel('flutter_ffmpeg');

  /// Executes FFmpeg synchronously with [commandArguments] provided. This
  /// method returns when execution completes.
  ///
  /// Returns zero on successful execution, 255 on user cancel and non-zero on
  /// error.
  Future<int> executeWithArguments(List<String> arguments) async {
    try {
      final Map<dynamic, dynamic> result = await _methodChannel
          .invokeMethod('executeFFmpegWithArguments', {'arguments': arguments});
      return result['rc'];
    } on PlatformException catch (e, stack) {
      print("Plugin executeWithArguments error: ${e.message}");
      return Future.error("executeWithArguments failed.", stack);
    }
  }

  /// Executes FFmpeg synchronously with [command] provided. This method
  /// returns when execution completes.
  ///
  /// Returns zero on successful execution, 255 on user cancel and non-zero on
  /// error.
  Future<int> execute(String command) async {
    return executeWithArguments(FlutterFFmpeg.parseArguments(command));
  }

  /// Executes FFmpeg asynchronously with [commandArguments] provided. This
  /// method starts the execution and does not wait the execution to complete.
  /// It returns immediately with executionId created for this execution.
  Future<int> executeAsyncWithArguments(
      List<String> arguments, ExecuteCallback executeCallback) async {
    try {
      return await _methodChannel.invokeMethod(
          'executeFFmpegAsyncWithArguments',
          {'arguments': arguments}).then((map) {
        var executionId = map["executionId"];
        FlutterFFmpegConfig.addExecuteCallback(executionId, executeCallback);
        return executionId;
      });
    } on PlatformException catch (e, stack) {
      print("Plugin executeFFmpegAsyncWithArguments error: ${e.message}");
      return Future.error("executeFFmpegAsyncWithArguments failed.", stack);
    }
  }

  /// Executes FFmpeg asynchronously with [command] provided. This method
  /// starts the execution and does not wait the execution to complete.
  /// It returns immediately with executionId created for this execution.
  Future<int> executeAsync(
      String command, ExecuteCallback executeCallback) async {
    return executeAsyncWithArguments(
        FlutterFFmpeg.parseArguments(command), executeCallback);
  }

  /// Cancels all ongoing executions.
  Future<void> cancel() async {
    try {
      await _methodChannel.invokeMethod('cancel');
    } on PlatformException catch (e) {
      print("Plugin cancel error: ${e.message}");
    }
  }

  /// Cancels the execution specified with [executionId].
  Future<void> cancelExecution(int executionId) async {
    try {
      await _methodChannel.invokeMethod('cancel', {'executionId': executionId});
    } on PlatformException catch (e) {
      print("Plugin cancelExecution error: ${e.message}");
    }
  }

  /// Lists ongoing FFmpeg executions.
  Future<List<FFmpegExecution>> listExecutions() async {
    try {
      return await _methodChannel.invokeMethod('listExecutions').then((value) {
        var mapList = value as List<dynamic>;
        List<FFmpegExecution> executions = new List();

        for (int i = 0; i < mapList.length; i++) {
          var execution = new FFmpegExecution();
          execution.executionId = mapList[i]["executionId"];
          execution.startTime = DateTime.fromMillisecondsSinceEpoch(
              mapList[i]["startTime"].toInt());
          execution.command = mapList[i]["command"];
          executions.add(execution);
        }

        return executions;
      });
    } on PlatformException catch (e, stack) {
      print("Plugin listExecutions error: ${e.message}");
      return Future.error("listExecutions failed.", stack);
    }
  }

  /// Parses the given [command] into arguments.
  static List<String> parseArguments(String command) {
    List<String> argumentList = new List();
    StringBuffer currentArgument = new StringBuffer();

    bool singleQuoteStarted = false;
    bool doubleQuoteStarted = false;

    for (int i = 0; i < command.length; i++) {
      var previousChar;
      if (i > 0) {
        previousChar = command.codeUnitAt(i - 1);
      } else {
        previousChar = null;
      }
      var currentChar = command.codeUnitAt(i);

      if (currentChar == ' '.codeUnitAt(0)) {
        if (singleQuoteStarted || doubleQuoteStarted) {
          currentArgument.write(String.fromCharCode(currentChar));
        } else if (currentArgument.length > 0) {
          argumentList.add(currentArgument.toString());
          currentArgument = new StringBuffer();
        }
      } else if (currentChar == '\''.codeUnitAt(0) &&
          (previousChar == null || previousChar != '\\'.codeUnitAt(0))) {
        if (singleQuoteStarted) {
          singleQuoteStarted = false;
        } else if (doubleQuoteStarted) {
          currentArgument.write(String.fromCharCode(currentChar));
        } else {
          singleQuoteStarted = true;
        }
      } else if (currentChar == '\"'.codeUnitAt(0) &&
          (previousChar == null || previousChar != '\\'.codeUnitAt(0))) {
        if (doubleQuoteStarted) {
          doubleQuoteStarted = false;
        } else if (singleQuoteStarted) {
          currentArgument.write(String.fromCharCode(currentChar));
        } else {
          doubleQuoteStarted = true;
        }
      } else {
        currentArgument.write(String.fromCharCode(currentChar));
      }
    }

    if (currentArgument.length > 0) {
      argumentList.add(currentArgument.toString());
    }

    return argumentList;
  }
}

class FlutterFFprobe {
  static const MethodChannel _methodChannel =
      const MethodChannel('flutter_ffmpeg');

  /// Executes FFprobe synchronously with [commandArguments] provided. This
  /// method returns when execution completes.
  ///
  /// Returns zero on successful execution, 255 on user cancel and non-zero on
  /// error.
  Future<int> executeWithArguments(List<String> arguments) async {
    try {
      final Map<dynamic, dynamic> result = await _methodChannel.invokeMethod(
          'executeFFprobeWithArguments', {'arguments': arguments});
      return result['rc'];
    } on PlatformException catch (e, stack) {
      print("Plugin executeWithArguments error: ${e.message}");
      return Future.error("executeWithArguments failed.", stack);
    }
  }

  /// Executes FFprobe synchronously with [command] provided. This method
  /// returns when execution completes.
  ///
  /// Returns zero on successful execution, 255 on user cancel and non-zero on
  /// error.
  Future<int> execute(String command) async {
    try {
      final Map<dynamic, dynamic> result = await _methodChannel.invokeMethod(
          'executeFFprobeWithArguments',
          {'arguments': FlutterFFmpeg.parseArguments(command)});
      return result['rc'];
    } on PlatformException catch (e, stack) {
      print("Plugin execute error: ${e.message}");
      return Future.error("execute failed for $command.", stack);
    }
  }

  /// Returns media information for the given [path].
  ///
  /// This method does not support executing multiple concurrent operations.
  /// If you execute multiple operations (execute or getMediaInformation) at
  /// the same time, the response of this method is not predictable.
  Future<MediaInformation> getMediaInformation(String path) async {
    try {
      return await _methodChannel.invokeMethod('getMediaInformation',
          {'path': path}).then((value) => new MediaInformation(value));
    } on PlatformException catch (e, stack) {
      print("Plugin getMediaInformation error: ${e.message}");
      return Future.error("getMediaInformation failed for $path.", stack);
    }
  }
}
