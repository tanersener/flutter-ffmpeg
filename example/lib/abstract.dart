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

class Refreshable {
  void refresh() {}
}

class DialogFactory {
  void dialogShow(String message) {}

  void dialogShowCancellable(String message, Function cancelFunction) {}

  void dialogUpdate(String message) {}

  void dialogHide() {}
}

class RefreshablePlayerDialogFactory implements Refreshable, DialogFactory {
  @override
  void dialogHide() {}

  @override
  void dialogUpdate(String message) {}

  @override
  void refresh() {}

  @override
  void dialogShow(String message) {}

  @override
  void dialogShowCancellable(String message, Function cancelFunction) {}
}
