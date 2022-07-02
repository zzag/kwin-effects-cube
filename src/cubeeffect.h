/*
    SPDX-FileCopyrightText: 2022 Vlad Zahorodnii <vlad.zahorodnii@kde.org>

    SPDX-License-Identifier: GPL-3.0-only
*/

#pragma once

#include <kwinquickeffect.h>

#include <QKeySequence>

namespace KWin
{

class CubeEffect : public QuickSceneEffect
{
    Q_OBJECT

public:
    CubeEffect();

    int requestedEffectChainPosition() const override;
    void grabbedKeyboardEvent(QKeyEvent *e) override;

public Q_SLOTS:
    void activate();
    void deactivate();
    void toggle();

protected:
    QVariantMap initialProperties(EffectScreen *screen) override;

private:
    void realDeactivate();

    QTimer *m_shutdownTimer;
    QAction *m_toggleAction = nullptr;
    QList<QKeySequence> m_toggleShortcut;
};

} // namespace KWin
