# This file was generated, do not modify it. # hide
"""
    UniformMesh(xmin, xmax, nx)

1D uniform mesh data
"""
struct UniformMesh
   xmin  :: Float64
   xmax  :: Float64
   nx    :: Int
   dx    :: Float64
   x     :: Vector{Float64}
   function UniformMesh(xmin, xmax, nx)
      dx = (xmax - xmin) / nx
      x  = range(xmin, stop=xmax, length=nx+1)[1:end-1]     
      new( xmin, xmax, nx, dx, x)
   end
end