import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'package:test/test.dart';
import 'package:assimp/assimp.dart';
import 'package:assimp/src/bindings.dart';
import 'test_utils.dart';

// DO NOT EDIT (generated by tool/testgen)

void main() {
  prepareTest();

  test('size', () {
    expect(sizeOf<aiMetadataEntry>(), equals(16));
  });

}
