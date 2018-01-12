function rcopy(::Type{AxisArray}, r::Ptr{S}) where {S<:VectorSxp}
    dnames = getattrib(r, Const.DimNamesSymbol)
    isnull(dnames) && error("r has no dimnames")
    dsym = rcopy(Array{Symbol}, getnames(dnames))
    AxisArray(rcopy(AbstractArray, r),
             [Axis{dsym[i]}(rcopy(n)) for (i,n) in enumerate(dnames)]...)
end

function sexp(aa::AxisArray)
    rv = protect(sexp(aa.data))
    try
        d = OrderedDict(
            k => v.val for (k, v) in zip(axisnames(aa), axes(aa)))
        setattrib!(rv, Const.DimSymbol, collect(size(aa)))
        setattrib!(rv, Const.DimNamesSymbol, d)
    finally
        unprotect(1)
    end
    rv
end
