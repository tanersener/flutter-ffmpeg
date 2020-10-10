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
import 'package:flutter_ffmpeg/stream_information.dart';
import 'package:flutter_ffmpeg_example/abstract.dart';
import 'package:flutter_ffmpeg_example/popup.dart';
import 'package:flutter_ffmpeg_example/tooltip.dart';

import 'flutter_ffmpeg_api_wrapper.dart';
import 'util.dart';

class HttpsTab {
  static const String HTTPS_TEST_DEFAULT_URL =
      "https://download.blender.org/peach/trailer/trailer_1080p.ogg";

  Refreshable _refreshable;
  TextEditingController _urlText;
  String _outputText;

  void init(Refreshable refreshable) {
    _refreshable = refreshable;
    _urlText = TextEditingController();
    clearLog();
  }

  void setActive() {
    print("Https Tab Activated");
    enableLogCallback(logCallback);
    enableStatisticsCallback(null);
    showPopup(HTTPS_TEST_TOOLTIP_TEXT);
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

  void runGetMediaInformation() {
    clearLog();

    String testUrl = _urlText.text;
    if (testUrl.isEmpty) {
      testUrl = HTTPS_TEST_DEFAULT_URL;
      _urlText.text = testUrl;
      ffprint(
        "Testing HTTPS with default url '$testUrl'.",
      );
    } else {
      ffprint("Testing HTTPS with url '$testUrl'.");
    }

    // HTTPS COMMAND ARGUMENTS
    getMediaInformation(testUrl).then((information) {
      if (information.getMediaProperties() != null) {
        appendLog(
            'Media information for ${information.getMediaProperties()['filename']}\n');

        if (information.getMediaProperties().containsKey('format_name')) {
          appendLog("Format: " +
              information.getMediaProperties()['format_name'] +
              "\n");
        }
        if (information.getMediaProperties().containsKey('bit_rate')) {
          appendLog("Bitrate: " +
              information.getMediaProperties()['bit_rate'] +
              "\n");
        }
        if (information.getMediaProperties().containsKey('duration')) {
          appendLog("Duration: " +
              information.getMediaProperties()['duration'] +
              "\n");
        }
        if (information.getMediaProperties().containsKey('start_time')) {
          appendLog("Start time: " +
              information.getMediaProperties()['start_time'] +
              "\n");
        }
        Map<dynamic, dynamic> tags = information.getMediaProperties()['tags'];
        if (tags != null) {
          tags.forEach((key, value) {
            appendLog("Tag: " + key + ":" + value + "\n");
          });
        }

        List<StreamInformation> streams = information.getStreams();
        if (streams != null) {
          for (var i = 0; i < streams.length; ++i) {
            StreamInformation stream = streams[i];

            if (stream.getAllProperties().containsKey('index')) {
              appendLog("Stream index: " +
                  stream.getAllProperties()['index'].toString() +
                  "\n");
            }
            if (stream.getAllProperties().containsKey('codec_type')) {
              appendLog("Stream type: " +
                  stream.getAllProperties()['codec_type'] +
                  "\n");
            }
            if (stream.getAllProperties().containsKey('codec_name')) {
              appendLog("Stream codec: " +
                  stream.getAllProperties()['codec_name'] +
                  "\n");
            }
            if (stream.getAllProperties().containsKey('codec_long_name')) {
              appendLog("Stream full codec: " +
                  stream.getAllProperties()['codec_long_name'] +
                  "\n");
            }
            if (stream.getAllProperties().containsKey('pix_fmt')) {
              appendLog("Stream format: " +
                  stream.getAllProperties()['pix_fmt'] +
                  "\n");
            }

            if (stream.getAllProperties().containsKey('width')) {
              appendLog("Stream width: " +
                  stream.getAllProperties()['width'].toString() +
                  "\n");
            }
            if (stream.getAllProperties().containsKey('height')) {
              appendLog("Stream height: " +
                  stream.getAllProperties()['height'].toString() +
                  "\n");
            }

            if (stream.getAllProperties().containsKey('bit_rate')) {
              appendLog("Stream bitrate: " +
                  stream.getAllProperties()['bit_rate'] +
                  "\n");
            }
            if (stream.getAllProperties().containsKey('sample_rate')) {
              appendLog("Stream sample rate: " +
                  stream.getAllProperties()['sample_rate'] +
                  "\n");
            }
            if (stream.getAllProperties().containsKey('sample_fmt')) {
              appendLog("Stream sample format: " +
                  stream.getAllProperties()['sample_fmt'] +
                  "\n");
            }
            if (stream.getAllProperties().containsKey('channel_layout')) {
              appendLog("Stream channel layout: " +
                  stream.getAllProperties()['channel_layout'] +
                  "\n");
            }

            if (stream.getAllProperties().containsKey('sample_aspect_ratio')) {
              appendLog("Stream sample aspect ratio: " +
                  stream.getAllProperties()['sample_aspect_ratio'] +
                  "\n");
            }
            if (stream.getAllProperties().containsKey('display_aspect_ratio')) {
              appendLog("Stream display aspect ratio: " +
                  stream.getAllProperties()['display_aspect_ratio'] +
                  "\n");
            }
            if (stream.getAllProperties().containsKey('avg_frame_rate')) {
              appendLog("Stream average frame rate: " +
                  stream.getAllProperties()['avg_frame_rate'] +
                  "\n");
            }
            if (stream.getAllProperties().containsKey('r_frame_rate')) {
              appendLog("Stream real frame rate: " +
                  stream.getAllProperties()['r_frame_rate'] +
                  "\n");
            }
            if (stream.getAllProperties().containsKey('time_base')) {
              appendLog("Stream time base: " +
                  stream.getAllProperties()['time_base'] +
                  "\n");
            }
            if (stream.getAllProperties().containsKey('codec_time_base')) {
              appendLog("Stream codec time base: " +
                  stream.getAllProperties()['codec_time_base'] +
                  "\n");
            }

            Map<dynamic, dynamic> tags = stream.getAllProperties()['tags'];
            if (tags != null) {
              tags.forEach((key, value) {
                appendLog("Stream tag: " + key + ":" + value + "\n");
              });
            }
          }
        }
      }
    });
    _refreshable.refresh();
  }

  String getOutputText() => _outputText;

  TextEditingController getUrlText() => _urlText;

  void dispose() {
    _urlText.dispose();
  }
}
