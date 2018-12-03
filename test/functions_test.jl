using Dates, AxisArrays
# findmax
d = collect(DateTime(2003,1,1):Day(1):DateTime(2005,12,31))

data = Array{Float64,3}(undef, 2, 2,1096)
data[1,1,:] = collect(1.0:1096.0); data[1,2,:] = collect(1.0:1096.0); data[2,1,:]=collect(1.0:1096.0); data[2,2,:] = collect(1.0:1096.0);
data[1,1,1] = NaN

# ClimGrid based tests
axisdata = AxisArray(data, Axis{:lon}(1:2), Axis{:lat}(1:2), Axis{:time}(d))
C = ClimateTools.ClimGrid(axisdata, variable = "pr")
@test isnan(findmin(C)[1])
@test findmin(C)[2] == CartesianIndex(1,1,1)
@test isnan(findmax(C)[1])
@test findmax(C)[2] == CartesianIndex(1,1,1)
@test findmin(C, skipnan=true) == (1.0, CartesianIndex(2,1,1))
@test findmax(C, skipnan=true) == (1096.0, CartesianIndex(1,1,1096))

# Monthly means
D = monthmean(C)
@test size(D[1]) == (2, 2, 36)
@test isnan(D[1][1, 1, 1])
@test D[1][2,1,1] == 16.0
@test D[1][2,2,1] == 16.0
@test D[1][2,2,end] == 1081.0
timevec = get_timevec(D)
@test timevec[1] == DateTime(2003,01,01,00,00,00)
@test timevec[end] == DateTime(2005,12,01,00,00,00)
