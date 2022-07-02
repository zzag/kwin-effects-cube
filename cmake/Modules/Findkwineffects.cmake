#.rst:
# Findkwineffects
# ---------------
#
# Try to find libkwineffects.
#
# This is a component-based find module, which makes use of the COMPONENTS
# argument to find_modules. The following components are
# available::
#
#   kwineffects
#   kwinglutils
#   kwinxrenderutils
#
# If no components are specified, this module will act as though all components
# were passed to OPTIONAL_COMPONENTS.
#
# This module will define the following variables, independently of the
# components searched for or found:
#
# ``kwineffects_FOUND``
#     True if (the requestion version of) libkwineffects is available
# ``kwineffects_TARGETS``
#     A list of all targets imported by this module (note that there may be more
#     than the components that were requested)
# ``kwineffects_LIBRARIES``
#     This can be passed to target_link_libraries() instead of the imported
#     targets
# ``kwineffects_INCLUDE_DIRS``
#     This should be passed to target_include_directories() if the targets are
#     not used for linking
# ``kwineffects_DEFINITIONS``
#     This should be passed to target_compile_options() if the targets are not
#     used for linking
#
# For each searched-for components, ``kwineffects_<component>_FOUND`` will be
# set to true if the corresponding libkwineffects library was found, and false
# otherwise.  If ``kwineffects_<component>_FOUND`` is true, the imported target
# ``kwineffects::<component>`` will be defined.

# SPDX-FileCopyrightText: 2020 Vlad Zahorodnii <vlad.zahorodnii@kde.org>
# SPDX-License-Identifier: MIT

include(ECMFindModuleHelpers)
ecm_find_package_version_check(kwineffects)

set(kwineffects_known_components
    kwineffects
    kwinglutils
    kwinxrenderutils
)

set(kwineffects_kwineffects_header "kwineffects.h")
set(kwineffects_kwineffects_lib "kwineffects")
set(kwineffects_kwinglutils_header "kwinglutils.h")
set(kwineffects_kwinglutils_lib "kwinglutils")
set(kwineffects_kwinxrenderutils_header "kwinxrenderutils.h")
set(kwineffects_kwinxrenderutils_lib "kwinxrenderutils")

ecm_find_package_parse_components(kwineffects
    RESULT_VAR kwineffects_components
    KNOWN_COMPONENTS ${kwineffects_known_components}
)

ecm_find_package_handle_library_components(kwineffects
    COMPONENTS ${kwineffects_components}
)

find_package_handle_standard_args(kwineffects
    FOUND_VAR
        kwineffects_FOUND
    REQUIRED_VARS
        kwineffects_LIBRARIES
    HANDLE_COMPONENTS
)
