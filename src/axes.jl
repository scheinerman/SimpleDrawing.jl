export draw_xaxis, draw_yaxis, draw_xtick, draw_ytick


"""
`draw_xaxis(x)` draws a thin arrow from the origin to `(x,0)`.

If `x` is omitted, draws a pair of arrows from the origin 
to values 10% larger than those returned by `xlims()`.
"""
function draw_xaxis(x::Real; opts...)
    draw_vector(x,0; color=:black, linewidth=0.5, legend=false, opts...)
end

function draw_xaxis(x1::Real, x2::Real; opts...)
    draw_xaxis(x1;opts...)
    draw_xaxis(x2;opts...)
end 

function draw_xaxis(;opts...)
    x1,x2 = xlims()
    draw_xaxis(x1;opts...)
    draw_xaxis(x2;opts...)
end

"""
`draw_yaxis(y)` draws a thin arrow from the origin to `(0,y)`.

If `y` is omitted, draws a pair of arrows from the origin 
to values 10% larger than those returned by `ylims()`.
"""
function draw_yaxis(y::Real; opts...)
    draw_vector(0,y; color=:black, linewidth=0.5, opts...)
end

function draw_yaxis(y1::Real,y2::Real; opts...)
    draw_yaxis(y1;opts...)
    draw_yaxis(y2;opts...)
end


function draw_yaxis(;opts...)
    y1,y2 = ylims()
    draw_yaxis(y1;opts...)
    draw_yaxis(y2;opts...)
end

_DEFAULT_TICK_LEN = 0.2


"""
`draw_xtick(x::Real,len)` draws a tick mark on the x-axis with total length `len`.
If `len` is omitted, use `SimpleDrawing._DEFAULT_TICK_LEN`.

`draw_xtick(xlist,len)` calls `draw_xtick` for each value in `xlist`.
"""
function draw_xtick(x::Real, len=_DEFAULT_TICK_LEN; opts...)
    draw_segment(x,-len/2,x,len/2,color=:black, linewidth=0.5, opts...)
end

function draw_xtick(xlist, len=_DEFAULT_TICK_LEN; opts...)
    for x in xlist
        draw_xtick(x,len,opts...)
    end 
    plot!()
end



"""
`draw_ytick(y::Real,len)` draws a tick mark on the y-axis with total length `len`.
If `len` is omitted, use `SimpleDrawing._DEFAULT_TICK_LEN`.

`draw_xtick(ylist,len)` calls `draw_ytick` for each value in `xyist`.
"""
function draw_ytick(y::Real, len=_DEFAULT_TICK_LEN; opts...)
    draw_segment(-len/2,y,len/2,y, color=:black, linewidth=0.5, opts...)
end

function draw_ytick(ylist, len=_DEFAULT_TICK_LEN; opts...)
    for y in ylist
        draw_ytick(y,len,opts...)
    end 
    plot!()
end 