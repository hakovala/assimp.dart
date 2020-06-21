#include <QtCore>

#include <assimp/cimport.h>
#include <assimp/scene.h>

static QDir testFileDir() { return QDir::current(); }
static QString testFilePath(const QString &fileName) { return testFileDir().filePath(fileName); }

static QDir testModelDir() { return QDir(QDir::currentPath() + "/models/model-db/"); }
static QString testModelPath(const QString &fileName) { return testModelDir().filePath(fileName); }

static QString import(const QString &package) { return QString("import '%1';").arg(package); }
static QString dartName(const QString &typeName) { return typeName == "aiMetadata" ? "MetaData" : typeName.mid(2); }

static QString isTrueOrFalse(bool val) { return val ? "isTrue" : "isFalse"; }
static QString isEmptyOrNot(int num) { return num ? "isNotEmpty" : "isEmpty"; }
static QString isZeroOrNot(int num) { return num ? "isNonZero" : "isZero"; }
static QString isNullOrNot(const void *ptr) { return ptr ? "isNotNull" : "isNull"; }

static QString color3ToString(const aiColor3D &c) { return QString("Color.fromARGB(255, %1, %2, %3)").arg(std::round(c.r * 255)).arg(std::round(c.g * 255)).arg(std::round(c.b * 255)); }
static QString matrix4ToString(const aiMatrix4x4 &m) { return QString("Matrix4(%1, %2, %3, %4, %5 ,%6, %7, %8, %9, %10, %11, %12, %13, %14, %15, %16)").arg(m.a1).arg(m.a2).arg(m.a3).arg(m.a4).arg(m.b1).arg(m.b2).arg(m.b3).arg(m.b4).arg(m.c1).arg(m.c2).arg(m.c3).arg(m.c4).arg(m.d1).arg(m.d2).arg(m.d3).arg(m.d4); }
static QString quaternionToString(const aiQuaternion &q) { return QString("Quaternion(%1, %2, %3, %4)").arg(q.x).arg(q.y).arg(q.z).arg(q.z); }
static QString vector3ToString(const aiVector3D &v) { return QString("Vector3(%1, %2, %3)").arg(v.x).arg(v.y).arg(v.z); }
static QString aabbToString(const aiAABB &a) { return QString("Aabb3.minMax(%1, %2)").arg(vector3ToString(a.mMin)).arg(vector3ToString(a.mMax)); }

static QString equalsTo(const QString &value) { return QString("equals(%1)").arg(value); }
static QString equalsToInt(int value) { return value ? equalsTo(QString::number(value)) : "isZero"; }
static QString equalsToFloat(float value) { return qFuzzyIsNull(value) ? "isZero" : QString("moreOrLessEquals(%1)").arg(value); }
static QString equalsToDouble(double value) { return qFuzzyIsNull(value) ? "isZero" : QString("moreOrLessEquals(%1)").arg(value); }
static QString equalsToString(const char *str, uint len) { return len ? equalsTo(QString("'%1'").arg(QString::fromUtf8(str, len).replace("\\", "\\\\").replace("$", "\\$"))) : "isEmpty"; }
static QString equalsToString(const aiString &str) { return equalsToString(str.data, str.length); }
static QString equalsToAabb(const aiAABB &a) { return QString("aabb3MoreOrLessEquals(%1)").arg(aabbToString(a)); }
static QString equalsToColor3(const aiColor3D &c) { return QString("isSameColorAs(%1)").arg(color3ToString(c)); }
static QString equalsToQuaternion(const aiQuaternion &q) { return QString("quaternionMoreOrLessEquals(%1)").arg(quaternionToString(q)); }
static QString equalsToVector3(const aiVector3D &v) { return QString("vector3MoreOrLessEquals(%1)").arg(vector3ToString(v)); }
static QString equalsToMatrix4(const aiMatrix4x4 &m) { return QString("matrix4MoreOrLessEquals(%1)").arg(matrix4ToString(m)); }
static QString equalsToByteArray(const char *arr, uint len) { QStringList v; for (uint i = 0; i < len; ++i) v += QString::number(arr[i]); return equalsTo("[%1]").arg(v.join(", ")); }
static QString equalsToIntArray(const uint *arr, uint len) { QStringList v; for (uint i = 0; i < len; ++i) v += QString::number(arr[i]); return equalsTo("[%1]").arg(v.join(", ")); }
static QString equalsToDoubleArray(const double *arr, uint len) { QStringList v; for (uint i = 0; i < len; ++i) v += QString::number(arr[i]); return equalsTo("[%1]").arg(v.join(", ")); }

static QString equalsToAnimBehavior(int value)
{
    switch (value) {
    case aiAnimBehaviour_DEFAULT: return equalsTo("AnimBehavior.defaults");
    case aiAnimBehaviour_CONSTANT: return equalsTo("AnimBehavior.constant");
    case aiAnimBehaviour_LINEAR: return equalsTo("AnimBehavior.linear");
    case aiAnimBehaviour_REPEAT: return equalsTo("AnimBehavior.repeat");
    default: return QString();
    }
}

