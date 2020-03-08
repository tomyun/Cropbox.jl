import DataStructures: OrderedDict

struct Tabulate{V} <: State{V}
    value::OrderedDict{Symbol,OrderedDict{Symbol,V}}
    rows::Tuple{Vararg{Symbol}}
    columns::Tuple{Vararg{Symbol}}
end

Tabulate(; unit, rows, columns=(), _value, _type, _...) = begin
    U = value(unit)
    V = valuetype(_type, U)
    matrix2dict(m, r, c, V) = OrderedDict(zip(r, [OrderedDict(zip(c, V.(m[i,:]))) for i in 1:size(m, 1)]))
    columns = isempty(columns) ? rows : columns
    v = matrix2dict(_value, rows, columns, V)
    Tabulate{V}(v, rows, columns)
end

genvartype(v::VarInfo, ::Val{:Tabulate}; V, _...) = @q Tabulate{$V}

geninit(v::VarInfo, ::Val{:Tabulate}) = geninitvalue(v, parameter=true)

genupdate(v::VarInfo, ::Val{:Tabulate}, ::MainStep) = nothing
