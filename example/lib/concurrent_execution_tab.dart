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

import 'dart:io';

import 'package:flutter_ffmpeg/completed_ffmpeg_execution.dart';
import 'package:flutter_ffmpeg/log.dart';
import 'package:flutter_ffmpeg_example/abstract.dart';
import 'package:flutter_ffmpeg_example/flutter_ffmpeg_api_wrapper.dart';
import 'package:flutter_ffmpeg_example/popup.dart';
import 'package:flutter_ffmpeg_example/tooltip.dart';
import 'package:flutter_ffmpeg_example/video_util.dart';

import 'util.dart';

class ConcurrentExecutionTab {
  late Refreshable _refreshable;
  String _outputText = '';
  late int _executionId1;
  late int _executionId2;
  late int _executionId3;

  void init(Refreshable refreshable) {
    _refreshable = refreshable;
    clearLog();

    _executionId1 = 0;
    _executionId2 = 0;
    _executionId3 = 0;
  }

  void setActive() {
    print("Concurrent Execution Tab Activated");
    enableLogCallback(logCallback);
    enableStatisticsCallback(null);
    showPopup(CONCURRENT_EXECUTION_TEST_TOOLTIP_TEXT);
  }

  void logCallback(Log log) {
    appendLog("${log.executionId}:${log.message}");
    _refreshable.refresh();
  }

  void appendLog(String logMessage) {
    _outputText += logMessage;
  }

  void clearLog() {
    _outputText = '';
  }

  void encodeVideo(int buttonNumber) {
    VideoUtil.assetPath(VideoUtil.ASSET_1).then((image1Path) {
      VideoUtil.assetPath(VideoUtil.ASSET_2).then((image2Path) {
        VideoUtil.assetPath(VideoUtil.ASSET_3).then((image3Path) {
          getVideoFile(buttonNumber).then((videoFile) {
            ffprint("Testing CONCURRENT EXECUTION for button $buttonNumber.");

            final ffmpegCommand = VideoUtil.generateEncodeVideoScript(
                image1Path,
                image2Path,
                image3Path,
                videoFile.path,
                "mpeg4",
                "");

            executeAsyncFFmpeg(ffmpegCommand,
                (CompletedFFmpegExecution execution) {
              if (execution.returnCode == 255) {
                ffprint(
                    "FFmpeg process ended with cancel for button $buttonNumber with executionId ${execution.executionId}.");
              } else {
                ffprint(
                    "FFmpeg process ended with rc ${execution.returnCode} for button $buttonNumber with executionId ${execution.executionId}.");
              }
            }).then((executionId) {
              ffprint(
                  "Async FFmpeg process started for button $buttonNumber with arguments '$ffmpegCommand' and executionId $executionId.");

              switch (buttonNumber) {
                case 1:
                  {
                    _executionId1 = executionId;
                  }
                  break;
                case 2:
                  {
                    _executionId2 = executionId;
                  }
                  break;
                default:
                  {
                    _executionId3 = executionId;
                  }
              }

              runListFFmpegExecutions();
            });
          });
        });
      });
    });
  }

  Future<File> getVideoFile(int buttonNumber) async {
    final String video = "video$buttonNumber.mp4";
    Directory documentsDirectory = await VideoUtil.documentsDirectory;
    return new File("${documentsDirectory.path}/$video");
  }

  void runListFFmpegExecutions() {
    listFFmpegExecutions().then((ffmpegExecutions) {
      ffprint("Listing ongoing FFmpeg executions.");
      int i = 0;
      ffmpegExecutions.forEach((execution) {
        i++;
        ffprint(
            "Execution $i = id:${execution.executionId}, startTime:${execution.command}, command:${execution.startTime}.");
      });
      ffprint("Listed ongoing FFmpeg executions.");
    });
  }

  void runCancel(final int buttonNumber) {
    int executionId = 0;

    switch (buttonNumber) {
      case 1:
        {
          executionId = _executionId1;
        }
        break;
      case 2:
        {
          executionId = _executionId2;
        }
        break;
      case 3:
        {
          executionId = _executionId3;
        }
    }

    ffprint(
        "Cancelling FFmpeg process for button $buttonNumber with executionId $executionId.");

    if (executionId == 0) {
      cancel();
    } else {
      cancelExecution(executionId);
    }
  }

  String getOutputText() => _outputText;
}