static QString equalsToLightSourceType(int value)
{
    switch (value) {
    case aiLightSource_UNDEFINED: return equalsTo("LightSourceType.undefined");
    case aiLightSource_DIRECTIONAL: return equalsTo("LightSourceType.directional");
    case aiLightSource_POINT: return equalsTo("LightSourceType.point");
    case aiLightSource_SPOT: return equalsTo("LightSourceType.spot");
    case aiLightSource_AMBIENT: return equalsTo("LightSourceType.ambient");
    case aiLightSource_AREA: return equalsTo("LightSourceType.area");
    default: return QString();
    }
}

template <typename T>
static int arraySize(T *array)
{
    int c = 0;
    while (array[c] != 0)
        ++c;
    return c;
}

static void writeHeader(QTextStream &out, const QString &fileName)
{
    Q_UNUSED(fileName);
    out << import("dart:ffi") << "\n"
        << import("dart:typed_data") << "\n"
        << import("package:ffi/ffi.dart") << "\n"
        << import("package:test/test.dart") << "\n"
        << import("../lib/assimp.dart") << "\n"
        << import("../lib/src/bindings.dart") << "\n"
        << import("test_utils.dart") << "\n\n"
        << "// DO NOT EDIT (generated by tool/testgen)\n\n"
        << "void main() {\n"
        << "  prepareTest();\n\n";
}

static void writeFooter(QTextStream &out, const QString &fileName)
{
    Q_UNUSED(fileName);
    out << "}\n";
}

static void writeGroup(QTextStream &out, const QString &name, std::function<void()> writer)
{
    out << QString("  test('%1', () {\n").arg(name);
    writer();
    out << "  });\n\n";
}

static void writeNullTest(QTextStream &out, const QString &typeName)
{
    writeGroup(out, "null", [&]() {
        out << QString("    expect(%1.fromNative(null), isNull);\n").arg(typeName);
    });
}

static void writeSizeTest(QTextStream &out, const QString &typeName, size_t size)
{
    writeGroup(out, "size", [&]() {
        out << QString("    expect(sizeOf<%1>(), equals(%2));\n").arg(typeName).arg(size);
    });
}

static void writeEqualityTest(QTextStream &out, const QString &typeName)
{
    writeGroup(out, "size", [&]() {
        out << QString("    %1 a = %1.fromNative(allocate<%2>());\n").arg(dartName(typeName)).arg(typeName)
            << QString("    %1 b = %1.fromNative(allocate<%2>());\n").arg(dartName(typeName)).arg(typeName)
            << QString("    %1 aa = %1.fromNative(a.ptr);\n").arg(dartName(typeName))
            << QString("    %1 bb = %1.fromNative(b.ptr);\n").arg(dartName(typeName))
            << QString("    expect(a, equals(a));\n")
            << QString("    expect(a, equals(aa));\n")
            << QString("    expect(b, equals(b));\n")
            << QString("    expect(b, equals(bb));\n")
            << QString("    expect(a, isNot(equals(b)));\n")
            << QString("    expect(a, isNot(equals(bb)));\n")
            << QString("    expect(b, isNot(equals(a)));\n")
            << QString("    expect(b, isNot(equals(aa)));\n");
    });
}

static void writeToStringTest(QTextStream &out, const QString &typeName)
{
    writeGroup(out, "toString", [&]() {
        out << QString("    expect(%1.fromNative(allocate<%2>()).toString(), matches(r'%1\\(Pointer<%2>: address=0x[0-f]+\\)'));\n").arg(dartName(typeName)).arg(typeName);
    });
}

template <typename T>
static void generateTest(const QString &typeName, const QString &fileName, std::function<void(QTextStream &out)> writer)
{
    QFile file(testFilePath(fileName));
    if (!file.open(QIODevice::WriteOnly | QIODevice::Truncate))
        qFatal(qPrintable(file.errorString()));

    QTextStream out(&file);
    writeHeader(out, fileName);
    writeNullTest(out, dartName(typeName));
    writeSizeTest(out, typeName, sizeof(T));
    writeEqualityTest(out, typeName);
    writeToStringTest(out, typeName);
    writer(out);
    writeFooter(out, fileName);
}

