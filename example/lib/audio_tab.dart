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
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/completed_ffmpeg_execution.dart';
import 'package:flutter_ffmpeg/log.dart';
import 'package:flutter_ffmpeg_example/abstract.dart';
import 'package:flutter_ffmpeg_example/flutter_ffmpeg_api_wrapper.dart';
import 'package:flutter_ffmpeg_example/popup.dart';
import 'package:flutter_ffmpeg_example/test_api.dart';
import 'package:flutter_ffmpeg_example/tooltip.dart';
import 'package:flutter_ffmpeg_example/video_util.dart';

import 'util.dart';

class AudioTab {
  late RefreshablePlayerDialogFactory _refreshablePlayerDialogFactory;
  String? _selectedCodec;
  String _outputText = '';

  void init(RefreshablePlayerDialogFactory refreshablePlayerDialogFactory) {
    _refreshablePlayerDialogFactory = refreshablePlayerDialogFactory;
    List<DropdownMenuItem<String>> videoCodecList = getAudioCodecList();
    _selectedCodec = videoCodecList[0].value;
    clearLog();
  }

  void setActive() {
    print("Audio Tab Activated");
    enableLogCallback(null);
    _createAudioSample();
    enableStatisticsCallback(null);
    showPopup(AUDIO_TEST_TOOLTIP_TEXT);
  }

  void logCallback(Log log) {
    appendLog(log.message);
    _refreshablePlayerDialogFactory.refresh();
  }

  void appendLog(String logMessage) {
    _outputText += logMessage;
  }

  void clearLog() {
    _outputText = '';
  }

  void changedAudioCodec(String? selectedCodec) {
    _selectedCodec = selectedCodec;
    _refreshablePlayerDialogFactory.refresh();
  }

  void encodeAudio() {
    getAudioOutputFile().then((audioOutputFile) {
      try {
        audioOutputFile.delete().catchError((_) {});
      } on Exception catch (_) {}

      final String? audioCodec = _selectedCodec;

      ffprint("Testing AUDIO encoding with '$audioCodec' codec");

      generateAudioEncodeScript().then((ffmpegCommand) {
        showProgressDialog();

        clearLog();

        executeAsyncFFmpeg(ffmpegCommand, (CompletedFFmpegExecution execution) {
          hideProgressDialog();

          if (execution.returnCode == 0) {
            showPopup("Encode completed successfully.");
            ffprint("Encode completed successfully.");
          } else {
            showPopup("Encode failed. Please check log for the details.");
            ffprint("Encode failed with rc=${execution.returnCode}.");
          }

          ffprint("Testing post execution commands.");
          Test.testPostExecutionCommands();
        }).then((executionId) {
          ffprint(
              "Async FFmpeg process started with arguments '$ffmpegCommand' and executionId $executionId.");
        });
      });
    });
  }

  void _createAudioSample() {
    getAudioSampleFile().then((audioSampleFile) {
      ffprint("Creating AUDIO sample before the test.");

      try {
        audioSampleFile.delete().catchError((_) {});
      } on Exception catch (_) {}

      String ffmpegCommand =
          "-hide_banner -y -f lavfi -i sine=frequency=1000:duration=5 -c:a pcm_s16le ${audioSampleFile.path}";

      ffprint("Creating audio sample with '$ffmpegCommand'.");

      executeFFmpeg(ffmpegCommand).then((result) {
        if (result == 0) {
          ffprint("AUDIO sample created");
        } else {
          ffprint("Creating AUDIO sample failed with rc=$result.");
          showPopup(
              "Creating AUDIO sample failed. Please check log for the details.");
        }
        enableLogCallback(logCallback);
      });
    });
  }

  Future<File> getAudioOutputFile() async {
    String? audioCodec = _selectedCodec;

    String extension;
    switch (audioCodec) {
      case "mp2 (twolame)":
        extension = "mpg";
        break;
      case "mp3 (liblame)":
      case "mp3 (libshine)":
        extension = "mp3";
        break;
      case "vorbis":
        extension = "ogg";
        break;
      case "opus":
        extension = "opus";
        break;
      case "amr-nb":
        extension = "amr";
        break;
      case "amr-wb":
        extension = "amr";
        break;
      case "ilbc":
        extension = "lbc";
        break;
      case "speex":
        extension = "spx";
        break;
      case "wavpack":
        extension = "wv";
        break;
      default:
        // soxr
        extension = "wav";
        break;
    }

    final String audio = "audio." + extension;
    Directory documentsDirectory = await VideoUtil.documentsDirectory;
    return new File("${documentsDirectory.path}/$audio");
  }

