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



function open_spline(y::Array{T,1}) where T<:Number
    n = length(y)-1
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

    rhs = 3(y[2:end] - y[1:end-1])

    println(M)
    println(rhs)

    D = M\rhs

    println(D)

    a = b = c = d = zeros(n-1)

    for j=1:n-1
        a[j] = y[j]
        b[j] = D[j]
        c[j] = 3*(y[j+1]-y[j])-2D[j]-D[j+1]
        d[j] = 2*(y[j]-y[j+1])+D[j]+D[j+1]
    end


    return [ Cubic(a[i],b[i],c[i],d[i]) for i=1:n-1 ]



end