static void writeAnimationTester(QTextStream &out, const QString &fileName = QString())
{
    const aiScene *scene = aiImportFile(testModelPath(fileName).toLocal8Bit(), 0);
    out << "    testScene('" << fileName << "', (scene) {\n"
        << "      final animations = scene.animations;\n"
        << "      expect(animations, " << isEmptyOrNot(scene->mAnimations != nullptr) << ");\n"
        << "      expect(animations.length, " << isZeroOrNot(scene->mNumAnimations) << ");\n";
    for (uint i = 0; i < scene->mNumAnimations; ++i) {
        const aiAnimation *animation = scene->mAnimations[i];
        out << "      expect(animations.elementAt(" << i << ").name, " << equalsToString(animation->mName) << ");\n";
        out << "      expect(animations.elementAt(" << i << ").duration, " << equalsToDouble(animation->mDuration) << ");\n";
        out << "      expect(animations.elementAt(" << i << ").ticksPerSecond, " << equalsToDouble(animation->mTicksPerSecond) << ");\n";
        out << "      expect(animations.elementAt(" << i << ").channels.length, " << equalsToInt(animation->mNumChannels) << ");\n";
        for (uint j = 0; j < animation->mNumChannels; ++j) {
            const aiNodeAnim *channel = animation->mChannels[j];
            out << "      expect(animations.elementAt(" << i << ").channels.elementAt(" << j << ").positionKeys.length, " << equalsToInt(channel->mNumPositionKeys) << ");\n";
            for (uint k = 0; k < channel->mNumPositionKeys; ++k) {
                const aiVectorKey *key = channel->mPositionKeys + k;
                out << "      expect(animations.elementAt(" << i << ").channels.elementAt(" << j << ").positionKeys.elementAt(" << k << ").time, " << equalsToDouble(key->mTime) << ");\n";
                out << "      expect(animations.elementAt(" << i << ").channels.elementAt(" << j << ").positionKeys.elementAt(" << k << ").value, " << equalsToVector3(key->mValue) << ");\n";
            }
            out << "      expect(animations.elementAt(" << i << ").channels.elementAt(" << j << ").rotationKeys.length, " << equalsToInt(channel->mNumRotationKeys) << ");\n";
            for (uint k = 0; k < channel->mNumRotationKeys; ++k) {
                const aiQuatKey *key = channel->mRotationKeys + k;
                out << "      expect(animations.elementAt(" << i << ").channels.elementAt(" << j << ").rotationKeys.elementAt(" << k << ").time, " << equalsToDouble(key->mTime) << ");\n";
                out << "      expect(animations.elementAt(" << i << ").channels.elementAt(" << j << ").rotationKeys.elementAt(" << k << ").value, " << equalsToQuaternion(key->mValue) << ");\n";
            }
            out << "      expect(animations.elementAt(" << i << ").channels.elementAt(" << j << ").scalingKeys.length, " << equalsToInt(channel->mNumScalingKeys) << ");\n";
            for (uint k = 0; k < channel->mNumScalingKeys; ++k) {
                const aiVectorKey *key = channel->mScalingKeys + k;
                out << "      expect(animations.elementAt(" << i << ").channels.elementAt(" << j << ").scalingKeys.elementAt(" << k << ").time, " << equalsToDouble(key->mTime) << ");\n";
                out << "      expect(animations.elementAt(" << i << ").channels.elementAt(" << j << ").scalingKeys.elementAt(" << k << ").value, " << equalsToVector3(key->mValue) << ");\n";
            }
            out << "      expect(animations.elementAt(" << i << ").channels.elementAt(" << j << ").preState, " << equalsToAnimBehavior(channel->mPreState) << ");\n";
            out << "      expect(animations.elementAt(" << i << ").channels.elementAt(" << j << ").postState, " << equalsToAnimBehavior(channel->mPostState) << ");\n";
        }
        out << "      expect(animations.elementAt(" << i << ").meshChannels.length, " << equalsToInt(animation->mNumMeshChannels) << ");\n";
        for (uint j = 0; j < animation->mNumMeshChannels; ++j) {
            const aiMeshAnim *channel = animation->mMeshChannels[j];
            out << "      expect(animations.elementAt(" << i << ").meshChannels.elementAt(" << j << ").keys.length, " << equalsToInt(channel->mNumKeys) << ");\n";
            for (uint k = 0; k < channel->mNumKeys; ++k) {
                const aiMeshKey *key = channel->mKeys + k;
                out << "      expect(animations.elementAt(" << i << ").meshChannels.elementAt(" << j << ").keys.elementAt(" << k << ").time, " << equalsToDouble(key->mTime) << ");\n";
                out << "      expect(animations.elementAt(" << i << ").meshChannels.elementAt(" << j << ").keys.elementAt(" << k << ").value, " << equalsToInt(key->mValue) << ");\n";
            }
        }
        out << "      expect(animations.elementAt(" << i << ").meshMorphChannels.length, " << equalsToInt(animation->mNumMorphMeshChannels) << ");\n";
        for (uint j = 0; j < animation->mNumMorphMeshChannels; ++j) {
            const aiMeshMorphAnim *channel = animation->mMorphMeshChannels[j];
            out << "      expect(animations.elementAt(" << i << ").meshMorphChannels.elementAt(" << j << ").keys.length, " << equalsToInt(channel->mNumKeys) << ");\n";
            for (uint k = 0; k < channel->mNumKeys; ++k) {
                const aiMeshMorphKey *key = channel->mKeys + k;
                out << "      expect(animations.elementAt(" << i << ").meshMorphChannels.elementAt(" << j << ").keys.elementAt(" << k << ").time, " << equalsToDouble(key->mTime) << ");\n";
                out << "      expect(animations.elementAt(" << i << ").meshMorphChannels.elementAt(" << j << ").keys.elementAt(" << k << ").values, " << equalsToIntArray(key->mValues, key->mNumValuesAndWeights) << ");\n";
                out << "      expect(animations.elementAt(" << i << ").meshMorphChannels.elementAt(" << j << ").keys.elementAt(" << k << ").weights, " << equalsToDoubleArray(key->mWeights, key->mNumValuesAndWeights) << ");\n";
            }
        }
        out << (i < scene->mNumAnimations - 1 ? "\n" : "");
    }
    out << "    });\n";
    aiReleaseImport(scene);
}

