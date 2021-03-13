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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg_example/decoration.dart';
import 'package:video_player/video_player.dart';

class PlayerTab {
  void setController(VideoPlayerController controller) {}
}

class EmbeddedPlayer extends StatefulWidget {
  final String _filePath;
  final PlayerTab _playerTab;

  EmbeddedPlayer(this._filePath, this._playerTab);

  @override
  _EmbeddedPlayerState createState() =>
      _EmbeddedPlayerState(new File(_filePath), _playerTab);
}

class _EmbeddedPlayerState extends State<EmbeddedPlayer> {
  final PlayerTab _playerTab;
  final File _file;
  late VideoPlayerController _videoPlayerController;
  bool startedPlaying = false;

  _EmbeddedPlayerState(this._file, this._playerTab);

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.file(_file);
    _playerTab.setController(_videoPlayerController);
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 0,
        child: Center(
          child: FutureBuilder<bool>(
            future: Future.value(_videoPlayerController.value.isInitialized),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.data == true) {
                return Container(
                  alignment: Alignment(0.0, 0.0),
                  child: VideoPlayer(_videoPlayerController),
                );
              } else {
                return Container(
                  alignment: Alignment(0.0, 0.0),
                  decoration: videoPlayerFrameDecoration,
                );
              }
            },
          ),
        ));
  }
}
