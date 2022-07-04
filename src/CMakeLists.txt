# SPDX-FileCopyrightText: 2022 Vlad Zahorodnii <vlad.zahorodnii@kde.org>
#
# SPDX-License-Identifier: BSD-3-Clause

add_subdirectory(kcm)

add_library(kwin4_effect_cube SHARED)
target_sources(kwin4_effect_cube PRIVATE
    cubeeffect.cpp
    main.cpp
)
kconfig_add_kcfg_files(kwin4_effect_cube cubeconfig.kcfgc)

target_link_libraries(kwin4_effect_cube
    Qt::Core
    Qt::Gui
    Qt::Quick

    KF5::ConfigCore
    KF5::ConfigGui
    KF5::CoreAddons
    KF5::GlobalAccel
    KF5::I18n
    KF5::WindowSystem

    KWinEffects::kwineffects
)

install(TARGETS kwin4_effect_cube DESTINATION ${PLUGIN_INSTALL_DIR}/kwin/effects/plugins/)
install(DIRECTORY qml DESTINATION ${KDE_INSTALL_DATADIR}/kwin/effects/cube)
