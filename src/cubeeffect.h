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
    Q_PROPERTY(qreal cubeFaceDisplacement READ cubeFaceDisplacement NOTIFY cubeFaceDisplacementChanged)

public:
    CubeEffect();

    void reconfigure(ReconfigureFlags flags) override;
    int requestedEffectChainPosition() const override;
    void grabbedKeyboardEvent(QKeyEvent *e) override;

    qreal cubeFaceDisplacement() const;
    void setCubeFaceDisplacement(qreal displacement);

public Q_SLOTS:
    void activate();
    void deactivate();
    void toggle();

Q_SIGNALS:
    void cubeFaceDisplacementChanged();

protected:
    QVariantMap initialProperties(EffectScreen *screen) override;

private:
    void realDeactivate();

    QTimer *m_shutdownTimer;
    QAction *m_toggleAction = nullptr;
    QList<QKeySequence> m_toggleShortcut;
    qreal m_cubeFaceDisplacement = 100;
};

} // namespace KWin
