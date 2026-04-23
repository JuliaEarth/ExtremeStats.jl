# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    excessplot(xs)

Mean excess plot for the data `xs`.
"""
function excessplot end

"""
    excessplot!(plt, xs)

Mutating version of [`excessplot`](@ref) that adds to an existing plot `plt`.
"""
function excessplot! end

"""
    paretoplot(xs)

Pareto quantile plot for the data `xs`.
"""
function paretoplot end

"""
    paretoplot!(plt, xs)

Mutating version of [`paretoplot`](@ref) that adds to an existing plot `plt`.
"""
function paretoplot! end

"""
    returnplot(xs)
Return level plot for the data `xs`.
"""
function returnplot end

"""
    returnplot!(plt, xs)
Mutating version of [`returnplot`](@ref) that adds to an existing plot `plt`.
"""
function returnplot! end
