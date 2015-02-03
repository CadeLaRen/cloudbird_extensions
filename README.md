# CloudBird Extensions
Open-source Cython extensions for CloudBird

CloudBird is a game I'm developing. I'm not going to release its source code right away, I'm going to keep it closed-source for a while, then open-source it, but I decided to release some of its components.

Polygon
=======

This little library can be imported and custom widgets can use multiple inheritance to inherit from both Polygon and any widget. You set some the vertices of the polygon (relative to the widget with pos = 0, 0 and scale/dp = 1) and you'll only have to update the scale (put dp(1) in there if you're only using density-independent pixels). Collisions will be checked only against that polygon. Two polygons can be checked for collision (even with just collide_widget), as well as points and other widgets. The position of the widget/polygon will be automatically taken into account.

SmoothAccelerometer
===================

It's a wrapper for plyer's accelerometer. Just import SmoothAccelerometer and pass plyer's accelerometer to it. The usage is the same as plyer's, but the values will be 'a lot' smoother.

Building
--------

Both are Cython modules. I'm going to make a distutils script to build them, in the meantime use these instructions:

http://docs.cython.org/src/reference/compilation.html#compiling-from-the-command-line

License
-------

This software is licensed under the GNU GPL v2 license.
Copyright Davide Depau 2015
