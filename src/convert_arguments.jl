# using Makie
using Dates

import Makie: replace_missing, convert_arguments, convert_single_argument,
  get_ticks, Automatic

Makie.convert_single_argument(dates::AbstractVector{<:TypeDate}) = date2num.(dates)
Makie.convert_single_argument(date::TypeDate) = date2num(date) |> Float32

function Makie.convert_arguments(T::PointBased,
  x::Union{TypeDate,AbstractVector{<:TypeDate}}, args...)

  x = convert_single_argument(x)
  args = convert_single_argument.(args)
  convert_arguments(T, x, args...)
end

function Makie.convert_arguments(T::Type{<:Series}, x::AbstractVector{<:TypeDate}, y::AbstractMatrix)
  x = convert_single_argument(x)
  convert_arguments(T, x, y)
end

function Makie.convert_arguments(::Type{<:Series}, x::AbstractVector, y::AbstractVector)
  x = convert_single_argument(x)
  points = Point2f.(replace_missing.(x), replace_missing.(y))
  ([points],)
end

function convert_arguments(::Type{<:Union{HSpan,VSpan}}, low, high)
  low = convert_single_argument(low)
  high = convert_single_argument(high)
  low, high
end

convert_arguments(::Type{<:Union{HLines,VLines}}, pos) = (convert_single_argument(pos),)
