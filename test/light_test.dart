import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'package:test/test.dart';
import '../lib/assimp.dart';
import '../lib/src/bindings.dart';
import 'test_utils.dart';

// DO NOT EDIT (generated by tool/testgen)

void main() {
  prepareTest();

  test('null', () {
    expect(Light.fromNative(null), isNull);
  });

  test('size', () {
    expect(sizeOf<aiLight>(), equals(1132));
  });

  test('size', () {
    Light a = Light.fromNative(allocate<aiLight>());
    Light b = Light.fromNative(allocate<aiLight>());
    Light aa = Light.fromNative(a.ptr);
    Light bb = Light.fromNative(b.ptr);
    expect(a, equals(a));
    expect(a, equals(aa));
    expect(b, equals(b));
    expect(b, equals(bb));
    expect(a, isNot(equals(b)));
    expect(a, isNot(equals(bb)));
    expect(b, isNot(equals(a)));
    expect(b, isNot(equals(aa)));
  });

  test('toString', () {
    expect(Light.fromNative(allocate<aiLight>()).toString(), matches(r'Light\(Pointer<aiLight>: address=0x[0-f]+\)'));
  });

  test('3mf', () {
    testScene('3mf/box.3mf', (scene) {
      final lights = scene.lights;
      expect(lights, isEmpty);
      expect(lights.length, isZero);
    });
    testScene('3mf/spider.3mf', (scene) {
      final lights = scene.lights;
      expect(lights, isEmpty);
      expect(lights.length, isZero);
    });
  });

  test('fbx', () {
    testScene('fbx/huesitos.fbx', (scene) {
      final lights = scene.lights;
      expect(lights, isNotEmpty);
      expect(lights.length, isNonZero);
      expect(lights.elementAt(0).name, equals('Lamp'));
      expect(lights.elementAt(0).type, equals(LightSourceType.point));
      expect(lights.elementAt(0).position, vector3MoreOrLessEquals(Vector3(0, 0, 0)));
      expect(lights.elementAt(0).direction, vector3MoreOrLessEquals(Vector3(0, -1, 0)));
      expect(lights.elementAt(0).up, vector3MoreOrLessEquals(Vector3(0, 0, -1)));
      expect(lights.elementAt(0).attenuationConstant, isZero);
      expect(lights.elementAt(0).attenuationLinear, moreOrLessEquals(0.000666667));
      expect(lights.elementAt(0).attenuationQuadratic, isZero);
      expect(lights.elementAt(0).colorDiffuse, isSameColorAs(Color.fromARGB(255, 255, 255, 255)));
      expect(lights.elementAt(0).colorSpecular, isSameColorAs(Color.fromARGB(255, 255, 255, 255)));
      expect(lights.elementAt(0).colorAmbient, isSameColorAs(Color.fromARGB(255, 0, 0, 0)));
      expect(lights.elementAt(0).angleInnerCone, moreOrLessEquals(6.28319));
      expect(lights.elementAt(0).angleOuterCone, moreOrLessEquals(6.28319));
      expect(lights.elementAt(0).size.width, isZero);
      expect(lights.elementAt(0).size.height, isZero);
    });
  });

  test('obj', () {
    testScene('Obj/Spider/spider.obj', (scene) {
      final lights = scene.lights;
      expect(lights, isEmpty);
      expect(lights.length, isZero);
    });
  });

}
