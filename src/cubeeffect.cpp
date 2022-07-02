/*
    SPDX-FileCopyrightText: 2022 Vlad Zahorodnii <vlad.zahorodnii@kde.org>

    SPDX-License-Identifier: GPL-3.0-only
*/

#include "cubeeffect.h"
#include "cubeconfig.h"

#include <QAction>
#include <QQuickItem>
#include <QTimer>

#include <KGlobalAccel>
#include <KLocalizedString>

namespace KWin
{

CubeEffect::CubeEffect()
    : m_shutdownTimer(new QTimer(this))
{
    m_shutdownTimer->setSingleShot(true);
    connect(m_shutdownTimer, &QTimer::timeout, this, &CubeEffect::realDeactivate);
    connect(effects, &EffectsHandler::screenAboutToLock, this, &CubeEffect::realDeactivate);

    const QKeySequence defaultToggleShortcut = Qt::META | Qt::Key_C;
    m_toggleAction = new QAction(this);
    m_toggleAction->setObjectName(QStringLiteral("Cube"));
    m_toggleAction->setText(i18n("Toggle Cube"));
    KGlobalAccel::self()->setDefaultShortcut(m_toggleAction, {defaultToggleShortcut});
    KGlobalAccel::self()->setShortcut(m_toggleAction, {defaultToggleShortcut});
    m_toggleShortcut = KGlobalAccel::self()->shortcut(m_toggleAction);
    effects->registerGlobalShortcut({defaultToggleShortcut}, m_toggleAction);
    connect(m_toggleAction, &QAction::triggered, this, &CubeEffect::toggle);

    connect(KGlobalAccel::self(), &KGlobalAccel::globalShortcutChanged, this, [this](QAction *action, const QKeySequence &seq) {
        if (action->objectName() == QStringLiteral("Cube")) {
            m_toggleShortcut.clear();
            m_toggleShortcut.append(seq);
        }
    });

    setSource(QUrl::fromLocalFile(QStandardPaths::locate(QStandardPaths::GenericDataLocation, QStringLiteral("kwin/effects/cube/qml/main.qml"))));

    reconfigure(ReconfigureAll);
}

void CubeEffect::reconfigure(ReconfigureFlags)
{
    CubeConfig::self()->read();
    setCubeFaceDisplacement(CubeConfig::cubeFaceDisplacement());
    setDistanceFactor(CubeConfig::distanceFactor() / 100.0);
}

QVariantMap CubeEffect::initialProperties(EffectScreen *screen)
{
    return QVariantMap{
        {QStringLiteral("effect"), QVariant::fromValue(this)},
        {QStringLiteral("targetScreen"), QVariant::fromValue(screen)},
    };
}

int CubeEffect::requestedEffectChainPosition() const
{
    return 70;
}

void CubeEffect::grabbedKeyboardEvent(QKeyEvent *e)
{
    if (e->type() == QEvent::KeyPress) {
        if (m_toggleShortcut.contains(e->key() | e->modifiers())) {
            toggle();
            return;
        }
    }
    QuickSceneEffect::grabbedKeyboardEvent(e);
}

void CubeEffect::toggle()
{
    if (isRunning()) {
        deactivate();
    } else {
        activate();
    }
}

void CubeEffect::activate()
{
    if (effects->isScreenLocked()) {
        return;
    }

    setRunning(true);
}

void CubeEffect::deactivate()
{
    m_shutdownTimer->start(0);
}

void CubeEffect::realDeactivate()
{
    setRunning(false);
}

qreal CubeEffect::cubeFaceDisplacement() const
{
    return m_cubeFaceDisplacement;
}

void CubeEffect::setCubeFaceDisplacement(qreal displacement)
{
    if (m_cubeFaceDisplacement != displacement) {
        m_cubeFaceDisplacement = displacement;
        Q_EMIT cubeFaceDisplacementChanged();
    }
}

qreal CubeEffect::distanceFactor() const
{
    return m_distanceFactor;
}

void CubeEffect::setDistanceFactor(qreal factor)
{
    if (m_distanceFactor != factor) {
        m_distanceFactor = factor;
        Q_EMIT distanceFactorChanged();
    }
}

} // namespace KWin
