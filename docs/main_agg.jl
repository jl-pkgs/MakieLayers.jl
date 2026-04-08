function fix_360lon(lon::AbstractVector)
  mid = round(Int, length(lon) / 2)
  [lon[mid+1:end] .- 360; lon[1:mid]]
end

function fix_360lon(A::AbstractArray{<:Real, 3})
  nlon = size(A, 1)
  mid = round(Int, nlon / 2)
  A[[mid+1:end; 1:mid], :, :]
end

function agg_chunk(A; chunk=5)
  ntime = size(A, 3)
  by2 = ceil.(Int, collect((1:ntime) / chunk))
  agg_time(A, by2; fun=mean)
end

function agg_6y(A; chunk=5, normalize=true)
  if normalize
    base = mean(A[:, :, 1:10], dims=3) # 2000-2009
    A = A .- base
  end

  R = agg_chunk(A; chunk)[:, :, 1:4]
  r1 = mean(A[:, :, 21:23], dims=3)  # 2020-2022
  r2 = mean(A[:, :, 24:end], dims=3) # 2023-204
  cat(R, r1, r2, dims=3)
end


# 一年的数据进行加权
function _weighted_mean(x::AbstractVector{T}, days::AbstractVector) where {T<:Real}
  ∑ = T(0)
  @inbounds for i in eachindex(x)
    ∑ += x[i] * days[i]
  end
  ∑ / sum(days)
end


function _agg_time(A::AbstractArray{T,3}, by::Vector, days::Vector;
  parallel=true, progress=false, fun=mean, kw...) where {T<:Real}

  nlon, nlat, ntime = size(A)
  grps = unique_sort(by)
  _ntime = length(grps)
  R = zeros(T, nlon, nlat, _ntime)

  p = Progress(ntime)
  @inbounds @par parallel for k = 1:_ntime
    progress && next!(p)
    I = (grps[k] .== by) |> findall # 必须要有findall
    _days = days[I]

    for j = 1:nlat, i = 1:nlon
      R[i, j, k] = fun(@view(A[i, j, I]), _days; kw...)
    end
  end
  return R
end
