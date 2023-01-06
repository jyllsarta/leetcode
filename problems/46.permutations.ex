#
# @lc app=leetcode id=46 lang=elixir
#
# [46] Permutations
#

# @lc code=start
defmodule Solution do
  @spec permute(nums :: [integer]) :: [[integer]]
  def permute(nums) do
    list(nums)
  end

  def list([num]) do
    [[num]]
  end

  def list(nums) do
    for num <- nums do
      rest = Enum.filter(nums, &(&1 != num))
      Enum.map(list(rest), &[num | &1])
    end
    |> Enum.concat()
  end
end

defmodule Test do
  def test do
    Solution.permute([1]) |> IO.inspect()
    Solution.permute([1, 2]) |> IO.inspect()
    Solution.permute([1, 2, 3]) |> IO.inspect()
    Solution.permute([1, 2, 3, 4]) |> IO.inspect()
  end

  def clock do
    :timer.tc(Solution, :permute, [[1, 2, 3, 4, 5, 6]]) |> IO.inspect()
  end
end

# @lc code=end
