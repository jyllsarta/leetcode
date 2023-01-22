#
# @lc app=leetcode id=34 lang=elixir
#
# [34] Find First and Last Position of Element in Sorted Array
#

# @lc code=start
defmodule Solution do
  @spec search_range(nums :: [integer], target :: integer) :: [integer]
  def search_range(nums, target) do
    nums_map = for {x, index} <- Enum.with_index(nums), into: %{}, do: {index, x}
    min = do_binary_search(nums_map, target, 0, Enum.count(nums) - 1, true)
    max = do_binary_search(nums_map, target, 0, Enum.count(nums) - 1, false)
    [min, max]
  end

  # はじっこも考慮必須
  def do_binary_search(_, _, lp, rp, _) when lp > rp, do: -1

  def do_binary_search(nums_map, target, _lp, rp, _) when rp <= 0 do
    num = Map.fetch!(nums_map, 0)

    if target == num do
      0
    else
      -1
    end
  end

  # 頭を探す場合
  def do_binary_search(nums_map, target, lp, rp, true) do
    center = div(lp + rp, 2)
    num = Map.fetch!(nums_map, center)

    adjacent_index = center - 1
    adjacent_num = Map.get(nums_map, adjacent_index, :not_found)

    cond do
      num == target && (adjacent_num == :not_found || adjacent_num < target) -> center
      num == target -> do_binary_search(nums_map, target, lp, center - 1, true)
      num < target -> do_binary_search(nums_map, target, center + 1, rp, true)
      num > target -> do_binary_search(nums_map, target, lp, center - 1, true)
    end
  end

  # しっぽを探す場合
  def do_binary_search(nums_map, target, lp, rp, false) do
    center = div(lp + rp, 2)
    num = Map.fetch!(nums_map, center)

    adjacent_index = center + 1
    adjacent_num = Map.get(nums_map, adjacent_index, :not_found)

    cond do
      num == target && (adjacent_num == :not_found || target < adjacent_num) -> center
      num == target -> do_binary_search(nums_map, target, center + 1, rp, false)
      num < target -> do_binary_search(nums_map, target, center + 1, rp, false)
      num > target -> do_binary_search(nums_map, target, lp, center - 1, false)
    end
  end
end

defmodule Test do
  def test do
    nums = [1, 1, 1, 2, 3, 5, 5, 5, 5, 5, 5, 5, 6, 7, 8, 8, 9]
    Solution.search_range(nums, -1) |> IO.inspect()
    Solution.search_range(nums, 1) |> IO.inspect()
    Solution.search_range(nums, 2) |> IO.inspect()
    Solution.search_range(nums, 4) |> IO.inspect()
    Solution.search_range(nums, 5) |> IO.inspect()
    Solution.search_range(nums, 6) |> IO.inspect()
    Solution.search_range(nums, 9) |> IO.inspect()
    Solution.search_range(nums, 8) |> IO.inspect()
    Solution.search_range(nums, 10) |> IO.inspect()

    nums = [1, 2, 3, 5, 5, 5, 5, 5, 5, 5, 6, 7, 8, 9]
    Solution.search_range(nums, -1) |> IO.inspect()
    Solution.search_range(nums, 1) |> IO.inspect()
  end
end

# @lc code=end
