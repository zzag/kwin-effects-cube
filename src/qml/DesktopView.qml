/*
    SPDX-FileCopyrightText: 2022 Vlad Zahorodnii <vlad.zahorodnii@kde.org>

    SPDX-License-Identifier: GPL-3.0-only
*/

import QtQuick 2.15
import org.kde.kwin 3.0 as KWinComponents

Item {
    id: desktopView

    required property QtObject desktop

    Repeater {
        model: KWinComponents.ClientFilterModel {
            activity: KWinComponents.Workspace.currentActivity
            desktop: desktopView.desktop
            screenName: targetScreen.name
            clientModel: KWinComponents.ClientModel {}
        }

        KWinComponents.WindowThumbnailItem {
            wId: model.client.internalId
            x: model.client.x - targetScreen.geometry.x
            y: model.client.y - targetScreen.geometry.y
            width: model.client.width
            height: model.client.height
            z: model.client.stackingOrder
            visible: !model.client.minimized
        }
    }
}
