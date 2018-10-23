# SimpleDrawing

This package provides some convenient drawing tools derived from the
`Plots` module. It also defines the `draw()` function that can be extended
by other modules including `DrawSimpleGraphs`, `HyperbolicPlane`, and
(under development) poset drawing for `SimplePosets`.

## Functions

+ `newdraw()` presents a blank canvas on which to draw (and erases anything)
that's already in that window.

+ `draw_point(x::Real,y::Real;opts...)` plots a point (small disk). This
may also be invoked as `draw_point(z::Complex)`.
+ `draw_segment(x::Real,y::Real,xx::Real,yy::Real;opts...)` draws a
line segment from `(x,y)` to `(xx,yy)`. May also be invoked as
`draw_segment(z::Complex,zz::Complex)`.
+ `draw_arc(x::Real,y::Real,r::Real,t1::Real,t2::Real;opts...)` draws an
arc of a circle centered at `(x,y)`, with radius `r`, and arcing between
angles `t1` and `t2`. **Note**: This always draws the *shorter* arc.
When invoked as `draw_arc(a::Complex,b::Complex,c::Complex;args...)` draws
the arc with end points `a` and `c` passing through `b`.
+ `draw_circle(x::Real,y::Real,r::Real;args...)` draws a circle centered
at `(x,y)` with radius `r`. Also `draw_circle(z::Complex,r::Real;args...)`.

+ `finish()` ensures that the figure appears on the screen with
aspect ratio equal to 1, and that
we hide the axes, grid, and legend.


+ `draw()` does nothing. It is a placeholder function for other modules to
override.

### Supporting Functions

+ `find_center(a,b,c)` returns the center of the circle that passes through
the three points (represented as complex numbers). Returns
`inf + inf*im` if the points are collinear.

+ `non_collinear_check(a,b,c)` checks if the three points (represented as
  complex numbers) are noncollinear; returns `true` if so and `false` if they
  are collinear (including if two are the same).
