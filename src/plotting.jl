# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    excessplot(xs)

Mean excess plot for the data `xs`.
"""
function excessplot end

"""
    excessplot!(ax, xs)

Mutating version of [`excessplot`](@ref) that adds to an existing axis `ax`.
"""
function excessplot! end

"""
    paretoplot(xs)

Pareto quantile plot for the data `xs`.
"""
function paretoplot end

"""
    paretoplot!(ax, xs)

Mutating version of [`paretoplot`](@ref) that adds to an existing axis `ax`.
"""
function paretoplot! end

"""
    returnplot(xs)
Return level plot for the data `xs`.
"""
function returnplot end

"""
    returnplot!(ax, xs)
Mutating version of [`returnplot`](@ref) that adds to an existing axis `ax`.
"""
function returnplot! end
