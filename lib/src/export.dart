/*
---------------------------------------------------------------------------
Open Asset Import Library (assimp)
---------------------------------------------------------------------------

Copyright (c) 2006-2019, assimp team



All rights reserved.

Redistribution and use of this software in source and binary forms,
with or without modification, are permitted provided that the following
conditions are met:

* Redistributions of source code must retain the above
  copyright notice, this list of conditions and the
  following disclaimer.

* Redistributions in binary form must reproduce the above
  copyright notice, this list of conditions and the
  following disclaimer in the documentation and/or other
  materials provided with the distribution.

* Neither the name of the assimp team, nor the names of its
  contributors may be used to endorse or promote products
  derived from this software without specific prior
  written permission of the assimp team.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
---------------------------------------------------------------------------
*/

import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:meta/meta.dart';

import 'bindings.dart';
import 'extensions.dart';
import 'libassimp.dart';
import 'scene.dart';
import 'type.dart';

/// Describes an file format which Assimp can export to. Use #aiGetExportFormatCount() to
/// learn how many export formats the current Assimp build supports and #aiGetExportFormatDescription()
/// to retrieve a description of an export format option.
class ExportFormat extends AssimpType<aiExportFormatDesc> {
  aiExportFormatDesc get _desc => ptr.ref;

  ExportFormat._(Pointer<aiExportFormatDesc> ptr) : super(ptr);
  factory ExportFormat.fromNative(Pointer<aiExportFormatDesc> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return ExportFormat._(ptr);
  }

  /// a short string ID to uniquely identify the export format. Use this ID string to
  /// specify which file format you want to export to when calling #aiExportScene().
  /// Example: "dae" or "obj"
  String get id => Utf8.fromUtf8(_desc.id);

  /// A short description of the file format to present to users. Useful if you want
  /// to allow the user to select an export format.
  String get description => Utf8.fromUtf8(_desc.description);

  /// Recommended file extension for the exported file in lower case.
  String get extension => Utf8.fromUtf8(_desc.fileExtension);

  /// Release a description of the nth export file format. Must be returned by
  /// aiGetExportFormatDescription
  /// @param desc Pointer to the description
  void dispose() => aiReleaseExportFormatDescription(ptr);
}

extension SceneExport on Scene {
  /// Exports the given scene to a chosen file format and writes the result file(s) to disk.
  /// @param pScene The scene to export. Stays in possession of the caller, is not changed by the function.
  ///   The scene is expected to conform to Assimp's Importer output format as specified
  ///   in the @link data Data Structures Page @endlink. In short, this means the model data
  ///   should use a right-handed coordinate systems, face winding should be counter-clockwise
  ///   and the UV coordinate origin is assumed to be in the upper left. If your input data
  ///   uses different conventions, have a look at the last parameter.
  /// @param pFormatId ID string to specify to which format you want to export to. Use
  /// aiGetExportFormatCount() / aiGetExportFormatDescription() to learn which export formats are available.
  /// @param pFileName Output file to write
  /// @param pPreprocessing Accepts any choice of the #aiPostProcessSteps enumerated
  ///   flags, but in reality only a subset of them makes sense here. Specifying
  ///   'preprocessing' flags is useful if the input scene does not conform to
  ///   Assimp's default conventions as specified in the @link data Data Structures Page @endlink.
  ///   In short, this means the geometry data should use a right-handed coordinate systems, face
  ///   winding should be counter-clockwise and the UV coordinate origin is assumed to be in
  ///   the upper left. The #aiProcess_MakeLeftHanded, #aiProcess_FlipUVs and
  ///   #aiProcess_FlipWindingOrder flags are used in the import side to allow users
  ///   to have those defaults automatically adapted to their conventions. Specifying those flags
  ///   for exporting has the opposite effect, respectively. Some other of the
  ///   #aiPostProcessSteps enumerated values may be useful as well, but you'll need
  ///   to try out what their effect on the exported file is. Many formats impose
  ///   their own restrictions on the structure of the geometry stored therein,
  ///   so some preprocessing may have little or no effect at all, or may be
  ///   redundant as exporters would apply them anyhow. A good example
  ///   is triangulation - whilst you can enforce it by specifying
  ///   the #aiProcess_Triangulate flag, most export formats support only
  ///   triangulate data so they would run the step anyway.
  ///
  ///   If assimp detects that the input scene was directly taken from the importer side of
  ///   the library (i.e. not copied using aiCopyScene and potetially modified afterwards),
  ///   any postprocessing steps already applied to the scene will not be applied again, unless
  ///   they show non-idempotent behaviour (#aiProcess_MakeLeftHanded, #aiProcess_FlipUVs and
  ///   #aiProcess_FlipWindingOrder).
  /// @return a status code indicating the result of the export
  /// @note Use aiCopyScene() to get a modifiable copy of a previously
  ///   imported scene.
  bool exportFile(String path, {@required String format, int flags = 0}) {
    Pointer<Utf8> cpath = Utf8.toUtf8(path);
    Pointer<Utf8> cformat = Utf8.toUtf8(format);
    int res = aiExportScene(ptr, cformat, cpath, flags);
    free(cpath);
    free(cformat);
    return res == 0;
  }
}
