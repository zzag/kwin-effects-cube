/*
    SPDX-FileCopyrightText: 2021 Vlad Zahorodnii <vlad.zahorodnii@kde.org>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

#include "cubeeffect.h"

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
        deactivate(250);
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

void CubeEffect::deactivate(int timeout)
{
    m_shutdownTimer->start(timeout);
}

void CubeEffect::realDeactivate()
{
    setRunning(false);
}

} // namespace KWin
