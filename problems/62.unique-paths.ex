#
# @lc app=leetcode id=62 lang=elixir
#
# [62] Unique Paths
#

# @lc code=start
defmodule Solution do
  @spec unique_paths(m :: integer, n :: integer) :: integer
  def unique_paths(m, n) do
    div(fact(m + n - 2), fact(m - 1) * fact(n - 1))
  end

  def fact(0), do: 1
  def fact(1), do: 1

  def fact(n) do
    n * fact(n - 1)
  end
end

defmodule Test do
  def test do
    Solution.unique_paths(7, 3) |> IO.inspect()
    Solution.unique_paths(3, 2) |> IO.inspect()
    Solution.unique_paths(3, 1) |> IO.inspect()
    # Elixir は 整数がデカいのでint幅になるような先攻割り算は不要
    Solution.unique_paths(100, 100) |> IO.inspect()
  end
end

# @lc code=end
