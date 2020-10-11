@testset "track" begin
    @testset "basic" begin
        @system STrack(Controller) begin
            a => 1 ~ track
            b => 2 ~ track
            c(a, b) => a + b ~ track
        end
        s = instance(STrack)
        @test s.a' == 1 && s.b' == 2 && s.c' == 3
    end

    @testset "cross reference" begin
        @test_throws LoadError @eval @system STrackXRef(Controller) begin
            a(b) => b ~ track
            b(a) => a ~ track
        end
    end

    @testset "minmax" begin
        @system STrackMinMax(Controller) begin
            a => 0 ~ track(min=1)
            b => 0 ~ track(max=2)
            c => 0 ~ track(min=1, max=2)
        end
        s = instance(STrackMinMax)
        @test s.a' == 1
        @test s.b' == 0
        @test s.c' == 1
    end

    @testset "minmax unit" begin
        @system STrackMinMaxUnit(Controller) begin
            a => 0 ~ track(u"m", min=1)
            b => 0 ~ track(u"m", max=2u"cm")
            c => 0 ~ track(u"m", min=1u"cm", max=2)
        end
        s = instance(STrackMinMaxUnit)
        @test s.a' == 1u"m"
        @test s.b' == 0u"m"
        @test s.c' == 1u"cm"
    end

    @testset "round" begin
        @system STrackRound(Controller) begin
            a => 1.5 ~ track(round)
            b => 1.5 ~ track(round=:round)
            c => 1.5 ~ track(round=:ceil)
            d => -1.5 ~ track(round=:floor)
            e => -1.5 ~ track(round=:trunc)
        end
        s = instance(STrackRound)
        @test s.a' === s.b'
        @test s.b' === 2.0
        @test s.c' === 2.0
        @test s.d' === -2.0
        @test s.e' === -1.0
    end

    @testset "round int" begin
        @system STrackRoundInt(Controller) begin
            a => 1.5 ~ track::Int(round)
            b => 1.5 ~ track::Int(round=:round)
            c => 1.5 ~ track::Int(round=:ceil)
            d => -1.5 ~ track::Int(round=:floor)
            e => -1.5 ~ track::Int(round=:trunc)
        end
        s = instance(STrackRoundInt)
        @test s.a' === s.b'
        @test s.b' === 2
        @test s.c' === 2
        @test s.d' === -2
        @test s.e' === -1
    end

    @testset "round int unit" begin
        @system STrackRoundIntUnit(Controller) begin
            a => 1.5 ~ track::Int(u"d", round)
            b => 1.5 ~ track::Int(u"d", round=:round)
            c => 1.5 ~ track::Int(u"d", round=:ceil)
            d => -1.5 ~ track::Int(u"d", round=:floor)
            e => -1.5 ~ track::Int(u"d", round=:trunc)
        end
        s = instance(STrackRoundIntUnit)
        @test s.a' === s.b'
        @test s.b' === 2u"d"
        @test s.c' === 2u"d"
        @test s.d' === -2u"d"
        @test s.e' === -1u"d"
    end
end
