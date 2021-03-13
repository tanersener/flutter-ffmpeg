/*
 * Copyright (c) 2020 Taner Sener
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

import 'package:flutter_ffmpeg/ffmpeg_execution.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_ffmpeg/media_information.dart';
import 'package:flutter_ffmpeg/statistics.dart';

final FlutterFFmpegConfig _flutterFFmpegConfig = new FlutterFFmpegConfig();
final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
final FlutterFFprobe _flutterFFprobe = new FlutterFFprobe();

void enableLogCallback(LogCallback? callback) {
  _flutterFFmpegConfig.enableLogCallback(callback);
}

void enableStatisticsCallback(StatisticsCallback? callback) {
  _flutterFFmpegConfig.enableStatisticsCallback(callback);
}

Future<String> getFFmpegVersion() async {
  return await _flutterFFmpegConfig.getFFmpegVersion();
}

Future<String> getPlatform() async {
  return await _flutterFFmpegConfig.getPlatform();
}

Future<int> executeFFmpegWithArguments(List arguments) async {
  return await _flutterFFmpeg.executeWithArguments(arguments);
}

Future<int> executeFFmpeg(String command) async {
  return await _flutterFFmpeg.execute(command);
}

Future<int> executeAsyncFFmpeg(
    String command, ExecuteCallback executeCallback) async {
  return await _flutterFFmpeg.executeAsync(command, executeCallback);
}

Future<int> executeFFprobeWithArguments(List arguments) async {
  return await _flutterFFprobe.executeWithArguments(arguments);
}

Future<int> executeFFprobe(String command) async {
  return await _flutterFFprobe.execute(command);
}

Future<void> cancel() async {
  return await _flutterFFmpeg.cancel();
}

Future<void> cancelExecution(int executionId) async {
  return await _flutterFFmpeg.cancelExecution(executionId);
}

Future<void> disableRedirection() async {
  return await _flutterFFmpegConfig.disableRedirection();
}

Future<int> getLogLevel() async {
  return await _flutterFFmpegConfig.getLogLevel();
}

Future<void> setLogLevel(int logLevel) async {
  return await _flutterFFmpegConfig.setLogLevel(logLevel);
}

Future<void> enableLogs() async {
  return await _flutterFFmpegConfig.enableLogs();
}

Future<void> disableLogs() async {
  return await _flutterFFmpegConfig.disableLogs();
}

Future<void> enableStatistics() async {
  return await _flutterFFmpegConfig.enableStatistics();
}

Future<void> disableStatistics() async {
  return await _flutterFFmpegConfig.disableStatistics();
}

Future<Statistics> getLastReceivedStatistics() async {
  return await _flutterFFmpegConfig.getLastReceivedStatistics();
}

Future<void> resetStatistics() async {
  return await _flutterFFmpegConfig.resetStatistics();
}

Future<void> setFontconfigConfigurationPath(String path) async {
  return await _flutterFFmpegConfig.setFontconfigConfigurationPath(path);
}

Future<void> setFontDirectory(
    String fontDirectory, Map<String, String> fontNameMap) async {
  return await _flutterFFmpegConfig.setFontDirectory(
      fontDirectory, fontNameMap);
}

Future<String> getPackageName() async {
  return await _flutterFFmpegConfig.getPackageName();
}

Future<List<dynamic>> getExternalLibraries() async {
  return await _flutterFFmpegConfig.getExternalLibraries();
}

Future<int> getLastReturnCode() async {
  return await _flutterFFmpegConfig.getLastReturnCode();
}

Future<String> getLastCommandOutput() async {
  return await _flutterFFmpegConfig.getLastCommandOutput();
}

Future<MediaInformation> getMediaInformation(String path) async {
  return await _flutterFFprobe.getMediaInformation(path);
}

Future<String> registerNewFFmpegPipe() async {
  return await _flutterFFmpegConfig.registerNewFFmpegPipe();
}

Future<void> closeFFmpegPipe(String ffmpegPipePath) async {
  return await _flutterFFmpegConfig.closeFFmpegPipe(ffmpegPipePath);
}

Future<void> setEnvironmentVariable(
    String variableName, String variableValue) async {
  return await _flutterFFmpegConfig.setEnvironmentVariable(
      variableName, variableValue);
}

Future<List<FFmpegExecution>> listFFmpegExecutions() async {
  return await _flutterFFmpeg.listExecutions();
}

List<String>? parseArguments(command) {
  return FlutterFFmpeg.parseArguments(command);
}
