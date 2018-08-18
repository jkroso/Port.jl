@require "." Port
using Distributed

port = Port()
r = @spawn take!(port)
sleep(0)
put!(port, 1)
@test fetch(r) ≡ 1
@test isopen(port)
close(port)
@test !isopen(port)
