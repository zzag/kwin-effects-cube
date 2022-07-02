/*
    SPDX-FileCopyrightText: 2021 Vlad Zahorodnii <vlad.zahorodnii@kde.org>

    SPDX-License-Identifier: GPL-2.0-or-later
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
    void deactivate(int timeout);
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
