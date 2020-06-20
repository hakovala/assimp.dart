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

import 'ai_file_io.dart';
import 'ai_property_store.dart';
import 'ai_scene.dart';

typedef aiImportFile_t = Pointer<aiScene> Function(
    Pointer<Utf8> file, Uint32 flags);
typedef aiImportFile_f = Pointer<aiScene> Function(
    Pointer<Utf8> file, int flags);

typedef aiImportFileEx_t = Pointer<aiScene> Function(
    Pointer<Utf8> file, Uint32 flags, Pointer<aiFileIO> fs);
typedef aiImportFileEx_f = Pointer<aiScene> Function(
    Pointer<Utf8> file, int flags, Pointer<aiFileIO> fs);

typedef aiImportFileExWithProperties_t = Pointer<aiScene> Function(
    Pointer<Utf8> file,
    Uint32 flags,
    Pointer<aiFileIO> fs,
    Pointer<aiPropertyStore> props);
typedef aiImportFileExWithProperties_f = Pointer<aiScene> Function(
    Pointer<Utf8> file,
    int flags,
    Pointer<aiFileIO> fs,
    Pointer<aiPropertyStore> props);

typedef aiImportFileFromMemory_t = Pointer<aiScene> Function(
    Pointer<Utf8> buffer, Uint32 length, Uint32 flags, Pointer<Utf8> hint);
typedef aiImportFileFromMemory_f = Pointer<aiScene> Function(
    Pointer<Utf8> buffer, int length, int flags, Pointer<Utf8> hint);

typedef aiImportFileFromMemoryWithProperties_t = Pointer<aiScene> Function(
    Pointer<Utf8> buffer,
    Uint32 length,
    Uint32 flags,
    Pointer<Utf8> hint,
    Pointer<aiPropertyStore> props);
typedef aiImportFileFromMemoryWithProperties_f = Pointer<aiScene> Function(
    Pointer<Utf8> buffer,
    int length,
    int flags,
    Pointer<Utf8> hint,
    Pointer<aiPropertyStore> props);

typedef aiReleaseImport_t = Void Function(Pointer<aiScene> scene);
typedef aiReleaseImport_f = void Function(Pointer<aiScene> scene);