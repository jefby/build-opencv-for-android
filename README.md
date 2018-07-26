# Build-opencv-for-android (Depreciated)

An interactive script to download and build opencv and opencv_contrib for android

### Requirements
 - Python >=2.4
 - CMake >=2.8

### Installation
```sh
$ git clone https://github.com/jefby/build-opencv-for-android
$ cd build-opencv-for-android
$ git clone https://github.com/opencv/opencv && git checkout 3.4.2
$ git clone https://github.com/opencv/opencv_contrib && git checkout 3.4.2
$ 设置ANDROID_NDK_ROOT为ndk根路径

```

```sh
$ ./build-android-opencv.sh
```

The final library will be located in android_opencv folder

### Liecnese
Copyright (c) 2016 Tzutalin
Create by TzuTaLin <tzu.ta.lin@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