static void generateAnimationTest(const QString &fileName)
{
    generateTest<aiAnimation>("aiAnimation", fileName, [&](QTextStream &out) {
        writeGroup(out, "3mf", [&]() {
            writeAnimationTester(out, "3mf/box.3mf");
            writeAnimationTester(out, "3mf/spider.3mf");
        });
        writeGroup(out, "fbx", [&]() {
            writeAnimationTester(out, "fbx/huesitos.fbx");
        });
        writeGroup(out, "obj", [&]() {
            writeAnimationTester(out, "Obj/Spider/spider.obj");
        });
    });
}

static void writeCameraTester(QTextStream &out, const QString &fileName = QString())
{
    const aiScene *scene = aiImportFile(testModelPath(fileName).toLocal8Bit(), 0);
    out << "    testScene('" << fileName << "', (scene) {\n"
        << "      final cameras = scene.cameras;\n"
        << "      expect(cameras, " << isEmptyOrNot(scene->mCameras != nullptr) << ");\n"
        << "      expect(cameras.length, " << isZeroOrNot(scene->mNumCameras) << ");\n";
    for (uint i = 0; i < scene->mNumCameras; ++i) {
        const aiCamera *camera = scene->mCameras[i];
        out << "      expect(cameras.elementAt(" << i << ").name, " << equalsToString(camera->mName) << ");\n"
            << "      expect(cameras.elementAt(" << i << ").position, " << equalsToVector3(camera->mPosition) << ");\n"
            << "      expect(cameras.elementAt(" << i << ").up, " << equalsToVector3(camera->mUp) << ");\n"
            << "      expect(cameras.elementAt(" << i << ").lookAt, " << equalsToVector3(camera->mLookAt) << ");\n"
            << "      expect(cameras.elementAt(" << i << ").horizontalFov, " << equalsToFloat(camera->mHorizontalFOV) << ");\n"
            << "      expect(cameras.elementAt(" << i << ").clipPlaneNear, " << equalsToFloat(camera->mClipPlaneNear) << ");\n"
            << "      expect(cameras.elementAt(" << i << ").clipPlaneFar, " << equalsToFloat(camera->mClipPlaneFar) << ");\n"
            << "      expect(cameras.elementAt(" << i << ").aspect, " << equalsToFloat(camera->mAspect) << ");\n"
            << (i < scene->mNumCameras - 1 ? "\n" : "");
    }
    out << "    });\n";
    aiReleaseImport(scene);
}

static void generateCameraTest(const QString &fileName)
{
    generateTest<aiCamera>("aiCamera", fileName, [&](QTextStream &out) {
        writeGroup(out, "3mf", [&]() {
            writeCameraTester(out, "3mf/box.3mf");
            writeCameraTester(out, "3mf/spider.3mf");
        });
        writeGroup(out, "fbx", [&]() {
            writeCameraTester(out, "fbx/huesitos.fbx");
        });
        writeGroup(out, "obj", [&]() {
            writeCameraTester(out, "Obj/Spider/spider.obj");
        });
    });
}

static void writeLightTester(QTextStream &out, const QString &fileName = QString())
{
    const aiScene *scene = aiImportFile(testModelPath(fileName).toLocal8Bit(), 0);
    out << "    testScene('" << fileName << "', (scene) {\n"
        << "      final lights = scene.lights;\n"
        << "      expect(lights, " << isEmptyOrNot(scene->mLights != nullptr) << ");\n"
        << "      expect(lights.length, " << isZeroOrNot(scene->mNumLights) << ");\n";
    for (uint i = 0; i < scene->mNumLights; ++i) {
        const aiLight *light = scene->mLights[i];
        out << "      expect(lights.elementAt(" << i << ").name, " << equalsToString(light->mName) << ");\n"
            << "      expect(lights.elementAt(" << i << ").type, " << equalsToLightSourceType(light->mType) << ");\n"
            << "      expect(lights.elementAt(" << i << ").position, " << equalsToVector3(light->mPosition) << ");\n"
            << "      expect(lights.elementAt(" << i << ").direction, " << equalsToVector3(light->mDirection) << ");\n"
            << "      expect(lights.elementAt(" << i << ").up, " << equalsToVector3(light->mUp) << ");\n"
            << "      expect(lights.elementAt(" << i << ").attenuationConstant, " << equalsToFloat(light->mAttenuationConstant) << ");\n"
            << "      expect(lights.elementAt(" << i << ").attenuationLinear, " << equalsToFloat(light->mAttenuationLinear) << ");\n"
            << "      expect(lights.elementAt(" << i << ").attenuationQuadratic, " << equalsToFloat(light->mAttenuationQuadratic) << ");\n"
            << "      expect(lights.elementAt(" << i << ").colorDiffuse, " << equalsToColor3(light->mColorDiffuse) << ");\n"
            << "      expect(lights.elementAt(" << i << ").colorSpecular, " << equalsToColor3(light->mColorSpecular) << ");\n"
            << "      expect(lights.elementAt(" << i << ").colorAmbient, " << equalsToColor3(light->mColorAmbient) << ");\n"
            << "      expect(lights.elementAt(" << i << ").angleInnerCone, " << equalsToFloat(light->mAngleInnerCone) << ");\n"
            << "      expect(lights.elementAt(" << i << ").angleOuterCone, " << equalsToFloat(light->mAngleOuterCone) << ");\n"
            << "      expect(lights.elementAt(" << i << ").size.width, " << equalsToFloat(light->mSize.x) << ");\n"
            << "      expect(lights.elementAt(" << i << ").size.height, " << equalsToFloat(light->mSize.y) << ");\n"
            << (i < scene->mNumLights - 1 ? "\n" : "");
    }
    out << "    });\n";
    aiReleaseImport(scene);
}

