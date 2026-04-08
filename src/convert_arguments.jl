# using Makie
export date2num

using Dates
import Makie: replace_missing, convert_arguments, convert_single_argument,
  get_ticks
import Makie: filtered_attributes

function date2num(x::T) where {T<:TypeDate}
  Makie.date_to_number(T, x)
end


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

# function convert_arguments(::Type{<:Union{HSpan,VSpan}}, low, high)
#   low = convert_single_argument(low)
#   high = convert_single_argument(high)
#   low, high
# end
# convert_arguments(::Type{<:Union{HLines,VLines}}, pos) = (convert_single_argument(pos),)

## Fix for vlines! and vspan!
# https://github.com/MakieOrg/Makie.jl/issues/4412
import Dates: AbstractTime
import Makie: date_to_number, convert_single_argument
import Makie: DimConversions, NoDimConversion, DateTimeConversion

Makie.convert_single_argument(dates::AbstractVector{T}) where {T<:Dates.AbstractTime} = date2num.(dates)
Makie.convert_single_argument(date::DateTime) = date2num(date)

Makie.convert_single_argument(dates::AbstractVector{T}) where {T<:TypeDate} = date2num.(dates)
Makie.convert_single_argument(date::T) where {T<:TypeDate} = date2num(date) |> Float32

# VSpan/HSpan: both args are x (or y) coordinates — pre-convert TypeDate to numbers
# so that add_dim_converts! is skipped and DateTimeConversion is NOT registered on the
# wrong axis dimension (e.g. y-axis for VSpan's second xmax arg).
function Makie.convert_arguments(P::Type{<:Union{Makie.HSpan, Makie.VSpan}},
  low::T, high::T) where {T<:TypeDate}
  (date2num(low), date2num(high))
end
function Makie.convert_arguments(P::Type{<:Union{Makie.HSpan, Makie.VSpan}},
  low::AbstractVector{T}, high::AbstractVector{T}) where {T<:TypeDate}
  (date2num.(low), date2num.(high))
end
# Tell Makie that (Real, Real) is the expected converted type for VSpan/HSpan,
# so got_converted() returns true and add_dim_converts! is skipped.
Makie.types_for_plot_arguments(::Type{<:Makie.VSpan}) = Tuple{Real, Real}
Makie.types_for_plot_arguments(::Type{<:Makie.HSpan}) = Tuple{Real, Real}

function Base.setindex!(conversions::DimConversions, value::DateTimeConversion, i::Int)
  isnothing(value) && return nothing # ignore no conversions
  conversions[i] === value && return nothing # ignore same conversion
  # only set new conversion if there is none yet
  # if isnothing(conversions[i]) || conversions[i] === NoDimConversion()
  conversions.conversions[i][] = value
  return nothing
  # end
end
