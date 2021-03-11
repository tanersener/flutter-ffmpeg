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
  String _outputText = "";

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
        ffprint("---");
        Map<dynamic, dynamic> mediaProperties =
            information.getMediaProperties()!;
        if (mediaProperties.containsKey('filename')) {
          ffprint('Path: ${mediaProperties['filename']}');
        }
        if (mediaProperties.containsKey('format_name')) {
          ffprint("Format: " + mediaProperties['format_name']);
        }
        if (mediaProperties.containsKey('bit_rate')) {
          ffprint("Bitrate: " + mediaProperties['bit_rate']);
        }
        if (mediaProperties.containsKey('duration')) {
          ffprint("Duration: " + mediaProperties['duration']);
        }
        if (mediaProperties.containsKey('start_time')) {
          ffprint("Start time: " + mediaProperties['start_time']);
        }
        if (mediaProperties.containsKey('nb_streams')) {
          ffprint(
              "Number of streams: " + mediaProperties['nb_streams'].toString());
        }
        Map<dynamic, dynamic>? tags = mediaProperties['tags'];
        if (tags != null) {
          tags.forEach((key, value) {
            ffprint("Tag: " + key + ":" + value);
          });
        }

        List<StreamInformation>? streams = information.getStreams();
        if (streams != null) {
          for (var i = 0; i < streams.length; ++i) {
            StreamInformation stream = streams[i];
            ffprint("---");
            Map<dynamic, dynamic> streamProperties = stream.getAllProperties();
            if (streamProperties.containsKey('index')) {
              ffprint("Stream index: " + streamProperties['index'].toString());
            }
            if (streamProperties.containsKey('codec_type')) {
              ffprint("Stream type: " + streamProperties['codec_type']);
            }
            if (streamProperties.containsKey('codec_name')) {
              ffprint("Stream codec: " + streamProperties['codec_name']);
            }
            if (streamProperties.containsKey('codec_long_name')) {
              ffprint(
                  "Stream full codec: " + streamProperties['codec_long_name']);
            }
            if (streamProperties.containsKey('pix_fmt')) {
              ffprint("Stream format: " + streamProperties['pix_fmt']);
            }
            if (streamProperties.containsKey('width')) {
              ffprint("Stream width: " + streamProperties['width'].toString());
            }
            if (streamProperties.containsKey('height')) {
              ffprint(
                  "Stream height: " + streamProperties['height'].toString());
            }
            if (streamProperties.containsKey('bit_rate')) {
              ffprint("Stream bitrate: " + streamProperties['bit_rate']);
            }
            if (streamProperties.containsKey('sample_rate')) {
              ffprint("Stream sample rate: " + streamProperties['sample_rate']);
            }
            if (streamProperties.containsKey('sample_fmt')) {
              ffprint(
                  "Stream sample format: " + streamProperties['sample_fmt']);
            }
            if (streamProperties.containsKey('channel_layout')) {
              ffprint("Stream channel layout: " +
                  streamProperties['channel_layout']);
            }
            if (streamProperties.containsKey('sample_aspect_ratio')) {
              ffprint("Stream sample aspect ratio: " +
                  streamProperties['sample_aspect_ratio']);
            }
            if (streamProperties.containsKey('display_aspect_ratio')) {
              ffprint("Stream display aspect ratio: " +
                  streamProperties['display_aspect_ratio']);
            }
            if (streamProperties.containsKey('avg_frame_rate')) {
              ffprint("Stream average frame rate: " +
                  streamProperties['avg_frame_rate']);
            }
            if (streamProperties.containsKey('r_frame_rate')) {
              ffprint("Stream real frame rate: " +
                  streamProperties['r_frame_rate']);
            }
            if (streamProperties.containsKey('time_base')) {
              ffprint("Stream time base: " + streamProperties['time_base']);
            }
            if (streamProperties.containsKey('codec_time_base')) {
              ffprint("Stream codec time base: " +
                  streamProperties['codec_time_base']);
            }

            Map<dynamic, dynamic>? tags = streamProperties['tags'];
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