static void generateLightTest(const QString &fileName)
{
    generateTest<aiLight>("aiLight", fileName, [&](QTextStream &out) {
        writeGroup(out, "3mf", [&]() {
            writeLightTester(out, "3mf/box.3mf");
            writeLightTester(out, "3mf/spider.3mf");
        });
        writeGroup(out, "fbx", [&]() {
            writeLightTester(out, "fbx/huesitos.fbx");
        });
        writeGroup(out, "obj", [&]() {
            writeLightTester(out, "Obj/Spider/spider.obj");
        });
    });
}

static void writeMaterialTester(QTextStream &out, const QString &fileName = QString())
{
    const aiScene *scene = aiImportFile(testModelPath(fileName).toLocal8Bit(), 0);
    out << "    testScene('" << fileName << "', (scene) {\n"
        << "      final materials = scene.materials;\n"
        << "      expect(materials, " << isEmptyOrNot(scene->mMaterials != nullptr) << ");\n"
        << "      expect(materials.length, " << isZeroOrNot(scene->mNumMaterials) << ");\n";
    for (uint i = 0; i < scene->mNumMaterials; ++i) {
        const aiMaterial *material = scene->mMaterials[i];
        out << "      expect(materials.elementAt(" << i << ").properties.length, " << equalsToInt(material->mNumProperties) << ");\n";
        for (uint j = 0; j < material->mNumProperties; ++j) {
            const aiMaterialProperty *property = material->mProperties[j];
            out << "        expect(materials.elementAt(" << i << ").properties.elementAt(" << j << ").key, " << equalsToString(property->mKey) << ");\n";
            switch (property->mType) {
            case aiPropertyTypeInfo::aiPTI_Float:
                out << "        expect(materials.elementAt(" << i << ").properties.elementAt(" << j << ").value.runtimeType, double);\n";
                out << "        expect(materials.elementAt(" << i << ").properties.elementAt(" << j << ").value, " << equalsToFloat(*reinterpret_cast<float*>(property->mData)) << ");\n";
                break;
            case aiPropertyTypeInfo::aiPTI_Double:
                out << "        expect(materials.elementAt(" << i << ").properties.elementAt(" << j << ").value.runtimeType, double);\n";
                out << "        expect(materials.elementAt(" << i << ").properties.elementAt(" << j << ").value, " << equalsToDouble(*reinterpret_cast<double*>(property->mData)) << ");\n";
                break;
            case aiPropertyTypeInfo::aiPTI_String:
                out << "        expect(materials.elementAt(" << i << ").properties.elementAt(" << j << ").value.runtimeType, String);\n";
                out << "        expect(materials.elementAt(" << i << ").properties.elementAt(" << j << ").value, " << equalsToString(*reinterpret_cast<aiString*>(property->mData)) << ");\n";
                break;
            case aiPropertyTypeInfo::aiPTI_Integer:
                out << "        expect(materials.elementAt(" << i << ").properties.elementAt(" << j << ").value.runtimeType, int);\n";
                out << "        expect(materials.elementAt(" << i << ").properties.elementAt(" << j << ").value, " << equalsToInt(*reinterpret_cast<int*>(property->mData)) << ");\n";
                break;
            case aiPropertyTypeInfo::aiPTI_Buffer:
                out << "        expect(materials.elementAt(" << i << ").properties.elementAt(" << j << ").value.runtimeType.toString(), 'Uint8List');\n";
                out << "        expect(materials.elementAt(" << i << ").properties.elementAt(" << j << ").value, " << equalsToByteArray(property->mData, property->mDataLength) << ");\n";
                break;
            default:
                break;
            }
            out << "        expect(materials.elementAt(" << i << ").properties.elementAt(" << j << ").index, " << equalsToInt(property->mIndex) << ");\n";
            out << "        expect(materials.elementAt(" << i << ").properties.elementAt(" << j << ").semantic, " << equalsToInt(property->mSemantic) << ");\n";
        }
        out << (i < scene->mNumMaterials - 1 ? "\n" : "");
    }
    out << "    });\n";
    aiReleaseImport(scene);
}

static void generateMaterialTest(const QString &fileName)
{
    generateTest<aiMaterial>("aiMaterial", fileName, [&](QTextStream &out) {
        writeGroup(out, "3mf", [&]() {
            writeMaterialTester(out, "3mf/box.3mf");
            writeMaterialTester(out, "3mf/spider.3mf");
        });
        writeGroup(out, "fbx", [&]() {
            writeMaterialTester(out, "fbx/huesitos.fbx");
        });
        writeGroup(out, "obj", [&]() {
            writeMaterialTester(out, "Obj/Spider/spider.obj");
        });
    });
}

