@require "github.com/jkroso/Promises.jl" Future needed

abstract type Stream end

struct StreamNode <: Stream
  head::Any
  tail::Any
end

struct EndOfStream <: Stream end

const EOS = EndOfStream()

"""
`Ports` provide access to an eagerly generated infinite stream without
using infinite memory. It does this by droping the head of the stream
every time a new value is added
"""
mutable struct Port
  cursor::Future{Stream}
end

Port() = Port(Future{Stream}())

Base.iterate(p::Port) = begin
  s = wait(p.cursor)
  s == EOS ? nothing : (s.head, s.tail)
end
Base.iterate(::Any, f::Future) = begin
  s = wait(f)
  s == EOS ? nothing : (s.head, s.tail)
end

Base.close(p::Port) = put!(p.cursor, EOS)
Base.isopen(p::Port) = p.cursor.state <= needed

Base.put!(p::Port, value::Any) = begin
  rest = Future{Stream}()
  put!(p.cursor, StreamNode(value, rest))
  p.cursor = rest
  p
end

Base.take!(p::Port) = begin
  s = wait(p.cursor)
  s ≡ EOS && error("can't `take!` from a closed port")
  p.cursor = s.tail
  s.head
end
