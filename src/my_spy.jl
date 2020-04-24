export my_spy

"""
`my_spy(A::Matrix)` creates a black-and-white image of `A` in which
zeros are white squares and nonzeros are black.
"""
function my_spy(A::Matrix{T}, borders::Bool=false) where T<:Number
    newdraw()
    r,c = size(A)
    for i=1:r
        for j=1:c
            x = j
            y = -i
            if A[i,j] == 0
                draw_rectangle(x-1,y+1,x,y,line=borders, color=:black, fill=true, fillcolor=:white)
            else
                draw_rectangle(x-1,y+1,x,y,line=borders, color=:black, fill=true, fillcolor=:black)
            end
        end
    end
    finish()
end
