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

import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/log.dart';
import 'package:flutter_ffmpeg_example/abstract.dart';
import 'package:flutter_ffmpeg_example/popup.dart';
import 'package:flutter_ffmpeg_example/tooltip.dart';

import 'flutter_ffmpeg_api_wrapper.dart';
import 'util.dart';

class CommandTab {
  Refreshable _refreshable;
  TextEditingController _commandText;
  String _outputText;

  void init(Refreshable refreshable) {
    _refreshable = refreshable;
    _commandText = TextEditingController();
    clearLog();

    // COMMAND TAB IS SELECTED BY DEFAULT
    setActive();
  }

  void setActive() {
    print("Command Tab Activated");
    enableLogCallback(logCallback);
    enableStatisticsCallback(null);
    showPopup(COMMAND_TEST_TOOLTIP_TEXT);
  }

  void logCallback(Log log) {
    appendLog(log.message);
    _refreshable.refresh();
  }

  void appendLog(String logMessage) {
    _outputText += logMessage;
  }

  void clearLog() {
    _outputText = "";
  }

  void runFFmpeg() {
    clearLog();

    final String ffmpegCommand = _commandText.text;

    getLogLevel()
        .then((logLevel) => ffprint("Current log level is $logLevel."));

    ffprint("Testing FFmpeg COMMAND synchronously.");

    ffprint("FFmpeg process started with arguments\n\'$ffmpegCommand\'");

    executeFFmpeg(ffmpegCommand).then((result) {
      ffprint("FFmpeg process exited with rc $result.");
      if (result != 0) {
        showPopup("Command failed. Please check output for the details.");
      }
    });
  }

  void runFFprobe() {
    clearLog();

    final String ffprobeCommand = _commandText.text;

    ffprint("Testing FFprobe COMMAND synchronously.");

    ffprint("FFprobe process started with arguments\n\'$ffprobeCommand\'");

    executeFFprobe(ffprobeCommand).then((result) {
      ffprint("FFprobe process exited with rc $result.");
      if (result != 0) {
        showPopup("Command failed. Please check output for the details.");
      }
    });
  }

  String getOutputText() => _outputText;

  TextEditingController getCommandText() => _commandText;

  void dispose() {
    _commandText.dispose();
  }
}
