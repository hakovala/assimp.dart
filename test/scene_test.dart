/*
---------------------------------------------------------------------------
Open Asset Import Library (assimp)
---------------------------------------------------------------------------

Copyright (c) 2006-2020, assimp team

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

import 'dart:io';
import 'package:path/path.dart' hide equals;
import 'package:test/test.dart';
import 'package:assimp/assimp.dart';

String testFilePath(String fileName) => 'test/models/model-db/' + fileName;

const Matcher isNullPointer = _IsNullPointer();

class _IsNullPointer extends Matcher {
  const _IsNullPointer();
  @override
  bool matches(ptr, Map matchState) => ptr.isNull;
  @override
  Description describe(Description description) => description.add('nullptr');
}

void main() {
  test('null', () {
    Scene scene = Scene.fromNative(null);
    expect(scene.flags, isZero);
    expect(scene.rootNode, isNullPointer);
    expect(scene.meshes, isEmpty);
    expect(scene.materials, isEmpty);
    expect(scene.animations, isEmpty);
    expect(scene.textures, isEmpty);
    expect(scene.lights, isEmpty);
    expect(scene.cameras, isEmpty);
    expect(scene.metaData, isNullPointer);
  });

  void testSceneFromFile(String fileName, void tester(Scene scene)) {
    final filePath = testFilePath(fileName);
    final scene = Scene.fromFile(filePath);
    tester(scene);
    scene.dispose();
  }

  void testSceneFromBytes(String fileName, void tester(Scene scene)) {
    final filePath = testFilePath(fileName);
    final bytes = File(filePath).readAsBytesSync();
    final scene = Scene.fromBytes(bytes, hint: extension(filePath));
    tester(scene);
    scene.dispose();
  }

  void testSceneFromString(String fileName, void tester(Scene scene)) {
    final filePath = testFilePath(fileName);
    final str = File(filePath).readAsStringSync();
    final scene = Scene.fromString(str, hint: extension(filePath));
    tester(scene);
    scene.dispose();
  }

  void testBinaryScene(String fileName, void tester(Scene scene)) {
    testSceneFromFile(fileName, tester);
    testSceneFromBytes(fileName, tester);
  }

  void testAsciiScene(String fileName, void tester(Scene scene)) {
    testSceneFromFile(fileName, tester);
    testSceneFromBytes(fileName, tester);
    testSceneFromString(fileName, tester);
  }

  test('3mf', () {
    testBinaryScene('3mf/box.3mf', (scene) {
      expect(scene.flags, isZero);
      expect(scene.rootNode, isNotNull);
      expect(scene.meshes.length, equals(1));
      expect(scene.materials.length, equals(1));
      expect(scene.animations.length, isZero);
      expect(scene.textures.length, isZero);
      expect(scene.lights.length, isZero);
      expect(scene.cameras.length, isZero);
      expect(scene.metaData, isNullPointer);
    });

    testBinaryScene('3mf/spider.3mf', (scene) {
      expect(scene.flags, isZero);
      expect(scene.rootNode, isNotNull);
      expect(scene.meshes.length, equals(19));
      expect(scene.materials.length, equals(4));
      expect(scene.animations.length, isZero);
      expect(scene.textures.length, isZero);
      expect(scene.lights.length, isZero);
      expect(scene.cameras.length, isZero);
      expect(scene.metaData, isNullPointer);
    });
  });

  test('fbx', () {
    testBinaryScene('fbx/huesitos.fbx', (scene) {
      expect(scene.flags, isZero);
      expect(scene.rootNode, isNotNull);
      expect(scene.meshes.length, equals(1));
      expect(scene.materials.length, equals(1));
      expect(scene.animations.length, equals(1));
      expect(scene.textures.length, isZero);
      expect(scene.lights.length, equals(1));
      expect(scene.cameras.length, equals(1));
      expect(scene.metaData, isNotNull);
    });
  });

  test('obj', () {
    testAsciiScene('Obj/Spider/spider.obj', (scene) {
      expect(scene.flags, isZero);
      expect(scene.rootNode, isNotNull);
      expect(scene.meshes.length, equals(19));
      expect(scene.materials.length, inInclusiveRange(5, 6));
      expect(scene.animations.length, isZero);
      expect(scene.textures.length, isZero);
      expect(scene.lights.length, isZero);
      expect(scene.cameras.length, isZero);
      expect(scene.metaData, isNullPointer);
    });
  });
}
