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

  late Refreshable _refreshable;
  late TextEditingController _urlText;
  String _outputText = '';

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
    _outputText = '';
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
        ffprint("---");
        if (information.getMediaProperties()!.containsKey('filename')) {
          ffprint('Path: ${information.getMediaProperties()!['filename']}');
        }
        if (information.getMediaProperties()!.containsKey('format_name')) {
          ffprint(
              "Format: " + information.getMediaProperties()!['format_name']);
        }
        if (information.getMediaProperties()!.containsKey('bit_rate')) {
          ffprint("Bitrate: " + information.getMediaProperties()!['bit_rate']);
        }
        if (information.getMediaProperties()!.containsKey('duration')) {
          ffprint("Duration: " + information.getMediaProperties()!['duration']);
        }
        if (information.getMediaProperties()!.containsKey('start_time')) {
          ffprint(
              "Start time: " + information.getMediaProperties()!['start_time']);
        }
        if (information.getMediaProperties()!.containsKey('nb_streams')) {
          ffprint("Number of streams: " +
              information.getMediaProperties()!['nb_streams'].toString());
        }
        Map<dynamic, dynamic>? tags = information.getMediaProperties()!['tags'];
        if (tags != null) {
          tags.forEach((key, value) {
            ffprint("Tag: " + key + ":" + value);
          });
        }

        List<StreamInformation> streams = information.getStreams();
        if (streams.isNotEmpty) {
          for (var i = 0; i < streams.length; ++i) {
            StreamInformation stream = streams[i];
            ffprint("---");
            if (stream.getAllProperties().containsKey('index')) {
              ffprint("Stream index: " +
                  stream.getAllProperties()['index'].toString());
            }
            if (stream.getAllProperties().containsKey('codec_type')) {
              ffprint(
                  "Stream type: " + stream.getAllProperties()['codec_type']);
            }
            if (stream.getAllProperties().containsKey('codec_name')) {
              ffprint(
                  "Stream codec: " + stream.getAllProperties()['codec_name']);
            }
            if (stream.getAllProperties().containsKey('codec_long_name')) {
              ffprint("Stream full codec: " +
                  stream.getAllProperties()['codec_long_name']);
            }
            if (stream.getAllProperties().containsKey('pix_fmt')) {
              ffprint("Stream format: " + stream.getAllProperties()['pix_fmt']);
            }
            if (stream.getAllProperties().containsKey('width')) {
              ffprint("Stream width: " +
                  stream.getAllProperties()['width'].toString());
            }
            if (stream.getAllProperties().containsKey('height')) {
              ffprint("Stream height: " +
                  stream.getAllProperties()['height'].toString());
            }
            if (stream.getAllProperties().containsKey('bit_rate')) {
              ffprint(
                  "Stream bitrate: " + stream.getAllProperties()['bit_rate']);
            }
            if (stream.getAllProperties().containsKey('sample_rate')) {
              ffprint("Stream sample rate: " +
                  stream.getAllProperties()['sample_rate']);
            }
            if (stream.getAllProperties().containsKey('sample_fmt')) {
              ffprint("Stream sample format: " +
                  stream.getAllProperties()['sample_fmt']);
            }
            if (stream.getAllProperties().containsKey('channel_layout')) {
              ffprint("Stream channel layout: " +
                  stream.getAllProperties()['channel_layout']);
            }
            if (stream.getAllProperties().containsKey('sample_aspect_ratio')) {
              ffprint("Stream sample aspect ratio: " +
                  stream.getAllProperties()['sample_aspect_ratio']);
            }
            if (stream.getAllProperties().containsKey('display_aspect_ratio')) {
              ffprint("Stream display aspect ratio: " +
                  stream.getAllProperties()['display_aspect_ratio']);
            }
            if (stream.getAllProperties().containsKey('avg_frame_rate')) {
              ffprint("Stream average frame rate: " +
                  stream.getAllProperties()['avg_frame_rate']);
            }
            if (stream.getAllProperties().containsKey('r_frame_rate')) {
              ffprint("Stream real frame rate: " +
                  stream.getAllProperties()['r_frame_rate']);
            }
            if (stream.getAllProperties().containsKey('time_base')) {
              ffprint("Stream time base: " +
                  stream.getAllProperties()['time_base']);
            }
            if (stream.getAllProperties().containsKey('codec_time_base')) {
              ffprint("Stream codec time base: " +
                  stream.getAllProperties()['codec_time_base']);
            }

            Map<dynamic, dynamic>? tags = stream.getAllProperties()['tags'];
            if (tags != null) {
              tags.forEach((key, value) {
                ffprint("Stream tag: " + key + ":" + value);
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
