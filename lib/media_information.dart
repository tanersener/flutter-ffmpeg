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

import 'package:flutter_ffmpeg/stream_information.dart';
import 'package:flutter_ffmpeg/chapter.dart';

class MediaInformation {
  Map<dynamic, dynamic>? _allProperties;

  /// Creates a new [MediaInformation] instance
  MediaInformation(this._allProperties);

  /// Returns all streams
  List<StreamInformation>? getStreams() {
    List<StreamInformation> list =
        List<StreamInformation>.empty(growable: true);
    var streamList;

    if (_allProperties == null) {
      streamList = List.empty(growable: true);
    } else {
      streamList = _allProperties!["streams"];
    }

    if (streamList != null) {
      streamList.forEach((element) {
        list.add(new StreamInformation(element));
      });
    }

    return list;
  }

  /// Returns all chapters
  List<Chapter>? getChapters() {
    List<Chapter> list = List<Chapter>.empty(growable: true);
    var chapters;

    if (_allProperties == null) {
      chapters = List.empty(growable: true);
    } else {
      if (_allProperties!["chapters"] != null) {
        chapters = <Chapter>[];
        _allProperties!['chapters'].forEach((chapter) {
          int id = chapter['id'];
          String timeBase = chapter['time_base'];
          int start = chapter['start'];
          int end = chapter['end'];
          String startTime = chapter['start_time'];
          String endTime = chapter['end_time'];
          Tags? tags;
          if (chapter['tags'] != null) {
            tags = Tags(chapter['tags']['title'] ?? "");
          }
          chapters.add(
              new Chapter(id, timeBase, start, end, startTime, endTime, tags));
        });
      }
    }

    if (chapters != null) {
      list.addAll(chapters);
    }

    return list;
  }

  /// Returns all media properties in a map or null if no media properties are found
  Map<dynamic, dynamic>? getMediaProperties() {
    if (_allProperties == null) {
      return Map();
    } else {
      return _allProperties!["format"];
    }
  }

  /// Returns all properties in a map or null if no properties are found
  Map<dynamic, dynamic> getAllProperties() {
    return _allProperties!;
  }
}
