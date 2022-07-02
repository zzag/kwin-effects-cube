import QtQuick 2.15
import QtQuick3D 1.15
import QtQuick3D.Helpers 1.15
import org.kde.kwin 3.0 as KWinComponents

Item {
    id: root

    required property QtObject effect
    required property QtObject targetScreen

    readonly property bool debug: false

    View3D {
        id: view
        anchors.fill: parent

        environment: SceneEnvironment {
            clearColor: "black"
            backgroundMode: SceneEnvironment.Color
        }

        Loader {
            active: root.debug
            sourceComponent: AxisHelper {}
        }
        Loader {
            active: root.debug
            sourceComponent: DebugView {
                source: view
            }
        }

        PerspectiveCamera {
            id: perspectiveCamera
            position: Qt.vector3d(0, 0, Math.max(targetScreen.geometry.width, targetScreen.geometry.height) * 1.5)
        }

        OrbitCameraController {
            anchors.fill: parent
            origin: cube
            camera: perspectiveCamera
        }

        DirectionalLight {
            eulerRotation.x: -30
            eulerRotation.y: -70
        }

        Cube {
            id: cube
            faceSize: Qt.size(root.width, root.height)
        }

        Component.onCompleted: {
            cube.rotateTo(KWinComponents.Workspace.currentVirtualDesktop);
        }
    }

    MouseArea {
        anchors.fill: view
        onClicked: {
            const result = view.pick(mouse.x, mouse.y);
            if (result.objectHit && result.objectHit.desktop) {
                KWinComponents.Workspace.currentVirtualDesktop = result.objectHit.desktop;
                effect.deactivate(0);
            }
        }
    }
}