static void writeMeshTester(QTextStream &out, const QString &fileName = QString())
{
    const aiScene *scene = aiImportFile(testModelPath(fileName).toLocal8Bit(), 0);
    out << "    testScene('" << fileName << "', (scene) {\n"
        << "      final meshes = scene.meshes;\n"
        << "      expect(meshes, " << isEmptyOrNot(scene->mMeshes != nullptr) << ");\n"
        << "      expect(meshes.length, " << isZeroOrNot(scene->mNumMeshes) << ");\n";
    for (uint i = 0; i < scene->mNumMeshes; ++i) {
        const aiMesh *mesh = scene->mMeshes[i];
        out << "      expect(meshes.elementAt(" << i << ").primitiveTypes, " << equalsToInt(mesh->mPrimitiveTypes) << ");\n"
            << "      expect(meshes.elementAt(" << i << ").vertices.length, " << equalsToInt(mesh->mNumVertices) << ");\n"
            << "      expect(meshes.elementAt(" << i << ").normals.length, " << equalsToInt(mesh->mNumVertices) << ");\n"
            << "      expect(meshes.elementAt(" << i << ").tangents.length, " << equalsToInt(mesh->mNumVertices) << ");\n"
            << "      expect(meshes.elementAt(" << i << ").bitangents.length, " << equalsToInt(mesh->mNumVertices) << ");\n"
            << "      expect(meshes.elementAt(" << i << ").colors.length, " << equalsToInt(arraySize(mesh->mColors)) << ");\n"
            << "      expect(meshes.elementAt(" << i << ").textureCoords.length, " << equalsToInt(arraySize(mesh->mTextureCoords)) << ");\n"
            << "      expect(meshes.elementAt(" << i << ").uvComponents.length, " << equalsToInt(arraySize(mesh->mNumUVComponents)) << ");\n"
            << "      expect(meshes.elementAt(" << i << ").faces.length, " << equalsToInt(mesh->mNumFaces) << ");\n"
            << "      expect(meshes.elementAt(" << i << ").bones.length, " << equalsToInt(mesh->mNumBones) << ");\n"
            << "      expect(meshes.elementAt(" << i << ").materialIndex, " << equalsToInt(mesh->mMaterialIndex) << ");\n"
            << "      expect(meshes.elementAt(" << i << ").name, " << equalsToString(mesh->mName) << ");\n"
            << "      expect(meshes.elementAt(" << i << ").animMeshes.length, " << equalsToInt(mesh->mNumAnimMeshes) << ");\n"
            << "      expect(meshes.elementAt(" << i << ").morphingMethod, " << equalsToInt(mesh->mMethod) << ");\n"
            << "      expect(meshes.elementAt(" << i << ").aabb, " << equalsToAabb(mesh->mAABB) << ");\n"
            << (i < scene->mNumMeshes - 1 ? "\n" : "");
    }
    out << "    });\n";
    aiReleaseImport(scene);
}

static void generateMeshTest(const QString &fileName)
{
    generateTest<aiMesh>("aiMesh", fileName, [&](QTextStream &out) {
        writeGroup(out, "3mf", [&]() {
            writeMeshTester(out, "3mf/box.3mf");
            writeMeshTester(out, "3mf/spider.3mf");
        });
        writeGroup(out, "fbx", [&]() {
            writeMeshTester(out, "fbx/huesitos.fbx");
        });
        writeGroup(out, "obj", [&]() {
            writeMeshTester(out, "Obj/Spider/spider.obj");
        });
    });
}

