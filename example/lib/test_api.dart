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

import 'package:flutter_ffmpeg/log_level.dart';

import 'flutter_ffmpeg_api_wrapper.dart';
import 'util.dart';

class Test {
  static void testCommonApiMethods() {
    ffprint("Testing common api methods.");

    getFFmpegVersion().then((version) => ffprint("FFmpeg version: $version"));
    getPlatform().then((platform) => ffprint("Platform: $platform"));
    getLogLevel().then(
        (level) => ffprint("Old log level: " + LogLevel.levelToString(level)));
    setLogLevel(LogLevel.AV_LOG_INFO);
    getLogLevel().then(
        (level) => ffprint("New log level: " + LogLevel.levelToString(level)));
    getPackageName()
        .then((packageName) => ffprint("Package name: $packageName"));
    getExternalLibraries().then((packageList) {
      packageList.forEach((value) => ffprint("External library: $value"));
    });
  }

  static void testParseArguments() {
    ffprint("Testing parseArguments.");

    _testParseSimpleCommand();
    _testParseSingleQuotesInCommand();
    _testParseDoubleQuotesInCommand();
    _testParseDoubleQuotesAndEscapesInCommand();
  }

  static void testPostExecutionCommands() {
    getLastCommandOutput()
        .then((output) => ffprint("Last command output: $output"));
    getLastReturnCode()
        .then((returnCode) => ffprint("Last return code: $returnCode"));
    getLastReceivedStatistics().then((statistics) => ffprint(
        "Last received statistics: executionId: ${statistics.executionId}, "
        "video frame number: ${statistics.videoFrameNumber}, video fps: ${statistics.videoFps}, "
        "video quality: ${statistics.videoQuality}, size: ${statistics.size}, time: ${statistics.time}, "
        "bitrate: ${statistics.bitrate}, speed: ${statistics.speed}"));
  }

  static void _testParseSimpleCommand() {
    var argumentArray = parseArguments(
        "-hide_banner   -loop 1  -i file.jpg  -filter_complex  [0:v]setpts=PTS-STARTPTS[video] -map [video] -vsync 2 -async 1  video.mp4");

    assert(argumentArray != null);
    assert(argumentArray!.length == 14);

    assert("-hide_banner" == argumentArray![0]);
    assert("-loop" == argumentArray![1]);
    assert("1" == argumentArray![2]);
    assert("-i" == argumentArray![3]);
    assert("file.jpg" == argumentArray![4]);
    assert("-filter_complex" == argumentArray![5]);
    assert("[0:v]setpts=PTS-STARTPTS[video]" == argumentArray![6]);
    assert("-map" == argumentArray![7]);
    assert("[video]" == argumentArray![8]);
    assert("-vsync" == argumentArray![9]);
    assert("2" == argumentArray![10]);
    assert("-async" == argumentArray![11]);
    assert("1" == argumentArray![12]);
    assert("video.mp4" == argumentArray![13]);
  }

  static void _testParseSingleQuotesInCommand() {
    var argumentArray = parseArguments(
        "-loop 1 'file one.jpg'  -filter_complex  '[0:v]setpts=PTS-STARTPTS[video]'  -map  [video]  video.mp4 ");

    assert(argumentArray != null);
    assert(argumentArray!.length == 8);

    assert("-loop" == argumentArray![0]);
    assert("1" == argumentArray![1]);
    assert("file one.jpg" == argumentArray![2]);
    assert("-filter_complex" == argumentArray![3]);
    assert("[0:v]setpts=PTS-STARTPTS[video]" == argumentArray![4]);
    assert("-map" == argumentArray![5]);
    assert("[video]" == argumentArray![6]);
    assert("video.mp4" == argumentArray![7]);
  }

