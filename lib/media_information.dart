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

class MediaInformation {
  Map<dynamic, dynamic>? _allProperties;

  /// Creates a new [MediaInformation] instance
  MediaInformation(this._allProperties);

  /// Returns all streams
  List<StreamInformation> getStreams() {
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

  /// Returns all media properties in a map or null if no media properties are found
  Map<dynamic, dynamic> getMediaProperties() {
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
