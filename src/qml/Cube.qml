/*
    SPDX-FileCopyrightText: 2022 Vlad Zahorodnii <vlad.zahorodnii@kde.org>

    SPDX-License-Identifier: GPL-3.0-only
*/

import QtQuick 2.15
import QtQuick3D 1.15
import org.kde.kwin 3.0 as KWinComponents

Node {
    id: cube

    property real faceDisplacement: 100
    required property size faceSize
    readonly property real baseAngle: 360 / faceRepeater.count
    readonly property QtObject selectedDesktop: {
        let index = Math.round(eulerRotation.y / baseAngle) % faceRepeater.count;
        if (index < 0) {
            index += faceRepeater.count;
        }
        return faceRepeater.objectAt(index).desktop;
    }

    function rotateToLeft() {
        const rotation = cube.eulerRotation;
        rotation.y -= cube.baseAngle;
        cube.setEulerRotation(rotation);
    }

    function rotateToRight() {
        const rotation = cube.eulerRotation;
        rotation.y += cube.baseAngle;
        cube.setEulerRotation(rotation);
    }

    function rotateTo(desktop) {
        const index = desktop.x11DesktopNumber - 1;
        const rotation = cube.eulerRotation;
        rotation.y = cube.baseAngle * index;
        cube.setEulerRotation(rotation);
    }

    Repeater3D {
        id: faceRepeater
        model: KWinComponents.VirtualDesktopModel {}
        delegate: CubeFace {
            faceSize: cube.faceSize
            scale: Qt.vector3d(faceSize.width / 100, faceSize.height / 100, 1)
            eulerRotation.y: cube.baseAngle * index
            position: {
                const z = 0.5 * cube.faceSize.width / Math.tan(cube.baseAngle * Math.PI / 360) + cube.faceDisplacement;
                const transform = Qt.matrix4x4();
                transform.rotate(cube.baseAngle * index, Qt.vector3d(0, 1, 0));
                return transform.times(Qt.vector3d(0, 0, z));
            }
        }
    }
}
