import QtQuick 2.15
import QtQuick3D 1.15
import QtQuick3D.Helpers 1.15
import org.kde.kwin 3.0 as KWinComponents
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: root
    focus: true

    required property QtObject effect
    required property QtObject targetScreen

    readonly property bool debug: false
    property bool animationEnabled: false

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
            id: orbitController
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

            Behavior on eulerRotation {
                enabled: !orbitController.inputsNeedProcessing && root.animationEnabled
                Vector3dAnimation { duration: PlasmaCore.Units.longDuration; easing.type: Easing.InOutCubic }
            }
        }
    }

    MouseArea {
        anchors.fill: view
        onClicked: {
            const result = view.pick(mouse.x, mouse.y);
            if (result.objectHit && result.objectHit.desktop) {
                KWinComponents.Workspace.currentVirtualDesktop = result.objectHit.desktop;
                effect.deactivate();
            }
        }
    }

    Keys.onLeftPressed: cube.rotateToLeft();
    Keys.onRightPressed: cube.rotateToRight();
    Keys.onEnterPressed: root.switchToSelected();
    Keys.onReturnPressed: root.switchToSelected();
    Keys.onSpacePressed: root.switchToSelected();

    Component.onCompleted: {
        cube.rotateTo(KWinComponents.Workspace.currentVirtualDesktop);
        root.animationEnabled = true;
    }
}
