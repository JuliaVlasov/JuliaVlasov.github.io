# This file was generated, do not modify it. # hide
struct UniformMesh

   start    :: Float64
   stop     :: Float64
   length   :: Int64
   step     :: Float64
   points   :: Vector{Float64}

   function UniformMesh(start, stop, length::Int; endpoint=true)

       points = range(start, stop=stop, length=length+1)[1:end-1]
       step = (stop - start) / length

       new( start, stop, length, step, points)

   end

end