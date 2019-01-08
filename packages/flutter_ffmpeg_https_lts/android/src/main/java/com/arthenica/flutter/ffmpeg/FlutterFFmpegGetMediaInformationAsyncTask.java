/*
 * Copyright (c) 2019 Taner Sener
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

package com.arthenica.flutter.ffmpeg;

import android.os.AsyncTask;
import android.util.Log;

import com.arthenica.mobileffmpeg.FFmpeg;
import com.arthenica.mobileffmpeg.MediaInformation;

import io.flutter.plugin.common.MethodChannel;

/**
 * Asynchronous task which performs {@link FFmpeg#getMediaInformation(String, Long)} method invocations.
 *
 * @author Taner Sener
 * @since 0.1.0
 */
public class FlutterFFmpegGetMediaInformationAsyncTask extends AsyncTask<String, Integer, MediaInformation> {

    private Integer timeout;
    private final MethodChannel.Result result;

    FlutterFFmpegGetMediaInformationAsyncTask(final Integer timeout, final MethodChannel.Result result) {
        this.timeout = timeout;
        this.result = result;
    }

    @Override
    protected MediaInformation doInBackground(final String... strings) {
        MediaInformation mediaInformation = null;

        if ((strings != null) && (strings.length > 0)) {
            final String path = strings[0];

            if (timeout == null) {
                Log.d(FlutterFFmpegPlugin.LIBRARY_NAME, String.format("Getting media information for %s", path));
                mediaInformation = FFmpeg.getMediaInformation(path);
            } else {
                Log.d(FlutterFFmpegPlugin.LIBRARY_NAME, String.format("Getting media information for %s with timeout %d.", path, timeout.longValue()));
                mediaInformation = FFmpeg.getMediaInformation(path, timeout.longValue());
            }
        }

        return mediaInformation;
    }

    @Override
    protected void onPostExecute(final MediaInformation mediaInformation) {
        result.success(FlutterFFmpegPlugin.toMediaInformationMap(mediaInformation));
    }

}