static void writeMetaDataTester(QTextStream &out, const QString &fileName = QString())
{
    const aiScene *scene = aiImportFile(testModelPath(fileName).toLocal8Bit(), 0);
    out << "    testScene('" << fileName << "', (scene) {\n"
        << "      final metaData = scene.metaData;\n"
        << "      expect(metaData, " << isNullOrNot(scene->mMetaData) << ");\n";
    if (scene->mMetaData) {
        out << "      expect(metaData.keys.length, " << equalsToInt(scene->mMetaData->mNumProperties) << ");\n"
            << "      expect(metaData.values.length, " << equalsToInt(scene->mMetaData->mNumProperties) << ");\n"
            << "      expect(metaData.properties.length, " << equalsToInt(scene->mMetaData->mNumProperties) << ");\n";
        for (uint i = 0; i < scene->mMetaData->mNumProperties; ++i) {
            out << "      expect(metaData.keys.elementAt(" << i << "), " << equalsToString(scene->mMetaData->mKeys[i]) << ");\n";
            const aiMetadataEntry *entry = scene->mMetaData->mValues + i;
            switch (entry->mType) {
            case aiMetadataType::AI_BOOL:
                out << "      expect(metaData.values.elementAt(" << i << ").runtimeType, bool);\n";
                out << "      expect(metaData.values.elementAt(" << i << "), " << isTrueOrFalse(*reinterpret_cast<bool*>(entry->mData)) << ");\n";
                break;
            case aiMetadataType::AI_INT32:
                out << "      expect(metaData.values.elementAt(" << i << ").runtimeType, int);\n";
                out << "      expect(metaData.values.elementAt(" << i << "), " << equalsToInt(*reinterpret_cast<int*>(entry->mData)) << ");\n";
                break;
            case aiMetadataType::AI_UINT64:
                out << "      expect(metaData.values.elementAt(" << i << ").runtimeType, int);\n";
                out << "      expect(metaData.values.elementAt(" << i << "), " << equalsToInt(*reinterpret_cast<qint64*>(entry->mData)) << ");\n";
                break;
            case aiMetadataType::AI_FLOAT:
                out << "      expect(metaData.values.elementAt(" << i << ").runtimeType, double);\n";
                out << "      expect(metaData.values.elementAt(" << i << "), " << equalsToFloat(*reinterpret_cast<float*>(entry->mData)) << ");\n";
                break;
            case aiMetadataType::AI_DOUBLE:
                out << "      expect(metaData.values.elementAt(" << i << ").runtimeType, double);\n";
                out << "      expect(metaData.values.elementAt(" << i << "), " << equalsToDouble(*reinterpret_cast<double*>(entry->mData)) << ");\n";
                break;
            case aiMetadataType::AI_AISTRING:
                out << "      expect(metaData.values.elementAt(" << i << ").runtimeType, String);\n";
                out << "      expect(metaData.values.elementAt(" << i << "), " << equalsToString(*reinterpret_cast<aiString*>(entry->mData)) << ");\n";
                break;
            case aiMetadataType::AI_AIVECTOR3D:
                out << "      expect(metaData.values.elementAt(" << i << ").runtimeType, Vector3);\n";
                out << "      expect(metaData.values.elementAt(" << i << "), " << equalsToVector3(*reinterpret_cast<aiVector3D*>(entry->mData)) << ");\n";
                break;
            default:
                break;
            }
        }
    }
    out << "    });\n";
    aiReleaseImport(scene);
}

static void generateMetaDataTest(const QString &fileName)
{
    generateTest<aiMetadata>("aiMetadata", fileName, [&](QTextStream &out) {
        writeGroup(out, "3mf", [&]() {
            writeMetaDataTester(out, "3mf/box.3mf");
            writeMetaDataTester(out, "3mf/spider.3mf");
        });
        writeGroup(out, "fbx", [&]() {
            writeMetaDataTester(out, "fbx/huesitos.fbx");
        });
        writeGroup(out, "obj", [&]() {
            writeMetaDataTester(out, "Obj/Spider/spider.obj");
        });
    });
}

static void writeNodeTester(QTextStream &out, const QString &fileName = QString())
{
    const aiScene *scene = aiImportFile(testModelPath(fileName).toLocal8Bit(), 0);
    out << "    testScene('" << fileName << "', (scene) {\n"
        << "      final rootNode = scene.rootNode;\n"
        << "      expect(rootNode, " << isNullOrNot(scene->mRootNode) << ");\n"
        << "      expect(rootNode.name, " << equalsToString(scene->mRootNode->mName) << ");\n"
        << "      expect(rootNode.transformation, " << equalsToMatrix4(scene->mRootNode->mTransformation) << ");\n"
        << "      expect(rootNode.parent, " << isNullOrNot(scene->mRootNode->mParent) << ");\n"
        << "      expect(rootNode.children.length, " << equalsToInt(scene->mRootNode->mNumChildren) << ");\n";
    for (uint i = 0; i < scene->mRootNode->mNumChildren; ++i) {
        const aiNode *node = scene->mRootNode->mChildren[i];
        out << "      expect(rootNode.children.elementAt(" << i << ").name, " << equalsToString(node->mName) << ");\n"
            << "      expect(rootNode.children.elementAt(" << i << ").transformation, " << equalsToMatrix4(node->mTransformation) << ");\n"
            << "      expect(rootNode.children.elementAt(" << i << ").parent, " << isNullOrNot(node->mParent) << ");\n"
            << "      expect(rootNode.children.elementAt(" << i << ").children.length, " << equalsToInt(node->mNumChildren) << ");\n"
            << "      expect(rootNode.children.elementAt(" << i << ").meshes, " << equalsToIntArray(node->mMeshes, node->mNumMeshes) << ");\n"
            << "      expect(rootNode.children.elementAt(" << i << ").metaData, " << isNullOrNot(node->mMetaData) << ");\n";
    }
    out << "      expect(rootNode.meshes, " << equalsToIntArray(scene->mRootNode->mMeshes, scene->mRootNode->mNumMeshes) << ");\n"
        << "      expect(rootNode.metaData, " << isNullOrNot(scene->mRootNode->mMetaData) << ");\n"
        << "    });\n\n";
    aiReleaseImport(scene);
}

static void generateNodeTest(const QString &fileName)
{
    generateTest<aiNode>("aiNode", fileName, [&](QTextStream &out) {
        writeGroup(out, "3mf", [&]() {
            writeNodeTester(out, "3mf/box.3mf");
            writeNodeTester(out, "3mf/spider.3mf");
        });
        writeGroup(out, "fbx", [&]() {
            writeNodeTester(out, "fbx/huesitos.fbx");
        });
        writeGroup(out, "obj", [&]() {
            writeNodeTester(out, "Obj/Spider/spider.obj");
        });
    });
}

