/*
    SPDX-FileCopyrightText: 2022 Vlad Zahorodnii <vlad.zahorodnii@kde.org>

    SPDX-License-Identifier: GPL-3.0-only
*/

#include "cubeeffect.h"

namespace KWin
{

KWIN_EFFECT_FACTORY_SUPPORTED(CubeEffect, "metadata.json", return CubeEffect::supported();)

} // namespace KWin

#include "main.moc"
