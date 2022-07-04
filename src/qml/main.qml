/*
    SPDX-FileCopyrightText: 2022 Vlad Zahorodnii <vlad.zahorodnii@kde.org>

    SPDX-License-Identifier: GPL-3.0-only
*/

import QtQuick 2.15
import QtQuick3D 1.15
import org.kde.kwin 3.0 as KWinComponents

Item {
    id: root
    focus: true

    required property QtObject effect
    required property QtObject targetScreen

    property bool animationEnabled: false

    function start() {
        cube.rotateTo(KWinComponents.Workspace.currentVirtualDesktop);
        root.animationEnabled = true;
        perspectiveCamera.state = "distant";
    }

    function stop() {
        cube.rotateTo(KWinComponents.Workspace.currentVirtualDesktop);
        perspectiveCamera.state = "close";
    }

    function switchToSelected() {
        KWinComponents.Workspace.currentVirtualDesktop = cube.selectedDesktop;
        effect.deactivate();
    }

    View3D {
        id: view
        anchors.fill: parent

        environment: SceneEnvironment {
            clearColor: "black"
            backgroundMode: SceneEnvironment.Color
        }

        PerspectiveCamera {
            id: perspectiveCamera
            property real distanceScale: 1
            state: "close"
            position: Qt.vector3d(0, 0, cube.faceDistance * distanceScale + 0.5 * cube.faceSize.height * Math.tan(fieldOfView * Math.PI / 180))
            states: [
                State {
                    name: "close"
                    PropertyChanges {
                        target: perspectiveCamera
                        distanceScale: 1
                    }
                },
                State {
                    name: "distant"
                    PropertyChanges {
                        target: perspectiveCamera
                        distanceScale: effect.distanceFactor
                    }
                }
            ]
            Behavior on distanceScale {
                NumberAnimation { duration: effect.animationDuration; easing.type: Easing.OutCubic }
            }
        }

        OrbitCameraController {
            id: orbitController
            anchors.fill: parent
            origin: cube
            camera: perspectiveCamera
            xInvert: effect.mouseInvertedX
            yInvert: effect.mouseInvertedY
        }

        Cube {
            id: cube
            faceDisplacement: effect.cubeFaceDisplacement
            faceSize: Qt.size(root.width, root.height)

            Behavior on rotation {
                enabled: !orbitController.inputsNeedProcessing && root.animationEnabled
                QuaternionAnimation { duration: effect.animationDuration; easing.type: Easing.OutCubic }
            }
        }
    }

    MouseArea {
        anchors.fill: view
        onClicked: root.switchToSelected();
    }

    Keys.onEscapePressed: effect.deactivate();
    Keys.onLeftPressed: cube.rotateToLeft();
    Keys.onRightPressed: cube.rotateToRight();
    Keys.onEnterPressed: root.switchToSelected();
    Keys.onReturnPressed: root.switchToSelected();
    Keys.onSpacePressed: root.switchToSelected();

    Component.onCompleted: start();
}
