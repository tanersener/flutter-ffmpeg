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

import io.flutter.plugin.common.MethodChannel;

public class FlutterFFmpegExecuteAsyncCommandTask extends AsyncTask<String, Integer, Integer> {

    private String delimiter;
    private final MethodChannel.Result result;

    FlutterFFmpegExecuteAsyncCommandTask(final String delimiter, final MethodChannel.Result result) {
        if (delimiter == null) {
            this.delimiter = " ";
        } else {
            this.delimiter = delimiter;
        }

        this.result = result;
    }

    @Override
    protected Integer doInBackground(final String... strings) {
        int rc = -1;

        if ((strings != null) && (strings.length > 0)) {
            final String command = strings[0];

            Log.d(FlutterFFmpegPlugin.LIBRARY_NAME, String.format("Running FFmpeg command: %s with delimiter %s.", command, delimiter));

            rc = FFmpeg.execute(command, delimiter);

            Log.d(FlutterFFmpegPlugin.LIBRARY_NAME, String.format("FFmpeg exited with rc: %d", rc));
        }

        return rc;
    }

    @Override
    protected void onPostExecute(final Integer rc) {
        result.success(FlutterFFmpegPlugin.toIntMap(FlutterFFmpegPlugin.KEY_RC, rc));
    }

}
