@testset "solve" begin
    @testset "basic" begin
        @system SSolve(Controller) begin
            a ~ preserve(parameter)
            b ~ preserve(parameter)
            c ~ preserve(parameter)
            x(x, a, b, c) => begin
                a*x^2 + b*x + c
            end ~ solve
        end
        s1 = instance(SSolve, config=:SSolve => (a=1, b=2, c=1))
        @test s1.x' == -1
        s2 = instance(SSolve, config=:SSolve => (a=1, b=-2, c=1))
        @test s2.x' == 1
        s3 = instance(SSolve, config=:SSolve => (a=1, b=2, c=-3))
        @test s3.x' == 1
        s4 = instance(SSolve, config=:SSolve => (a=1, b=-2, c=-3))
        @test s4.x' == 3
    end

    @testset "unit" begin
        @system SSolveUnit(Controller) begin
            a ~ preserve(u"m^-1", parameter)
            b ~ preserve(parameter)
            c ~ preserve(u"m", parameter)
            x(x, a, b, c) => begin
                a*x^2 + b*x + c
            end ~ solve(u"m")
        end
        s = instance(SSolveUnit, config=:SSolveUnit => (a=1, b=2, c=1))
        @test s.x' == -1u"m"
    end

    @testset "unit with scale" begin
        @system SSolveUnitScale(Controller) begin
            a ~ preserve(u"m^-1", parameter)
            b ~ preserve(u"cm/m", parameter) #HACK: caution with dimensionless unit!
            c ~ preserve(u"cm", parameter)
            x(x, a, b, c) => begin
                a*x^2 + b*x + c
            end ~ solve(u"cm")
        end
        s = instance(SSolveUnitScale, config=:SSolveUnitScale => (a=0.01, b=2, c=1))
        @test s.x' == -1u"cm"
    end

    @testset "root" begin
        @system SSolveRootUpper(Controller) begin
            x(x) => (x^2 + 2x - 3) ~ solve(root=:upper)
        end
        @system SSolveRootLower(Controller) begin
            x(x) => (x^2 + 2x - 3) ~ solve(root=:lower)
        end
        s1 = instance(SSolveRootUpper)
        s2 = instance(SSolveRootLower)
        @test s1.x' == 1
        @test s2.x' == -3
    end
end