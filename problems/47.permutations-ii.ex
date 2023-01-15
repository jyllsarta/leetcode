#
# @lc app=leetcode id=47 lang=elixir
#
# [47] Permutations II
#

# @lc code=start
defmodule Solution do
  @spec permute_unique(nums :: [integer]) :: [[integer]]
  def permute_unique(nums) do
    list(nums) |> Enum.uniq()
  end

  def list([num]) do
    [[num]]
  end

  def list(nums) do
    for num <- nums do
      rest = List.delete(nums, num)
      Enum.map(list(rest), &[num | &1])
    end
    |> Enum.concat()
  end
end

defmodule Test do
  def test do
    Solution.permute_unique([1, 1, 2]) |> IO.inspect()
    Solution.permute_unique([1, 2, 3]) |> IO.inspect()
  end

  def test2 do
    Solution.permute_unique([1]) |> IO.inspect()
    Solution.permute_unique([1, 2]) |> IO.inspect()
    Solution.permute_unique([1, 2, 3]) |> IO.inspect()
    Solution.permute_unique([1, 2, 3, 4]) |> IO.inspect()
  end

  def clock do
    :timer.tc(Solution, :permute_unique, [[1, 2, 3, 4, 5, 6]]) |> IO.inspect()
  end
end
# @lc code=end
