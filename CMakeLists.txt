cmake_minimum_required(VERSION 3.0)
project(kwin-effects-cube)

set(KF_MIN_VERSION "5.240.0")
set(QT_MIN_VERSION "6.4.0")

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

find_package(ECM ${KF_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH})

include(FeatureSummary)
include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings NO_POLICY_SCOPE)

find_package(Qt6 ${QT_MIN_VERSION} REQUIRED COMPONENTS
    Core
    DBus
    Gui
    Quick
)

find_package(KF6 ${KF_MIN_VERSION} REQUIRED COMPONENTS
    Config
    ConfigWidgets
    CoreAddons
    GlobalAccel
    I18n
    KCMUtils
    WindowSystem
    XmlGui
)

find_package(epoxy REQUIRED)
find_package(XCB REQUIRED COMPONENTS XCB)

find_package(KWinEffects 5.27.0 REQUIRED COMPONENTS
    kwineffects
)

find_package(KWinDBusInterface CONFIG REQUIRED)

add_subdirectory(src)

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
