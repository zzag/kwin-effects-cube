import QtQuick3D 1.15
import org.kde.kwin 3.0 as KWinComponents

Node {
    id: cube

    property real displacement: 100
    required property size faceSize

    function rotateTo(desktop) {
        const index = desktop.x11DesktopNumber - 1;
        const rotation = cube.eulerRotation;
        rotation.y = -360 * index / faceRepeater.count;
        cube.setEulerRotation(rotation);
    }

    Repeater3D {
        id: faceRepeater
        model: KWinComponents.VirtualDesktopModel {}
        delegate: CubeFace {
            readonly property real baseAngle: 360 / faceRepeater.count

            faceSize: cube.faceSize

            scale: Qt.vector3d(faceSize.width / 100, faceSize.height / 100, 1)
            eulerRotation.y: baseAngle * index
            position: {
                const z = cube.faceSize.width / 2 / Math.tan(baseAngle / 360 * Math.PI) + cube.displacement;
                const transform = Qt.matrix4x4();
                transform.rotate(baseAngle * index, Qt.vector3d(0, 1, 0));
                return transform.times(Qt.vector3d(0, 0, z));
            }
        }
    }
}
