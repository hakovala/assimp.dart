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
    expect(Material.fromNative(null), isNull);
  });

  test('size', () {
    expect(sizeOf<aiMaterial>(), equals(16));
  });

  test('size', () {
    final a = Material.fromNative(allocate<aiMaterial>());
    final b = Material.fromNative(allocate<aiMaterial>());
    final aa = Material.fromNative(a.ptr);
    final bb = Material.fromNative(b.ptr);
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
    expect(Material.fromNative(allocate<aiMaterial>()).toString(), matches(r'Material\(Pointer<aiMaterial>: address=0x[0-f]+\)'));
  });

  test('3mf', () {
    testScene('3mf/box.3mf', (scene) {
      final materials = scene.materials;
      expect(materials, isNotEmpty);
      expect(materials.length, equals(1));
      final material_0 = materials.elementAt(0);
      expect(material_0.properties.length, equals(2));
      final property_0_0 = material_0.properties.elementAt(0);
      expect(property_0_0.key, equals('\$clr.diffuse'));
      expect(property_0_0.value.runtimeType, double);
      expect(property_0_0.value, moreOrLessEquals(0.6));
      expect(property_0_0.index, isZero);
      expect(property_0_0.semantic, isZero);
      final property_0_1 = material_0.properties.elementAt(1);
      expect(property_0_1.key, equals('?mat.name'));
      expect(property_0_1.value.runtimeType, String);
      expect(property_0_1.value, equals('DefaultMaterial'));
      expect(property_0_1.index, isZero);
      expect(property_0_1.semantic, isZero);
    });
    testScene('3mf/spider.3mf', (scene) {
      final materials = scene.materials;
      expect(materials, isNotEmpty);
      expect(materials.length, equals(4));
      final material_0 = materials.elementAt(0);
      expect(material_0.properties.length, equals(1));
      final property_0_0 = material_0.properties.elementAt(0);
      expect(property_0_0.key, equals('?mat.name'));
      expect(property_0_0.value.runtimeType, String);
      expect(property_0_0.value, equals('id1_Skin'));
      expect(property_0_0.index, isZero);
      expect(property_0_0.semantic, isZero);

      final material_1 = materials.elementAt(1);
      expect(material_1.properties.length, equals(1));
      final property_1_0 = material_1.properties.elementAt(0);
      expect(property_1_0.key, equals('?mat.name'));
      expect(property_1_0.value.runtimeType, String);
      expect(property_1_0.value, equals('id1_HLeibTex'));
      expect(property_1_0.index, isZero);
      expect(property_1_0.semantic, isZero);

      final material_2 = materials.elementAt(2);
      expect(material_2.properties.length, equals(1));
      final property_2_0 = material_2.properties.elementAt(0);
      expect(property_2_0.key, equals('?mat.name'));
      expect(property_2_0.value.runtimeType, String);
      expect(property_2_0.value, equals('id1_BeinTex'));
      expect(property_2_0.index, isZero);
      expect(property_2_0.semantic, isZero);

      final material_3 = materials.elementAt(3);
      expect(material_3.properties.length, equals(1));
      final property_3_0 = material_3.properties.elementAt(0);
      expect(property_3_0.key, equals('?mat.name'));
      expect(property_3_0.value.runtimeType, String);
      expect(property_3_0.value, equals('id1_Augentex'));
      expect(property_3_0.index, isZero);
      expect(property_3_0.semantic, isZero);
    });
  });

  test('fbx', () {
    testScene('fbx/huesitos.fbx', (scene) {
      final materials = scene.materials;
      expect(materials, isNotEmpty);
      expect(materials.length, equals(1));
      final material_0 = materials.elementAt(0);
      expect(material_0.properties.length, equals(16));
      final property_0_0 = material_0.properties.elementAt(0);
      expect(property_0_0.key, equals('?mat.name'));
      expect(property_0_0.value.runtimeType, String);
      expect(property_0_0.value, equals('Material.001'));
      expect(property_0_0.index, isZero);
      expect(property_0_0.semantic, isZero);
      final property_0_1 = material_0.properties.elementAt(1);
      expect(property_0_1.key, equals('\$mat.shadingm'));
      expect(property_0_1.value.runtimeType.toString(), 'Uint8List');
      expect(property_0_1.value, equals([3, 0, 0, 0]));
      expect(property_0_1.index, isZero);
      expect(property_0_1.semantic, isZero);
      final property_0_2 = material_0.properties.elementAt(2);
      expect(property_0_2.key, equals('\$clr.diffuse'));
      expect(property_0_2.value.runtimeType, double);
      expect(property_0_2.value, moreOrLessEquals(0.411205));
      expect(property_0_2.index, isZero);
      expect(property_0_2.semantic, isZero);
      final property_0_3 = material_0.properties.elementAt(3);
      expect(property_0_3.key, equals('\$clr.emissive'));
      expect(property_0_3.value.runtimeType, double);
      expect(property_0_3.value, isZero);
      expect(property_0_3.index, isZero);
      expect(property_0_3.semantic, isZero);
      final property_0_4 = material_0.properties.elementAt(4);
      expect(property_0_4.key, equals('\$clr.ambient'));
      expect(property_0_4.value.runtimeType, double);
      expect(property_0_4.value, isZero);
      expect(property_0_4.index, isZero);
      expect(property_0_4.semantic, isZero);
      final property_0_5 = material_0.properties.elementAt(5);
      expect(property_0_5.key, equals('\$clr.specular'));
      expect(property_0_5.value.runtimeType, double);
      expect(property_0_5.value, moreOrLessEquals(0.848257));
      expect(property_0_5.index, isZero);
      expect(property_0_5.semantic, isZero);
      final property_0_6 = material_0.properties.elementAt(6);
      expect(property_0_6.key, equals('\$mat.shinpercent'));
      expect(property_0_6.value.runtimeType, double);
      expect(property_0_6.value, moreOrLessEquals(0.5));
      expect(property_0_6.index, isZero);
      expect(property_0_6.semantic, isZero);
      final property_0_7 = material_0.properties.elementAt(7);
      expect(property_0_7.key, equals('\$mat.shininess'));
      expect(property_0_7.value.runtimeType, double);
      expect(property_0_7.value, moreOrLessEquals(9.60784));
      expect(property_0_7.index, isZero);
      expect(property_0_7.semantic, isZero);
      final property_0_8 = material_0.properties.elementAt(8);
      expect(property_0_8.key, equals('\$clr.transparent'));
      expect(property_0_8.value.runtimeType, double);
      expect(property_0_8.value, isZero);
      expect(property_0_8.index, isZero);
      expect(property_0_8.semantic, isZero);
      final property_0_9 = material_0.properties.elementAt(9);
      expect(property_0_9.key, equals('\$mat.transparencyfactor'));
      expect(property_0_9.value.runtimeType, double);
      expect(property_0_9.value, isZero);
      expect(property_0_9.index, isZero);
      expect(property_0_9.semantic, isZero);
      final property_0_10 = material_0.properties.elementAt(10);
      expect(property_0_10.key, equals('\$mat.opacity'));
      expect(property_0_10.value.runtimeType, double);
      expect(property_0_10.value, moreOrLessEquals(1));
      expect(property_0_10.index, isZero);
      expect(property_0_10.semantic, isZero);
      final property_0_11 = material_0.properties.elementAt(11);
      expect(property_0_11.key, equals('\$clr.reflective'));
      expect(property_0_11.value.runtimeType, double);
      expect(property_0_11.value, moreOrLessEquals(1));
      expect(property_0_11.index, isZero);
      expect(property_0_11.semantic, isZero);
      final property_0_12 = material_0.properties.elementAt(12);
      expect(property_0_12.key, equals('\$mat.reflectivity'));
      expect(property_0_12.value.runtimeType, double);
      expect(property_0_12.value, isZero);
      expect(property_0_12.index, isZero);
      expect(property_0_12.semantic, isZero);
      final property_0_13 = material_0.properties.elementAt(13);
      expect(property_0_13.key, equals('\$mat.bumpscaling'));
      expect(property_0_13.value.runtimeType, double);
      expect(property_0_13.value, moreOrLessEquals(1));
      expect(property_0_13.index, isZero);
      expect(property_0_13.semantic, isZero);
      final property_0_14 = material_0.properties.elementAt(14);
      expect(property_0_14.key, equals('\$mat.displacementscaling'));
      expect(property_0_14.value.runtimeType, double);
      expect(property_0_14.value, moreOrLessEquals(1));
      expect(property_0_14.index, isZero);
      expect(property_0_14.semantic, isZero);
      final property_0_15 = material_0.properties.elementAt(15);
      expect(property_0_15.key, equals('\$raw.Shininess'));
      expect(property_0_15.value.runtimeType, double);
      expect(property_0_15.value, moreOrLessEquals(9.60784));
      expect(property_0_15.index, isZero);
      expect(property_0_15.semantic, isZero);
    });
  });

  test('obj', () {
    testScene('Obj/Spider/spider.obj', (scene) {
      final materials = scene.materials;
      expect(materials, isNotEmpty);
      expect(materials.length, equals(6));
      final material_0 = materials.elementAt(0);
      expect(material_0.properties.length, equals(10));
      final property_0_0 = material_0.properties.elementAt(0);
      expect(property_0_0.key, equals('?mat.name'));
      expect(property_0_0.value.runtimeType, String);
      expect(property_0_0.value, equals('DefaultMaterial'));
      expect(property_0_0.index, isZero);
      expect(property_0_0.semantic, isZero);
      final property_0_1 = material_0.properties.elementAt(1);
      expect(property_0_1.key, equals('\$mat.shadingm'));
      expect(property_0_1.value.runtimeType, int);
      expect(property_0_1.value, equals(2));
      expect(property_0_1.index, isZero);
      expect(property_0_1.semantic, isZero);
      final property_0_2 = material_0.properties.elementAt(2);
      expect(property_0_2.key, equals('\$clr.ambient'));
      expect(property_0_2.value.runtimeType, double);
      expect(property_0_2.value, isZero);
      expect(property_0_2.index, isZero);
      expect(property_0_2.semantic, isZero);
      final property_0_3 = material_0.properties.elementAt(3);
      expect(property_0_3.key, equals('\$clr.diffuse'));
      expect(property_0_3.value.runtimeType, double);
      expect(property_0_3.value, moreOrLessEquals(0.6));
      expect(property_0_3.index, isZero);
      expect(property_0_3.semantic, isZero);
      final property_0_4 = material_0.properties.elementAt(4);
      expect(property_0_4.key, equals('\$clr.specular'));
      expect(property_0_4.value.runtimeType, double);
      expect(property_0_4.value, isZero);
      expect(property_0_4.index, isZero);
      expect(property_0_4.semantic, isZero);
      final property_0_5 = material_0.properties.elementAt(5);
      expect(property_0_5.key, equals('\$clr.emissive'));
      expect(property_0_5.value.runtimeType, double);
      expect(property_0_5.value, isZero);
      expect(property_0_5.index, isZero);
      expect(property_0_5.semantic, isZero);
      final property_0_6 = material_0.properties.elementAt(6);
      expect(property_0_6.key, equals('\$mat.shininess'));
      expect(property_0_6.value.runtimeType, double);
      expect(property_0_6.value, isZero);
      expect(property_0_6.index, isZero);
      expect(property_0_6.semantic, isZero);
      final property_0_7 = material_0.properties.elementAt(7);
      expect(property_0_7.key, equals('\$mat.opacity'));
      expect(property_0_7.value.runtimeType, double);
      expect(property_0_7.value, moreOrLessEquals(1));
      expect(property_0_7.index, isZero);
      expect(property_0_7.semantic, isZero);
      final property_0_8 = material_0.properties.elementAt(8);
      expect(property_0_8.key, equals('\$clr.transparent'));
      expect(property_0_8.value.runtimeType, double);
      expect(property_0_8.value, moreOrLessEquals(1));
      expect(property_0_8.index, isZero);
      expect(property_0_8.semantic, isZero);
      final property_0_9 = material_0.properties.elementAt(9);
      expect(property_0_9.key, equals('\$mat.refracti'));
      expect(property_0_9.value.runtimeType, double);
      expect(property_0_9.value, moreOrLessEquals(1));
      expect(property_0_9.index, isZero);
      expect(property_0_9.semantic, isZero);

      final material_1 = materials.elementAt(1);
      expect(material_1.properties.length, equals(12));
      final property_1_0 = material_1.properties.elementAt(0);
      expect(property_1_0.key, equals('?mat.name'));
      expect(property_1_0.value.runtimeType, String);
      expect(property_1_0.value, equals('Skin'));
      expect(property_1_0.index, isZero);
      expect(property_1_0.semantic, isZero);
      final property_1_1 = material_1.properties.elementAt(1);
      expect(property_1_1.key, equals('\$mat.shadingm'));
      expect(property_1_1.value.runtimeType, int);
      expect(property_1_1.value, equals(2));
      expect(property_1_1.index, isZero);
      expect(property_1_1.semantic, isZero);
      final property_1_2 = material_1.properties.elementAt(2);
      expect(property_1_2.key, equals('\$clr.ambient'));
      expect(property_1_2.value.runtimeType, double);
      expect(property_1_2.value, moreOrLessEquals(0.2));
      expect(property_1_2.index, isZero);
      expect(property_1_2.semantic, isZero);
      final property_1_3 = material_1.properties.elementAt(3);
      expect(property_1_3.key, equals('\$clr.diffuse'));
      expect(property_1_3.value.runtimeType, double);
      expect(property_1_3.value, moreOrLessEquals(0.827451));
      expect(property_1_3.index, isZero);
      expect(property_1_3.semantic, isZero);
      final property_1_4 = material_1.properties.elementAt(4);
      expect(property_1_4.key, equals('\$clr.specular'));
      expect(property_1_4.value.runtimeType, double);
      expect(property_1_4.value, isZero);
      expect(property_1_4.index, isZero);
      expect(property_1_4.semantic, isZero);
      final property_1_5 = material_1.properties.elementAt(5);
      expect(property_1_5.key, equals('\$clr.emissive'));
      expect(property_1_5.value.runtimeType, double);
      expect(property_1_5.value, isZero);
      expect(property_1_5.index, isZero);
      expect(property_1_5.semantic, isZero);
      final property_1_6 = material_1.properties.elementAt(6);
      expect(property_1_6.key, equals('\$mat.shininess'));
      expect(property_1_6.value.runtimeType, double);
      expect(property_1_6.value, isZero);
      expect(property_1_6.index, isZero);
      expect(property_1_6.semantic, isZero);
      final property_1_7 = material_1.properties.elementAt(7);
      expect(property_1_7.key, equals('\$mat.opacity'));
      expect(property_1_7.value.runtimeType, double);
      expect(property_1_7.value, moreOrLessEquals(1));
      expect(property_1_7.index, isZero);
      expect(property_1_7.semantic, isZero);
      final property_1_8 = material_1.properties.elementAt(8);
      expect(property_1_8.key, equals('\$clr.transparent'));
      expect(property_1_8.value.runtimeType, double);
      expect(property_1_8.value, moreOrLessEquals(1));
      expect(property_1_8.index, isZero);
      expect(property_1_8.semantic, isZero);
      final property_1_9 = material_1.properties.elementAt(9);
      expect(property_1_9.key, equals('\$mat.refracti'));
      expect(property_1_9.value.runtimeType, double);
      expect(property_1_9.value, moreOrLessEquals(1));
      expect(property_1_9.index, isZero);
      expect(property_1_9.semantic, isZero);
      final property_1_10 = material_1.properties.elementAt(10);
      expect(property_1_10.key, equals('\$tex.file'));
      expect(property_1_10.value.runtimeType, String);
      expect(property_1_10.value, equals('.\\wal67ar_small.jpg'));
      expect(property_1_10.index, isZero);
      expect(property_1_10.semantic, equals(1));
      final property_1_11 = material_1.properties.elementAt(11);
      expect(property_1_11.key, equals('\$tex.uvwsrc'));
      expect(property_1_11.value.runtimeType, int);
      expect(property_1_11.value, isZero);
      expect(property_1_11.index, isZero);
      expect(property_1_11.semantic, equals(1));

      final material_2 = materials.elementAt(2);
      expect(material_2.properties.length, equals(12));
      final property_2_0 = material_2.properties.elementAt(0);
      expect(property_2_0.key, equals('?mat.name'));
      expect(property_2_0.value.runtimeType, String);
      expect(property_2_0.value, equals('Brusttex'));
      expect(property_2_0.index, isZero);
      expect(property_2_0.semantic, isZero);
      final property_2_1 = material_2.properties.elementAt(1);
      expect(property_2_1.key, equals('\$mat.shadingm'));
      expect(property_2_1.value.runtimeType, int);
      expect(property_2_1.value, equals(2));
      expect(property_2_1.index, isZero);
      expect(property_2_1.semantic, isZero);
      final property_2_2 = material_2.properties.elementAt(2);
      expect(property_2_2.key, equals('\$clr.ambient'));
      expect(property_2_2.value.runtimeType, double);
      expect(property_2_2.value, moreOrLessEquals(0.2));
      expect(property_2_2.index, isZero);
      expect(property_2_2.semantic, isZero);
      final property_2_3 = material_2.properties.elementAt(3);
      expect(property_2_3.key, equals('\$clr.diffuse'));
      expect(property_2_3.value.runtimeType, double);
      expect(property_2_3.value, moreOrLessEquals(0.8));
      expect(property_2_3.index, isZero);
      expect(property_2_3.semantic, isZero);
      final property_2_4 = material_2.properties.elementAt(4);
      expect(property_2_4.key, equals('\$clr.specular'));
      expect(property_2_4.value.runtimeType, double);
      expect(property_2_4.value, isZero);
      expect(property_2_4.index, isZero);
      expect(property_2_4.semantic, isZero);
      final property_2_5 = material_2.properties.elementAt(5);
      expect(property_2_5.key, equals('\$clr.emissive'));
      expect(property_2_5.value.runtimeType, double);
      expect(property_2_5.value, isZero);
      expect(property_2_5.index, isZero);
      expect(property_2_5.semantic, isZero);
      final property_2_6 = material_2.properties.elementAt(6);
      expect(property_2_6.key, equals('\$mat.shininess'));
      expect(property_2_6.value.runtimeType, double);
      expect(property_2_6.value, isZero);
      expect(property_2_6.index, isZero);
      expect(property_2_6.semantic, isZero);
      final property_2_7 = material_2.properties.elementAt(7);
      expect(property_2_7.key, equals('\$mat.opacity'));
      expect(property_2_7.value.runtimeType, double);
      expect(property_2_7.value, moreOrLessEquals(1));
      expect(property_2_7.index, isZero);
      expect(property_2_7.semantic, isZero);
      final property_2_8 = material_2.properties.elementAt(8);
      expect(property_2_8.key, equals('\$clr.transparent'));
      expect(property_2_8.value.runtimeType, double);
      expect(property_2_8.value, moreOrLessEquals(1));
      expect(property_2_8.index, isZero);
      expect(property_2_8.semantic, isZero);
      final property_2_9 = material_2.properties.elementAt(9);
      expect(property_2_9.key, equals('\$mat.refracti'));
      expect(property_2_9.value.runtimeType, double);
      expect(property_2_9.value, moreOrLessEquals(1));
      expect(property_2_9.index, isZero);
      expect(property_2_9.semantic, isZero);
      final property_2_10 = material_2.properties.elementAt(10);
      expect(property_2_10.key, equals('\$tex.file'));
      expect(property_2_10.value.runtimeType, String);
      expect(property_2_10.value, equals('.\\wal69ar_small.jpg'));
      expect(property_2_10.index, isZero);
      expect(property_2_10.semantic, equals(1));
      final property_2_11 = material_2.properties.elementAt(11);
      expect(property_2_11.key, equals('\$tex.uvwsrc'));
      expect(property_2_11.value.runtimeType, int);
      expect(property_2_11.value, isZero);
      expect(property_2_11.index, isZero);
      expect(property_2_11.semantic, equals(1));

      final material_3 = materials.elementAt(3);
      expect(material_3.properties.length, equals(12));
      final property_3_0 = material_3.properties.elementAt(0);
      expect(property_3_0.key, equals('?mat.name'));
      expect(property_3_0.value.runtimeType, String);
      expect(property_3_0.value, equals('HLeibTex'));
      expect(property_3_0.index, isZero);
      expect(property_3_0.semantic, isZero);
      final property_3_1 = material_3.properties.elementAt(1);
      expect(property_3_1.key, equals('\$mat.shadingm'));
      expect(property_3_1.value.runtimeType, int);
      expect(property_3_1.value, equals(2));
      expect(property_3_1.index, isZero);
      expect(property_3_1.semantic, isZero);
      final property_3_2 = material_3.properties.elementAt(2);
      expect(property_3_2.key, equals('\$clr.ambient'));
      expect(property_3_2.value.runtimeType, double);
      expect(property_3_2.value, moreOrLessEquals(0.2));
      expect(property_3_2.index, isZero);
      expect(property_3_2.semantic, isZero);
      final property_3_3 = material_3.properties.elementAt(3);
      expect(property_3_3.key, equals('\$clr.diffuse'));
      expect(property_3_3.value.runtimeType, double);
      expect(property_3_3.value, moreOrLessEquals(0.690196));
      expect(property_3_3.index, isZero);
      expect(property_3_3.semantic, isZero);
      final property_3_4 = material_3.properties.elementAt(4);
      expect(property_3_4.key, equals('\$clr.specular'));
      expect(property_3_4.value.runtimeType, double);
      expect(property_3_4.value, isZero);
      expect(property_3_4.index, isZero);
      expect(property_3_4.semantic, isZero);
      final property_3_5 = material_3.properties.elementAt(5);
      expect(property_3_5.key, equals('\$clr.emissive'));
      expect(property_3_5.value.runtimeType, double);
      expect(property_3_5.value, isZero);
      expect(property_3_5.index, isZero);
      expect(property_3_5.semantic, isZero);
      final property_3_6 = material_3.properties.elementAt(6);
      expect(property_3_6.key, equals('\$mat.shininess'));
      expect(property_3_6.value.runtimeType, double);
      expect(property_3_6.value, isZero);
      expect(property_3_6.index, isZero);
      expect(property_3_6.semantic, isZero);
      final property_3_7 = material_3.properties.elementAt(7);
      expect(property_3_7.key, equals('\$mat.opacity'));
      expect(property_3_7.value.runtimeType, double);
      expect(property_3_7.value, moreOrLessEquals(1));
      expect(property_3_7.index, isZero);
      expect(property_3_7.semantic, isZero);
      final property_3_8 = material_3.properties.elementAt(8);
      expect(property_3_8.key, equals('\$clr.transparent'));
      expect(property_3_8.value.runtimeType, double);
      expect(property_3_8.value, moreOrLessEquals(1));
      expect(property_3_8.index, isZero);
      expect(property_3_8.semantic, isZero);
      final property_3_9 = material_3.properties.elementAt(9);
      expect(property_3_9.key, equals('\$mat.refracti'));
      expect(property_3_9.value.runtimeType, double);
      expect(property_3_9.value, moreOrLessEquals(1));
      expect(property_3_9.index, isZero);
      expect(property_3_9.semantic, isZero);
      final property_3_10 = material_3.properties.elementAt(10);
      expect(property_3_10.key, equals('\$tex.file'));
      expect(property_3_10.value.runtimeType, String);
      expect(property_3_10.value, equals('.\\SpiderTex.jpg'));
      expect(property_3_10.index, isZero);
      expect(property_3_10.semantic, equals(1));
      final property_3_11 = material_3.properties.elementAt(11);
      expect(property_3_11.key, equals('\$tex.uvwsrc'));
      expect(property_3_11.value.runtimeType, int);
      expect(property_3_11.value, isZero);
      expect(property_3_11.index, isZero);
      expect(property_3_11.semantic, equals(1));

      final material_4 = materials.elementAt(4);
      expect(material_4.properties.length, equals(12));
      final property_4_0 = material_4.properties.elementAt(0);
      expect(property_4_0.key, equals('?mat.name'));
      expect(property_4_0.value.runtimeType, String);
      expect(property_4_0.value, equals('BeinTex'));
      expect(property_4_0.index, isZero);
      expect(property_4_0.semantic, isZero);
      final property_4_1 = material_4.properties.elementAt(1);
      expect(property_4_1.key, equals('\$mat.shadingm'));
      expect(property_4_1.value.runtimeType, int);
      expect(property_4_1.value, equals(2));
      expect(property_4_1.index, isZero);
      expect(property_4_1.semantic, isZero);
      final property_4_2 = material_4.properties.elementAt(2);
      expect(property_4_2.key, equals('\$clr.ambient'));
      expect(property_4_2.value.runtimeType, double);
      expect(property_4_2.value, moreOrLessEquals(0.2));
      expect(property_4_2.index, isZero);
      expect(property_4_2.semantic, isZero);
      final property_4_3 = material_4.properties.elementAt(3);
      expect(property_4_3.key, equals('\$clr.diffuse'));
      expect(property_4_3.value.runtimeType, double);
      expect(property_4_3.value, moreOrLessEquals(0.8));
      expect(property_4_3.index, isZero);
      expect(property_4_3.semantic, isZero);
      final property_4_4 = material_4.properties.elementAt(4);
      expect(property_4_4.key, equals('\$clr.specular'));
      expect(property_4_4.value.runtimeType, double);
      expect(property_4_4.value, isZero);
      expect(property_4_4.index, isZero);
      expect(property_4_4.semantic, isZero);
      final property_4_5 = material_4.properties.elementAt(5);
      expect(property_4_5.key, equals('\$clr.emissive'));
      expect(property_4_5.value.runtimeType, double);
      expect(property_4_5.value, isZero);
      expect(property_4_5.index, isZero);
      expect(property_4_5.semantic, isZero);
      final property_4_6 = material_4.properties.elementAt(6);
      expect(property_4_6.key, equals('\$mat.shininess'));
      expect(property_4_6.value.runtimeType, double);
      expect(property_4_6.value, isZero);
      expect(property_4_6.index, isZero);
      expect(property_4_6.semantic, isZero);
      final property_4_7 = material_4.properties.elementAt(7);
      expect(property_4_7.key, equals('\$mat.opacity'));
      expect(property_4_7.value.runtimeType, double);
      expect(property_4_7.value, moreOrLessEquals(1));
      expect(property_4_7.index, isZero);
      expect(property_4_7.semantic, isZero);
      final property_4_8 = material_4.properties.elementAt(8);
      expect(property_4_8.key, equals('\$clr.transparent'));
      expect(property_4_8.value.runtimeType, double);
      expect(property_4_8.value, moreOrLessEquals(1));
      expect(property_4_8.index, isZero);
      expect(property_4_8.semantic, isZero);
      final property_4_9 = material_4.properties.elementAt(9);
      expect(property_4_9.key, equals('\$mat.refracti'));
      expect(property_4_9.value.runtimeType, double);
      expect(property_4_9.value, moreOrLessEquals(1));
      expect(property_4_9.index, isZero);
      expect(property_4_9.semantic, isZero);
      final property_4_10 = material_4.properties.elementAt(10);
      expect(property_4_10.key, equals('\$tex.file'));
      expect(property_4_10.value.runtimeType, String);
      expect(property_4_10.value, equals('.\\drkwood2.jpg'));
      expect(property_4_10.index, isZero);
      expect(property_4_10.semantic, equals(1));
      final property_4_11 = material_4.properties.elementAt(11);
      expect(property_4_11.key, equals('\$tex.uvwsrc'));
      expect(property_4_11.value.runtimeType, int);
      expect(property_4_11.value, isZero);
      expect(property_4_11.index, isZero);
      expect(property_4_11.semantic, equals(1));

      final material_5 = materials.elementAt(5);
      expect(material_5.properties.length, equals(12));
      final property_5_0 = material_5.properties.elementAt(0);
      expect(property_5_0.key, equals('?mat.name'));
      expect(property_5_0.value.runtimeType, String);
      expect(property_5_0.value, equals('Augentex'));
      expect(property_5_0.index, isZero);
      expect(property_5_0.semantic, isZero);
      final property_5_1 = material_5.properties.elementAt(1);
      expect(property_5_1.key, equals('\$mat.shadingm'));
      expect(property_5_1.value.runtimeType, int);
      expect(property_5_1.value, equals(2));
      expect(property_5_1.index, isZero);
      expect(property_5_1.semantic, isZero);
      final property_5_2 = material_5.properties.elementAt(2);
      expect(property_5_2.key, equals('\$clr.ambient'));
      expect(property_5_2.value.runtimeType, double);
      expect(property_5_2.value, moreOrLessEquals(0.2));
      expect(property_5_2.index, isZero);
      expect(property_5_2.semantic, isZero);
      final property_5_3 = material_5.properties.elementAt(3);
      expect(property_5_3.key, equals('\$clr.diffuse'));
      expect(property_5_3.value.runtimeType, double);
      expect(property_5_3.value, moreOrLessEquals(0.8));
      expect(property_5_3.index, isZero);
      expect(property_5_3.semantic, isZero);
      final property_5_4 = material_5.properties.elementAt(4);
      expect(property_5_4.key, equals('\$clr.specular'));
      expect(property_5_4.value.runtimeType, double);
      expect(property_5_4.value, isZero);
      expect(property_5_4.index, isZero);
      expect(property_5_4.semantic, isZero);
      final property_5_5 = material_5.properties.elementAt(5);
      expect(property_5_5.key, equals('\$clr.emissive'));
      expect(property_5_5.value.runtimeType, double);
      expect(property_5_5.value, isZero);
      expect(property_5_5.index, isZero);
      expect(property_5_5.semantic, isZero);
      final property_5_6 = material_5.properties.elementAt(6);
      expect(property_5_6.key, equals('\$mat.shininess'));
      expect(property_5_6.value.runtimeType, double);
      expect(property_5_6.value, isZero);
      expect(property_5_6.index, isZero);
      expect(property_5_6.semantic, isZero);
      final property_5_7 = material_5.properties.elementAt(7);
      expect(property_5_7.key, equals('\$mat.opacity'));
      expect(property_5_7.value.runtimeType, double);
      expect(property_5_7.value, moreOrLessEquals(1));
      expect(property_5_7.index, isZero);
      expect(property_5_7.semantic, isZero);
      final property_5_8 = material_5.properties.elementAt(8);
      expect(property_5_8.key, equals('\$clr.transparent'));
      expect(property_5_8.value.runtimeType, double);
      expect(property_5_8.value, moreOrLessEquals(1));
      expect(property_5_8.index, isZero);
      expect(property_5_8.semantic, isZero);
      final property_5_9 = material_5.properties.elementAt(9);
      expect(property_5_9.key, equals('\$mat.refracti'));
      expect(property_5_9.value.runtimeType, double);
      expect(property_5_9.value, moreOrLessEquals(1));
      expect(property_5_9.index, isZero);
      expect(property_5_9.semantic, isZero);
      final property_5_10 = material_5.properties.elementAt(10);
      expect(property_5_10.key, equals('\$tex.file'));
      expect(property_5_10.value.runtimeType, String);
      expect(property_5_10.value, equals('.\\engineflare1.jpg'));
      expect(property_5_10.index, isZero);
      expect(property_5_10.semantic, equals(1));
      final property_5_11 = material_5.properties.elementAt(11);
      expect(property_5_11.key, equals('\$tex.uvwsrc'));
      expect(property_5_11.value.runtimeType, int);
      expect(property_5_11.value, isZero);
      expect(property_5_11.index, isZero);
      expect(property_5_11.semantic, equals(1));
    });
  });

}