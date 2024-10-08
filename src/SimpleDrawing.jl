module SimpleDrawing
using LinearAlgebra
using Plots

export newdraw, draw_circle, draw_arc, draw_segment, draw_point, draw_vector, draw_polygon
export draw_ellipse, draw_filled_ellipse
export draw_rectangle, find_center, non_colinear_check
export finish, draw, draw!

"""
    newdraw()

`newdraw()` clears the screen and sets up a blank drawing canvas with
no axis, grid, or legend, and sets the aspect ratio to 1.
"""
function newdraw()
    plot(aspectratio = 1, legend = false, axis = false, grid = false, ticks = false)
end

# For use by packages that rely on this one.
function draw() end
function draw(::Nothing) end
function draw!() end
function draw!(::Nothing) end

"""
    draw_circle(x,y,r) 
    
Draw a circle centered
at `(x,y)` with radius `r`.

Also: `draw_circle(z,r)` where `z` is complex.
"""
function draw_circle(x::Real, y::Real, r::Real; opts...)
    f(t) = r * cos(t) + x
    g(t) = r * sin(t) + y
    plot!(f, g, 0, 2pi; opts...)
end

draw_circle(z::Complex, r::Real; opts...) = draw_circle(real(z), imag(z), r; opts...)

"""
    draw_circle(a,b,c)

Draw a circle through the points given by
the three complex arguments.
"""
function draw_circle(a::Complex, b::Complex, c::Complex; opts...)
    z = find_center(a, b, c)
    r = abs(a - z)
    x, y = reim(z)
    draw_circle(x, y, r; opts...)
end


export draw_disc

"""
    draw_disc(x,y,r)

Draw a disc centered at `(x,y)` and with radius `r`. May also be invoked as:
* `draw_disc(z,r)` where `z` is complex.
* `draw_disc(a,b,c)` where `a,b,c` are complex which gives a disc passing through `a`, `b`, and `c`.

For example: `draw_disc(0,1,3; color=:yellow, linecolor=:red)`
"""
function draw_disc(x::Real, y::Real, r::Real; opts...)
    draw_circle(x, y, r, seriestype = [:shape], fillalpha = 1; opts...)
end

function draw_disc(z::Complex, r::Real; opts...)
    draw_disc(real(z), imag(z), r; opts...)
end

function draw_disc(a::Complex, b::Complex, c::Complex; opts...)
    z = find_center(a, b, c)
    r = abs(a - z)
    x, y = reim(z)
    draw_disc(x, y, r; opts...)
end




"""
    draw_ellipse(x::Real, y::Real, rx::Real, ry::Real; opts...)
    draw_ellipse(z::Complex, rx::Real, ry::Real; opts...) 

Draw an axis-parallel ellipse centered at `(x,y)` [at `z`] with x-radius `rx`
and y-radius `ry`.
"""
function draw_ellipse(x::Real, y::Real, rx::Real, ry::Real; opts...)
    f(t) = rx * cos(t) + x
    g(t) = ry * sin(t) + y
    plot!(f, g, 0, 2pi; opts...)
end

draw_ellipse(z::Complex, rx::Real, ry::Real; opts...) =
    draw_ellipse(real(z), imag(z), rx, ry; opts...)


"""
    draw_filled_ellipse(x::Real, y::Real, rx::Real, ry::Real; opts...)
    draw_filled_ellipse(z::Complex, rx::Real, ry::Real; opts...) 

Same as `draw_ellipse` but colored in. 
"""
function draw_filled_ellipse(x::Real, y::Real, rx::Real, ry::Real; opts...)
    draw_ellipse(x, y, rx, ry, fillalpha = 1, seriestype = [:shape]; opts...)
end

draw_filled_ellipse(z::Complex, rx::Real, ry::Real; opts...) =
    draw_filled_ellipse(real(z), imag(z), rx::Real, ry::Real; opts...)

"""
    draw_arc(x::Real, y::Real, r::Real, t1::Real, t2::Real; opts...)

`draw_arc(x,y,r,t1,t2)` draws the shorter arc centered at `(x,y)`
with radius `r` between angles `t1` and `t2`.
"""
function draw_arc(x::Real, y::Real, r::Real, t1::Real, t2::Real; opts...)
    f(t) = r * cos(t) + x
    g(t) = r * sin(t) + y

    plot!(f, g, t1, t2; opts...)
end



"""
    draw_arc(a::Complex, b::Complex, c::Complex; opts...)

`draw_arc(a,b,c)` where the arguments are `Complex`: Draw the
arc from `a` through `b` to `c`.
"""
function draw_arc(a::Complex, b::Complex, c::Complex; opts...)
    m2pi(x::Real) = mod(x, 2π)

    z = find_center(a, b, c)
    x, y = reim(z)
    r = abs(b - z)
    ta = m2pi(angle(a - z))
    tb = m2pi(angle(b - z))
    tc = m2pi(angle(c - z))

    if ta > tc
        ta, tc = tc, ta
    end


    if ta < tb < tc
        return draw_arc(x, y, r, ta, tc; opts...)
    end


    return draw_arc(x, y, r, tc - 2pi, ta; opts...)
end



