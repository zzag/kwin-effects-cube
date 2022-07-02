import QtQuick 2.15
import QtQuick3D 1.15

Model {
    id: face

    required property QtObject desktop
    required property int index
    required property size faceSize

    pickable: true
    source: "#Rectangle"
    materials: [
        DefaultMaterial {
            cullMode: Material.NoCulling
            lighting: DefaultMaterial.NoLighting
            diffuseMap: Texture {
                sourceItem: DesktopView {
                    desktop: face.desktop
                    width: faceSize.width
                    height: faceSize.height
                }
            }
        }
    ]
}
