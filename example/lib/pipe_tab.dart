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
import 'package:flutter_ffmpeg/statistics.dart';
import 'package:flutter_ffmpeg_example/abstract.dart';
import 'package:flutter_ffmpeg_example/flutter_ffmpeg_api_wrapper.dart';
import 'package:flutter_ffmpeg_example/player.dart';
import 'package:flutter_ffmpeg_example/popup.dart';
import 'package:flutter_ffmpeg_example/tooltip.dart';
import 'package:flutter_ffmpeg_example/video_util.dart';
import 'package:video_player/video_player.dart';

import 'util.dart';

class PipeTab implements PlayerTab {
  VideoPlayerController? _videoPlayerController;
  late RefreshablePlayerDialogFactory _refreshablePlayerDialogFactory;
  Statistics? _statistics;

  void init(RefreshablePlayerDialogFactory refreshablePlayerDialogFactory) {
    _refreshablePlayerDialogFactory = refreshablePlayerDialogFactory;
    _statistics = null;
  }

  void setActive() {
    print("Pipe Tab Activated");
    enableLogCallback(logCallback);
    enableStatisticsCallback(statisticsCallback);
    showPopup(PIPE_TEST_TOOLTIP_TEXT);
  }

  void logCallback(Log log) {
    ffprint(log.message);
    _refreshablePlayerDialogFactory.refresh();
  }

  void statisticsCallback(Statistics? statistics) {
    this._statistics = statistics;
    updateProgressDialog();
  }

  void asyncAssetWriteToPipe(String assetName, String pipePath) {
    VideoUtil.assetToPipe(assetName, pipePath);
  }

  void createVideo() {
    getVideoFile().then((videoFile) {
      registerNewFFmpegPipe().then((pipe1) {
        registerNewFFmpegPipe().then((pipe2) {
          registerNewFFmpegPipe().then((pipe3) {
            // IF VIDEO IS PLAYING STOP PLAYBACK
            pause();

            try {
              videoFile.delete().catchError((_) {});
            } on Exception catch (_) {}

            ffprint("Testing PIPE with 'mpeg4' codec");

            showProgressDialog();

            final ffmpegCommand = VideoUtil.generateCreateVideoWithPipesScript(
                pipe1, pipe2, pipe3, videoFile.path);

            executeAsyncFFmpeg(ffmpegCommand,
                (CompletedFFmpegExecution execution) {
              ffprint("FFmpeg process exited with rc ${execution.returnCode}.");

              hideProgressDialog();

              if (execution.returnCode == 0) {
                ffprint("Create completed successfully; playing video.");
                playVideo();
              } else {
                showPopup("Create failed. Please check log for the details.");
                ffprint("Create failed with rc=${execution.returnCode}.");
              }
            }).then((executionId) {
              ffprint(
                  "Async FFmpeg process started with arguments '$ffmpegCommand' and executionId $executionId.");
            });

            asyncAssetWriteToPipe("pyramid.jpg", pipe1);
            asyncAssetWriteToPipe("colosseum.jpg", pipe2);
            asyncAssetWriteToPipe("tajmahal.jpg", pipe3);
          });
        });
      });
    });
  }

  Future<void> playVideo() async {
    if (_videoPlayerController != null) {
      await _videoPlayerController!.initialize();
      await _videoPlayerController!.play();
    }
    _refreshablePlayerDialogFactory.refresh();
  }

  Future<void> pause() async {
    if (_videoPlayerController != null) {
      await _videoPlayerController!.pause();
    }
    _refreshablePlayerDialogFactory.refresh();
  }

  Future<File> getVideoFile() async {
    final String video = "video.mp4";
    Directory documentsDirectory = await VideoUtil.documentsDirectory;
    return new File("${documentsDirectory.path}/$video");
  }

  void showProgressDialog() {
    // CLEAN STATISTICS
    _statistics = null;
    resetStatistics();
    _refreshablePlayerDialogFactory.dialogShow("Creating video");
  }

  void updateProgressDialog() {
    if (_statistics == null) {
      return;
    }

    int timeInMilliseconds = this._statistics!.time;
    if (timeInMilliseconds > 0) {
      int totalVideoDuration = 9000;

      int completePercentage = (timeInMilliseconds * 100) ~/ totalVideoDuration;

      _refreshablePlayerDialogFactory
          .dialogUpdate("Creating video % $completePercentage");
      _refreshablePlayerDialogFactory.refresh();
    }
  }

  void hideProgressDialog() {
    _refreshablePlayerDialogFactory.dialogHide();
  }

  @override
  void setController(VideoPlayerController controller) {
    _videoPlayerController = controller;
  }
}
