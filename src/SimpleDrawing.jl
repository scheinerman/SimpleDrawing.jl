module SimpleDrawing
using Plots

export newdraw, draw_circle, draw_arc, draw_segment, draw_point, finish
export draw

"""
`newdraw()` clears the screen and sets up a blank drawing canvas with
no axis, grid, or legend, and sets the aspect ratio to 1.
"""
function newdraw()
    plot(aspectratio=1, legend=false, axis=false, grid=false)
end

function draw()
end

"""
`draw_circle(x,y,r)` (or `draw_circle(z,r)`) draws a circle centered
at `(x,y)` (at `z`) with radius `r`.
"""
function draw_circle(x::Real, y::Real, r::Real; opts...)
    f(t) = r*cos(t) + x
    g(t) = r*sin(t) + y
    plot!(f,g,0,2pi;opts...)
end


function draw_circle(a::Complex, b::Complex, c::Complex; opts...)
    z = find_center(a,b,c)
    r = abs(a-z)
    x,y = reim(z)
    draw_circle(x,y,r; opts...)
end


"""
`draw_arc(x,y,r,t1,t2)` draws the shorter arc centered at `(x,y)`
with radius `r` between angles `t1` and `t2`.
"""
function draw_arc(x::Real, y::Real, r::Real, t1::Real, t2::Real; opts...)
    f(t) = r*cos(t) + x
    g(t) = r*sin(t) + y

    t1 = mod(t1, 2pi)
    t2 = mod(t2, 2pi)

    if t1==t2
        return
    end

    if t1 > t2
        t1,t2 = t2,t1
    end

    if t2-t1>pi
        t1 += 2pi
    end

    plot!(f,g,t1,t2;opts...)
end

"""
`draw_arc(a,b,c)` where the arguments are `Complex`: Draw the
arc from `a` through `b` to `c`.
"""
function draw_arc(a::Complex, b::Complex, c::Complex; opts...)
    z = find_center(a,b,c)
    r = abs(b-z)
    t1 = angle(a-z)
    t2 = angle(c-z)
    draw_arc(real(z), imag(z), r, t1, t2; opts...)
end



"""
`draw_segment(x,y,xx,yy)` draws a line segment from `(x,y)` to
`(xx,yy)`. Also `draw_segment(z,zz)` for `Complex` arguments.
"""
function draw_segment(a::Real,b::Real,c::Real,d::Real; opts...)
    plot!([a,c],[b,d];opts...)
end

function draw_segment(a::Complex, b::Complex; opts...)
    x,y = reim(a)
    xx,yy = reim(b)
    draw_segment(x,y,xx,yy; opts...)
end

function draw_point(x::Real, y::Real; opts...)
    plot!([x],[y];opts...)
end

draw_point(z::Complex; opts...) = draw_point(real(z),imag(z); opts...)




"""
`finish()` is used to clean up a drawing after various calls to `draw`.
It removes the axes and the grid lines, and sets the aspect ratio to one.
"""
function finish()
    plot!(aspectratio=1, legend=false, axis=false, grid=false)
end


end
