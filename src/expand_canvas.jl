export expand_canvas


"""
    expand_canvas(factor = 0.05)

Increase the size of the drawing canvas.
"""
function expand_canvas(factor = 0.05)
    a, c = xlims()
    b, d = ylims()

    dx = c - a
    dy = d - b

    aa = a - factor * dx
    bb = b - factor * dy
    cc = c + factor * dx
    dd = d + factor * dy

    draw_point(aa, bb, marker = 0)
    draw_point(cc, dd, marker = 0)
end