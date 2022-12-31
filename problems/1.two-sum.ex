#
# @lc app=leetcode id=1 lang=elixir
#
# [1] Two Sum
#

# @lc code=start
defmodule Solution do
  @spec two_sum(nums :: [integer], target :: integer) :: [integer]
  def two_sum(nums, target) do
    sorted = Enum.with_index(nums) |> Enum.sort(&(elem(&1, 0) < elem(&2, 0)))
    nums_map = for {x, index} <- Enum.with_index(sorted), into: %{}, do: {index, x}
    max = Enum.count(nums) - 1
    find(nums_map, target, 0, max)
  end

  def find(_nums_map, _target, index, max) when index >= max do
    nil
  end

  def find(nums_map, target, index, max) do
    {num, original_index} = Map.fetch!(nums_map, index)
    find_value = target - num
    result = binary_search(nums_map, find_value, index + 1, max)

    if is_nil(result) do
      find(nums_map, target, index + 1, max)
    else
      [original_index, result]
    end
  end

  def binary_search(nums_map, target, search_index_min, count) do
    do_binary_search(nums_map, target, search_index_min, count)
  end

  def do_binary_search(_, _, lp, rp) when lp > rp, do: nil

  def do_binary_search(nums_map, target, lp, rp) do
    center = div(lp + rp, 2)
    {num, original_index} = Map.fetch!(nums_map, center)

    cond do
      num == target -> original_index
      num < target -> do_binary_search(nums_map, target, center + 1, rp)
      num > target -> do_binary_search(nums_map, target, lp, center - 1)
    end
  end
end

defmodule Test do
  def test do
    Solution.two_sum([2, 3, 4, 5, 6, 7, 8], 11) |> IO.inspect()
    Solution.two_sum([2, 7, 11, 15], 9) |> IO.inspect()
    Solution.two_sum([2, 7, 11, 15, 1, -6, 6], 0) |> IO.inspect()
    Solution.two_sum([3, 3], 6) |> IO.inspect()
    Solution.two_sum([0, 3, 1, 2, 1, 2, 1, 2, 0, 3, 0], 6) |> IO.inspect()

    nums = for x <- 0..9997, into: [], do: x
    Solution.two_sum(nums ++ [299_999, 300_001], 600_000) |> IO.inspect()
  end

  def clock do
    nums = for x <- 0..9997, into: [], do: x
    :timer.tc(Solution, :two_sum, [nums ++ [299_999, 300_001], 600_000]) |> IO.inspect()
  end
end

# @lc code=end
