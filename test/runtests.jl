using Test, SimpleDrawing, Plots

@test non_colinear_check(im, 2im, 2im+1)
z = 1+im
@test !non_colinear_check(z,-z,2z)