static void writeSceneTester(QTextStream &out, const QString &fileName = QString())
{
    const aiScene *scene = aiImportFile(testModelPath(fileName).toLocal8Bit(), 0);
    out << "    testScene('" << fileName << "', (scene) {\n"
        << "      expect(scene, " << isNullOrNot(scene) << ");\n"
        << "      expect(scene.flags, " << isZeroOrNot(scene->mFlags) << ");\n"
        << "      expect(scene.rootNode, " << isNullOrNot(scene->mRootNode) << ");\n"
        << "      expect(scene.meshes.length, " << equalsToInt(scene->mNumMeshes) << ");\n"
        << "      expect(scene.materials.length, " << equalsToInt(scene->mNumMaterials) << ");\n"
        << "      expect(scene.animations.length, " << equalsToInt(scene->mNumAnimations) << ");\n"
        << "      expect(scene.textures.length, " << equalsToInt(scene->mNumTextures) << ");\n"
        << "      expect(scene.lights.length, " << equalsToInt(scene->mNumLights) << ");\n"
        << "      expect(scene.cameras.length, " << equalsToInt(scene->mNumCameras) << ");\n"
        << "      expect(scene.metaData, " << isNullOrNot(scene->mMetaData) << ");\n"
        << "    });\n";
    aiReleaseImport(scene);
}

static void generateSceneTest(const QString &fileName)
{
    generateTest<aiScene>("aiScene", fileName, [&](QTextStream &out) {
        writeGroup(out, "3mf", [&]() {
            writeSceneTester(out, "3mf/box.3mf");
            writeSceneTester(out, "3mf/spider.3mf");
        });
        writeGroup(out, "fbx", [&]() {
            writeSceneTester(out, "fbx/huesitos.fbx");
        });
        writeGroup(out, "obj", [&]() {
            writeSceneTester(out, "Obj/Spider/spider.obj");
        });
    });
}

static void writeTextureTester(QTextStream &out, const QString &fileName = QString())
{
    const aiScene *scene = aiImportFile(testModelPath(fileName).toLocal8Bit(), 0);
    out << "    testScene('" << fileName << "', (scene) {\n"
        << "      final textures = scene.textures;\n"
        << "      expect(textures, " << isEmptyOrNot(scene->mTextures != nullptr) << ");\n"
        << "      expect(textures.length, " << isZeroOrNot(scene->mNumTextures) << ");\n";
    for (uint i = 0; i < scene->mNumTextures; ++i) {
        const aiTexture *texture = scene->mTextures[i];
        out << "      expect(textures.elementAt(" << i << ").width, " << equalsToInt(texture->mWidth) << ");\n"
            << "      expect(textures.elementAt(" << i << ").height, " << equalsToInt(texture->mHeight) << ");\n"
            << "      expect(textures.elementAt(" << i << ").data.length, " << equalsToInt(texture->mWidth * texture->mHeight) << ");\n"
            << "      expect(textures.elementAt(" << i << ").formatHint, " << equalsToString(texture->achFormatHint, HINTMAXTEXTURELEN) << ");\n"
            << "      expect(textures.elementAt(" << i << ").fileName, " << equalsToString(texture->mFilename) << ");\n";
        for (uint h = 0; h < texture->mHeight; ++h) {
            for (uint w = 0; w < texture->mWidth; ++w) {
                const aiTexel *texel = texture->pcData + h * w + w;
                out << "      expect(textures.elementAt(" << i << ").b, " << equalsToInt(texel->b) << ");\n"
                    << "      expect(textures.elementAt(" << i << ").g, " << equalsToInt(texel->g) << ");\n"
                    << "      expect(textures.elementAt(" << i << ").r, " << equalsToInt(texel->r) << ");\n"
                    << "      expect(textures.elementAt(" << i << ").a, " << equalsToInt(texel->a) << ");\n";
            }
        }
    }
    out << "    });\n";
    aiReleaseImport(scene);
}

static void generateTextureTest(const QString &fileName)
{
    generateTest<aiTexture>("aiTexture", fileName, [&](QTextStream &out) {
        writeGroup(out, "3mf", [&]() {
            writeTextureTester(out, "3mf/box.3mf");
            writeTextureTester(out, "3mf/spider.3mf");
        });
        writeGroup(out, "fbx", [&]() {
            writeTextureTester(out, "fbx/huesitos.fbx");
        });
        writeGroup(out, "obj", [&]() {
            writeTextureTester(out, "Obj/Spider/spider.obj");
        });
    });
}

int main(int argc, char *argv[])
{
    QCoreApplication app(argc, argv);

    QDir::setCurrent(QString::fromLocal8Bit(argc > 1 ? argv[1] : OUT_PWD));

    generateAnimationTest("animation_test.dart");
    generateCameraTest("camera_test.dart");
    generateLightTest("light_test.dart");
    generateMaterialTest("material_test.dart");
    generateMeshTest("mesh_test.dart");
    generateMetaDataTest("meta_data_test.dart");
    generateNodeTest("node_test.dart");
    generateSceneTest("scene_test.dart");
    generateTextureTest("texture_test.dart");
}
