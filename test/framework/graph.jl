#TODO: implement proper tests (i.e. string comparison w/o color escapes)
@testset "graph" begin
    @testset "dependency" begin
        S = Cropbox.Context
        d = Cropbox.dependency(S)
        ds = repr(MIME("text/plain"), d)
        @test ds == "[config → clock → context]"
        n = tempname()
        @test Cropbox.writeimage(n, d; format=:svg) == n*".svg"
    end

    @testset "hierarchy" begin
        S = Cropbox.Context
        h = Cropbox.hierarchy(S)
        hs = repr(MIME("text/plain"), h)
        @test hs == "{Context, Clock}"
        n = tempname()
        @test Cropbox.writeimage(n, h; format=:svg) == n*".svg"
    end
end
