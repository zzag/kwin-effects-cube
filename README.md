# Cube effect

![Screenshot](data/screenshot.avif)

This is a basic desktop cube effect for KWin. It's primarily intended to help you
impress your friends with what one can do on "Linux."

[Demo](https://www.youtube.com/watch?v=awAw0-hWL1M)


## How to use it

Go to desktop effect settings, and enable the Cube effect. Once you've done that,
the Cube effect can be activated by pressing `Meta+C` shortcut.

Note that you will need at least 3 virtual desktops in order to activate the effect.

Key navigation:

- `Escape` - quit the effect
- `Left` and `Right` arrow keys - rotate the cube left or right, respectively
- `Enter`/`Space`/`Return` - switch to the currently viewed desktop


## Installation

Arch Linux:

```sh
yay -S kwin-effects-cube-git
```


## Building from Git

You will need the following dependencies to build this effect:

* CMake
* any C++14 enabled compiler
* Qt
* libkwineffects
* KDE Frameworks 5:
    - Config
    - CoreAddons
    - Extra CMake Modules
    - GlobalAccel
    - WindowSystem

On Arch Linux

```sh
sudo pacman -S cmake extra-cmake-modules kwin
```

On Fedora

```sh
sudo dnf install cmake extra-cmake-modules kf5-kconfig-devel \
    kf5-kcoreaddons-devel kf5-kwindowsystem-devel kf5-globalaccel-devel \
    kf5-xmlgui-devel kwin-devel qt5-qtbase-devel
```

On Ubuntu

```sh
sudo apt install cmake extra-cmake-modules kwin-dev \
    libkf5config-dev libkf5configwidgets-dev libkf5coreaddons-dev \
    libkf5windowsystem-dev libkf5globalaccel-dev libkf5xmlgui-dev qtbase5-dev
```

After you installed all the required dependencies, you can build
the effect:

```sh
git clone https://github.com/zzag/kwin-effects-cube.git
cd kwin-effects-cube
cmake -B build -S . \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr
cmake --build build --parallel
cmake --install build
```