  static void _testParseDoubleQuotesInCommand() {
    var argumentArray = parseArguments(
        "-loop  1 \"file one.jpg\"   -filter_complex \"[0:v]setpts=PTS-STARTPTS[video]\"  -map  [video]  video.mp4 ");

    assert(argumentArray != null);
    assert(argumentArray!.length == 8);

    assert("-loop" == argumentArray![0]);
    assert("1" == argumentArray![1]);
    assert("file one.jpg" == argumentArray![2]);
    assert("-filter_complex" == argumentArray![3]);
    assert("[0:v]setpts=PTS-STARTPTS[video]" == argumentArray![4]);
    assert("-map" == argumentArray![5]);
    assert("[video]" == argumentArray![6]);
    assert("video.mp4" == argumentArray![7]);

    argumentArray = parseArguments(
        " -i   file:///tmp/input.mp4 -vcodec libx264 -vf \"scale=1024:1024,pad=width=1024:height=1024:x=0:y=0:color=black\"  -acodec copy  -q:v 0  -q:a   0 video.mp4");

    assert(argumentArray != null);
    assert(argumentArray!.length == 13);

    assert("-i" == argumentArray![0]);
    assert("file:///tmp/input.mp4" == argumentArray![1]);
    assert("-vcodec" == argumentArray![2]);
    assert("libx264" == argumentArray![3]);
    assert("-vf" == argumentArray![4]);
    assert("scale=1024:1024,pad=width=1024:height=1024:x=0:y=0:color=black" ==
        argumentArray![5]);
    assert("-acodec" == argumentArray![6]);
    assert("copy" == argumentArray![7]);
    assert("-q:v" == argumentArray![8]);
    assert("0" == argumentArray![9]);
    assert("-q:a" == argumentArray![10]);
    assert("0" == argumentArray![11]);
    assert("video.mp4" == argumentArray![12]);
  }

  static void _testParseDoubleQuotesAndEscapesInCommand() {
    var argumentArray = parseArguments(
        "  -i   file:///tmp/input.mp4 -vf \"subtitles=file:///tmp/subtitles.srt:force_style=\'FontSize=16,PrimaryColour=&HFFFFFF&\'\" -vcodec libx264   -acodec copy  -q:v 0 -q:a  0  video.mp4");

    assert(argumentArray != null);
    assert(argumentArray!.length == 13);

    assert("-i" == argumentArray![0]);
    assert("file:///tmp/input.mp4" == argumentArray![1]);
    assert("-vf" == argumentArray![2]);
    assert(
        "subtitles=file:///tmp/subtitles.srt:force_style='FontSize=16,PrimaryColour=&HFFFFFF&'" ==
            argumentArray![3]);
    assert("-vcodec" == argumentArray![4]);
    assert("libx264" == argumentArray![5]);
    assert("-acodec" == argumentArray![6]);
    assert("copy" == argumentArray![7]);
    assert("-q:v" == argumentArray![8]);
    assert("0" == argumentArray![9]);
    assert("-q:a" == argumentArray![10]);
    assert("0" == argumentArray![11]);
    assert("video.mp4" == argumentArray![12]);

    argumentArray = parseArguments(
        "  -i   file:///tmp/input.mp4 -vf \"subtitles=file:///tmp/subtitles.srt:force_style=\\\"FontSize=16,PrimaryColour=&HFFFFFF&\\\"\" -vcodec libx264   -acodec copy  -q:v 0 -q:a  0  video.mp4");

    assert(argumentArray != null);
    assert(argumentArray!.length == 13);

    assert("-i" == argumentArray![0]);
    assert("file:///tmp/input.mp4" == argumentArray![1]);
    assert("-vf" == argumentArray![2]);
    assert(
        "subtitles=file:///tmp/subtitles.srt:force_style=\\\"FontSize=16,PrimaryColour=&HFFFFFF&\\\"" ==
            argumentArray![3]);
    assert("-vcodec" == argumentArray![4]);
    assert("libx264" == argumentArray![5]);
    assert("-acodec" == argumentArray![6]);
    assert("copy" == argumentArray![7]);
    assert("-q:v" == argumentArray![8]);
    assert("0" == argumentArray![9]);
    assert("-q:a" == argumentArray![10]);
    assert("0" == argumentArray![11]);
    assert("video.mp4" == argumentArray![12]);
  }
}