"""
    draw_segment(a::Real, b::Real, c::Real, d::Real; opts...)

`draw_segment(x,y,xx,yy)` draws a line segment from `(x,y)` to
`(xx,yy)`. Also `draw_segment(z,zz)` for `Complex` arguments.
"""
function draw_segment(a::Real, b::Real, c::Real, d::Real; opts...)
    plot!([a, c], [b, d]; opts...)
end

function draw_segment(a::Complex, b::Complex; opts...)
    x, y = reim(a)
    xx, yy = reim(b)
    draw_segment(x, y, xx, yy; opts...)
end


"""
    draw_point(x::Real, y::Real; opts...)

`draw_point(x,y)` [or `draw_point(z)`] draws a point at coordinates `(x,y)`
[or complex location `z`].

`draw_point(list)` plots all the points in the one-dimensional `list` of
complex values.
"""
function draw_point(x::Real, y::Real; opts...)
    plot!([x], [y]; marker = 1, opts...)
end

draw_point(z::Complex; opts...) = draw_point(real(z), imag(z); opts...)

function draw_point(pts::Array{Complex{T},1}; opts...) where {T}
    for p in pts
        draw_point(p; opts...)
    end
    plot!()
end

"""
    draw_rectangle(x::Real, y::Real, xx::Real, yy::Real; opts...)

`draw_rectangle(x,y,xx,yy)` draws a rectangle with opposite corners
`(x,y)` and `(xx,yy)`.  May also be called with complex arguments
`draw_rectangle(w,z)`.
"""
function draw_rectangle(x::Real, y::Real, xx::Real, yy::Real; opts...)
    xlist = [x, xx, xx, x, x]
    ylist = [y, y, yy, yy, y]
    plot!(xlist, ylist; opts...)
end

function draw_rectangle(w::Complex, z::Complex; opts...)
    draw_rectangle(real(w), imag(w), real(z), imag(z); opts...)
end

"""
    draw_polygon(pts::Vector{Complex{T}}; opts...) where {T}
    draw_polygon(xvals, yvals; opts...)
Draw a polygon whose vertices are specified in the list `pts`
containing complex numbers. 
"""
function draw_polygon(pts::Vector{Complex{T}}; opts...) where {T}
    draw_polygon(real(pts), imag(pts); opts...)
end

function draw_polygon(xs::Vector{S}, ys::Vector{T}; opts...) where {S<:Real,T<:Real}
    xx = [xs; xs[1]]
    yy = [ys; ys[1]]
    plot!(xx, yy; opts...)
end




"""
`draw_vector` is used to draw vectors (line segments with an arrow at one end).
The variations are:
+ `draw_vector(x,y)` draws a vector from the origin to `(x,y)`.
+ `draw_vector(x,y,basex,basey)` draws a vector from `(basex,basey)` to
`(basex+x,basey+y)`.
+ `draw_vector(z)` draws a vector from the origin to the complex value `z`.
+ `draw_vector(z,basez)` draws a vector from the complex location `basez` to
`z+basez`.
"""
draw_vector(x::Real, y::Real; opts...) = draw_segment(0, 0, x, y; arrow = :arrow, opts...)

draw_vector(z::Complex; opts...) = draw_segment(0 + 0im, z; arrow = :arrow, opts...)

draw_vector(x::Real, y::Real, basex::Real, basey::Real; opts...) =
    draw_segment(basex, basey, basex + x, basey + y; arrow = :arrow, opts...)

draw_vector(z::Complex, basez::Complex; opts...) =
    draw_segment(basez, basez + z; arrow = :arrow, opts...)


"""
    finish()

`finish()` is used to clean up a drawing after various calls to `draw`.
It removes the axes and the grid lines, and sets the aspect ratio to one.
"""
function finish()
    plot!(aspectratio = 1, legend = false, axis = false, grid = false, ticks = false)
end



export find_center, non_colinear_check

"""
    find_center(a::Complex, b::Complex, c::Complex)::Complex

`find_center(a,b,c)`: Given three points in the complex plane,
find the point `z` that is equidistant from all three. If the three
points are collinear then return `Inf + Inf*im`.
"""
function find_center(a::Complex, b::Complex, c::Complex)::Complex
    if !non_colinear_check(a, b, c)
        return Inf + im * Inf
    end
    A = collect(reim(a))
    B = collect(reim(b))
    C = collect(reim(c))
    AB = 0.5 * (A + B)
    BC = 0.5 * (B + C)
    M = [(A - B)'; (B - C)']
    rhs = [dot(AB, A - B), dot(BC, B - C)]

    Z = M \ rhs
    return Z[1] + im * Z[2]
end

"""
    non_colinear_check(a::Complex, b::Complex, c::Complex)::Bool

`non_colinear_check(a,b,c)`: test if the complex numbers are distinct
and noncollinear.
"""
function non_colinear_check(a::Complex, b::Complex, c::Complex)::Bool
    if a == b || b == c || a == c
        return false
    end
    z = (b - a) / (c - a)
    return imag(z) != 0
end

"""
    resize_gr_window(wide=800, tall=600)

Change the size of the `gr` drawing window. This is particularly 
useful in VS code.
"""
function resize_gr_window(wide::Int = 800, tall::Int = 600)
    gr(size = (wide, tall))
end
export resize_gr_window



include("cubic.jl")
include("curve.jl")
include("myspy.jl")
include("axes.jl")
include("expand_canvas.jl")
end