  Future<File> getAudioSampleFile() async {
    Directory documentsDirectory = await VideoUtil.documentsDirectory;
    return new File("${documentsDirectory.path}/audio-sample.wav");
  }

  void showProgressDialog() {
    _refreshablePlayerDialogFactory.dialogShow("Encoding audio");
  }

  void hideProgressDialog() {
    _refreshablePlayerDialogFactory.dialogHide();
  }

  Future<String> generateAudioEncodeScript() async {
    String? audioCodec = _selectedCodec;
    String audioSampleFile = (await getAudioSampleFile()).path;
    String audioOutputFile = (await getAudioOutputFile()).path;

    switch (audioCodec) {
      case "mp2 (twolame)":
        return "-hide_banner -y -i $audioSampleFile -c:a mp2 -b:a 192k $audioOutputFile";
      case "mp3 (liblame)":
        return "-hide_banner -y -i $audioSampleFile -c:a libmp3lame -qscale:a 2 $audioOutputFile";
      case "mp3 (libshine)":
        return "-hide_banner -y -i $audioSampleFile -c:a libshine -qscale:a 2 $audioOutputFile";
      case "vorbis":
        return "-hide_banner -y -i $audioSampleFile -c:a libvorbis -b:a 64k $audioOutputFile";
      case "opus":
        return "-hide_banner -y -i $audioSampleFile -c:a libopus -b:a 64k -vbr on -compression_level 10 $audioOutputFile";
      case "amr-nb":
        return "-hide_banner -y -i $audioSampleFile -ar 8000 -ab 12.2k -c:a libopencore_amrnb $audioOutputFile";
      case "amr-wb":
        return "-hide_banner -y -i $audioSampleFile -ar 8000 -ab 12.2k -c:a libvo_amrwbenc -strict experimental $audioOutputFile";
      case "ilbc":
        return "-hide_banner -y -i $audioSampleFile -c:a ilbc -ar 8000 -b:a 15200 $audioOutputFile";
      case "speex":
        return "-hide_banner -y -i $audioSampleFile -c:a libspeex -ar 16000 $audioOutputFile";
      case "wavpack":
        return "-hide_banner -y -i $audioSampleFile -c:a wavpack -b:a 64k $audioOutputFile";
      default:
        // soxr
        return "-hide_banner -y -i $audioSampleFile -af aresample=resampler=soxr -ar 44100 $audioOutputFile";
    }
  }

  List<DropdownMenuItem<String>> getAudioCodecList() {
    List<DropdownMenuItem<String>> list;

    list = [
      new DropdownMenuItem(
          value: "mp2 (twolame)",
          child: SizedBox(
              width: 100, child: Center(child: new Text("mp2 (twolame)"))))
    ];
    list.add(new DropdownMenuItem(
        value: "mp3 (liblame)",
        child: SizedBox(
            width: 100, child: Center(child: new Text("mp3 (liblame)")))));
    list.add(new DropdownMenuItem(
        value: "mp3 (libshine)",
        child: SizedBox(
            width: 100, child: Center(child: new Text("mp3 (libshine)")))));
    list.add(new DropdownMenuItem(
        value: "vorbis",
        child: SizedBox(width: 100, child: Center(child: new Text("vorbis")))));
    list.add(new DropdownMenuItem(
        value: "opus",
        child: SizedBox(width: 100, child: Center(child: new Text("opus")))));
    list.add(new DropdownMenuItem(
        value: "amr-nb",
        child: SizedBox(width: 100, child: Center(child: new Text("amr-nb")))));
    list.add(new DropdownMenuItem(
        value: "amr-wb",
        child: SizedBox(width: 100, child: Center(child: new Text("amr-wb")))));
    list.add(new DropdownMenuItem(
        value: "ilbc",
        child: SizedBox(width: 100, child: Center(child: new Text("ilbc")))));
    list.add(new DropdownMenuItem(
        value: "soxr",
        child: SizedBox(width: 100, child: Center(child: new Text("soxr")))));
    list.add(new DropdownMenuItem(
        value: "speex",
        child: SizedBox(width: 100, child: Center(child: new Text("speex")))));
    list.add(new DropdownMenuItem(
        value: "wavpack",
        child:
            SizedBox(width: 100, child: Center(child: new Text("wavpack")))));

    return list;
  }

  String getOutputText() => _outputText;

  String? getSelectedCodec() => _selectedCodec;
}
