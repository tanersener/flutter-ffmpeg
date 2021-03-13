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
import 'package:flutter_ffmpeg_example/player.dart';
import 'package:flutter_ffmpeg_example/popup.dart';
import 'package:flutter_ffmpeg_example/tooltip.dart';
import 'package:flutter_ffmpeg_example/video_util.dart';
import 'package:video_player/video_player.dart';

import 'util.dart';

class _ControllerWrapper implements PlayerTab {
  VideoPlayerController? _controller;

  @override
  void setController(VideoPlayerController controller) {
    _controller = controller;
  }
}

class VidStabTab {
  late _ControllerWrapper videoController;
  late _ControllerWrapper stabilizedVideoController;
  late RefreshablePlayerDialogFactory _refreshablePlayerDialogFactory;

  void init(RefreshablePlayerDialogFactory refreshablePlayerDialogFactory) {
    _refreshablePlayerDialogFactory = refreshablePlayerDialogFactory;
    videoController = _ControllerWrapper();
    stabilizedVideoController = _ControllerWrapper();
  }

  void setActive() {
    print("VidStab Tab Activated");
    enableLogCallback(logCallback);
    enableStatisticsCallback(null);
    showPopup(VIDSTAB_TEST_TOOLTIP_TEXT);
  }

  void logCallback(Log log) {
    ffprint(log.message);
    _refreshablePlayerDialogFactory.refresh();
  }

  void stabilizeVideo() {
    VideoUtil.assetPath(VideoUtil.ASSET_1).then((image1Path) {
      VideoUtil.assetPath(VideoUtil.ASSET_2).then((image2Path) {
        VideoUtil.assetPath(VideoUtil.ASSET_3).then((image3Path) {
          getShakeResultsFile().then((shakeResultsFile) {
            getVideoFile().then((videoFile) {
              getStabilizedVideoFile().then((stabilizedVideoFile) {
                // IF VIDEO IS PLAYING STOP PLAYBACK
                pauseVideo();
                pauseStabilizedVideo();

                try {
                  shakeResultsFile.delete().catchError((_) {});
                } on Exception catch (_) {}

                try {
                  videoFile.delete().catchError((_) {});
                } on Exception catch (_) {}

                try {
                  stabilizedVideoFile.delete().catchError((_) {});
                } on Exception catch (_) {}

                ffprint("Testing VID.STAB");

                showCreateProgressDialog();

                final ffmpegCommand = VideoUtil.generateShakingVideoScript(
                    image1Path, image2Path, image3Path, videoFile.path);

                executeAsyncFFmpeg(ffmpegCommand,
                    (CompletedFFmpegExecution execution) {
                  ffprint(
                      "FFmpeg process exited with rc ${execution.returnCode}.");

                  hideProgressDialog();

                  if (execution.returnCode == 0) {
                    ffprint(
                        "Create completed successfully; stabilizing video.");

                    String analyzeVideoCommand =
                        "-y -i ${videoFile.path} -vf vidstabdetect=shakiness=10:accuracy=15:result=${shakeResultsFile.path} -f null -";

                    showStabilizeProgressDialog();

                    executeAsyncFFmpeg(analyzeVideoCommand,
                        (CompletedFFmpegExecution secondExecution) {
                      ffprint(
                          "FFmpeg process exited with rc ${secondExecution.returnCode}.");

                      final String stabilizeVideoCommand =
                          "-y -i ${videoFile.path} -vf vidstabtransform=smoothing=30:input=${shakeResultsFile.path} -c:v mpeg4 ${stabilizedVideoFile.path}";

                      //@TODO check return code before starting the third execution

                      executeAsyncFFmpeg(stabilizeVideoCommand,
                          (CompletedFFmpegExecution thirdExecution) {
                        hideProgressDialog();

                        if (thirdExecution.returnCode == 0) {
                          ffprint(
                              "Stabilize video completed successfully; playing videos.");
                          playVideo();
                          playStabilizedVideo();
                        } else {
                          showPopup(
                              "Stabilize video failed. Please check log for the details.");
                          ffprint(
                              "Stabilize video failed with rc=${thirdExecution.returnCode}.");
                        }
                      }).then((executionId) {
                        ffprint(
                            "Async FFmpeg process started with arguments '$stabilizeVideoCommand' and executionId $executionId.");
                      });
                    }).then((executionId) {
                      ffprint(
                          "Async FFmpeg process started with arguments '$analyzeVideoCommand' and executionId $executionId.");
                    });
                  }
                }).then((executionId) {
                  ffprint(
                      "Async FFmpeg process started with arguments '$ffmpegCommand' and executionId $executionId.");
                });
              });
            });
          });
        });
      });
    });
  }

  Future<void> playVideo() async {
    if (videoController._controller != null) {
      await videoController._controller!.initialize();
      await videoController._controller!.play();
    }
    _refreshablePlayerDialogFactory.refresh();
  }

  Future<void> pauseVideo() async {
    if (videoController._controller != null) {
      await videoController._controller!.pause();
    }
    _refreshablePlayerDialogFactory.refresh();
  }

  Future<void> playStabilizedVideo() async {
    if (stabilizedVideoController._controller != null) {
      await stabilizedVideoController._controller!.initialize();
      await stabilizedVideoController._controller!.play();
    }
    _refreshablePlayerDialogFactory.refresh();
  }

  Future<void> pauseStabilizedVideo() async {
    if (stabilizedVideoController._controller != null) {
      await stabilizedVideoController._controller!.pause();
    }
    _refreshablePlayerDialogFactory.refresh();
  }

  Future<File> getShakeResultsFile() async {
    final String subtitle = "transforms.trf";
    Directory documentsDirectory = await VideoUtil.tempDirectory;
    return new File("${documentsDirectory.path}/$subtitle");
  }

  Future<File> getVideoFile() async {
    final String video = "video-shaking.mp4";
    Directory documentsDirectory = await VideoUtil.documentsDirectory;
    return new File("${documentsDirectory.path}/$video");
  }

  Future<File> getStabilizedVideoFile() async {
    final String video = "video-stabilized.mp4";
    Directory documentsDirectory = await VideoUtil.documentsDirectory;
    return new File("${documentsDirectory.path}/$video");
  }

  void showCreateProgressDialog() {
    _refreshablePlayerDialogFactory.dialogShow("Creating video");
  }

  void showStabilizeProgressDialog() {
    _refreshablePlayerDialogFactory.dialogShow("Stabilizing video");
  }

  void hideProgressDialog() {
    _refreshablePlayerDialogFactory.dialogHide();
  }
}
