export Cubic, Spline, npatches


# see http://mathworld.wolfram.com/CubicSpline.html

import Base: getindex, show

"""
`Cubic(a,b,c,d)` is a 3rd degree polynomial `a+bx+cx^2+dx^3`.
Use `f(x)` to evalue `f` at the value `x`.
"""
struct Cubic
    a::Number
    b::Number
    c::Number
    d::Number
end

(f::Cubic)(x::Number) = f.a + x*(f.b + x*(f.c+x*f.d))

"""
`f'` where `f` is a `Cubic` is a new cubic that is the derivative
of `f`.
"""
Base.adjoint(f::Cubic) = Cubic(f.b,2f.c,3f.d,0)

struct Spline
    patches::Array{Cubic,1}
    closed::Bool
end

is_closed(S::Spline) = S.closed


function Spline(y::Array{T,1}) where T<:Number
    if y[1] == y[end]
        return closed_spline(y)
    end
    return open_spline(y)
end

function npatches(S::Spline)
    return length(S.patches)
end

function show(io::IO, S::Spline)
    adjective = is_closed(S) ? "Closed" : "Open"
    print(io, "$adjective spline with $(npatches(S)) patches")
end


getindex(S::Spline, idx::Int) = S.patches[idx]

function (S::Spline)(x::Real)
    np = npatches(S)


    if is_closed(S)
        x = mod(x,np)

        if p==0
            p = np
        end
        f = S[p]
        return f(x-p)
    end

    p = Int(floor(x))
    if p > np
        p = np
    end
    if p < 1
        p= 1
    end
    f = S[p]
    return f(x-p)
end


function open_spline(y::Array{T,1})::Spline where T<:Number
    n = length(y)
    M = zeros(n,n)
    for i=1:n
        M[i,i] = 4
    end
    M[1,1] = 2
    M[n,n] = 2

    for i=1:n-1
        M[i,i+1] = 1
        M[i+1,i] = 1
    end

    rhs = zeros(Number,n)
    rhs[1] = 3*(y[2]-y[1])
    for k=2:n-1
        rhs[k] = 3*(y[k+1]-y[k-1])
    end
    rhs[n] = 3*(y[n]-y[n-1])

    D = M\rhs

    a = zeros(Number,n-1)
    b = zeros(Number,n-1)
    c = zeros(Number,n-1)
    d = zeros(Number,n-1)

    for j=1:n-1
        a[j] = y[j]
        b[j] = D[j]
        c[j] = 3*(y[j+1]-y[j])-2D[j]-D[j+1]
        d[j] = 2*(y[j]-y[j+1])+D[j]+D[j+1]
    end
    return Spline( [ Cubic(a[i],b[i],c[i],d[i]) for i=1:n-1 ] , false)
end


function closed_spline(y::Array{T,1})::Spline where T <: Number
    n = length(y)
    M = zeros(n,n)
    for i=1:n
        M[i,i] = 4
    end
    M[1,n] = 1
    M[n,1] = 1

    rhs = zeros(Number,n)
    rhs[1] = 3*(y[2]-y[n])
    for k=2:n-1
        rhs[k] = 3*(y[k+1]-y[k-1])
    end
    rhs[n] = 3(y[1]-y[n-1])
    D = M\rhs

    a = zeros(Number,n-1)
    b = zeros(Number,n-1)
    c = zeros(Number,n-1)
    d = zeros(Number,n-1)

    for j=1:n-1
        a[j] = y[j]
        b[j] = D[j]
        c[j] = 3*(y[j+1]-y[j])-2D[j]-D[j+1]
        d[j] = 2*(y[j]-y[j+1])+D[j]+D[j+1]
    end
    return Spline( [ Cubic(a[i],b[i],c[i],d[i]) for i=1:n-1 ], true )
end
