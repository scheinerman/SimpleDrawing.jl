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
