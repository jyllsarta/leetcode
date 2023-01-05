#
# @lc app=leetcode id=35 lang=elixir
#
# [35] Search Insert Position
#

# @lc code=start
defmodule Solution do
  @spec search_insert(nums :: [integer], target :: integer) :: integer
  def search_insert(nums, target) do
    binary_search(nums, target)
  end

  def binary_search(nums, target) do
    # ランダムアクセスするのでnumsをmapにならす...のがO(n)なのでレギュ違反かもしれないが
    # https://elixirschool.com/ja/lessons/basics/collections
    # > Elixirはリストコレクションを連結リストとして実装しています。
    # なので詰みでは？末尾の要素が何なのか知るコストがそもそもO(n)なので、どうやってもlognにはならないような...
    nums_map = for {x, index} <- Enum.with_index(nums), into: %{}, do: {index, x}
    do_binary_search(nums_map, target, 0, Enum.count(nums) - 1)
  end

  def do_binary_search(_, _, lp, rp) when lp > rp, do: lp

  def do_binary_search(nums_map, target, lp, rp) when rp <= 0 do
    num = Map.fetch!(nums_map, 0)

    if target <= num do
      0
    else
      1
    end
  end

  def do_binary_search(nums_map, target, lp, rp) do
    center = div(lp + rp, 2)
    num = Map.fetch!(nums_map, center)

    cond do
      num == target -> center
      num < target -> do_binary_search(nums_map, target, center + 1, rp)
      num > target -> do_binary_search(nums_map, target, lp, center - 1)
    end
  end
end

defmodule Test do
  def test do
    array = [1, 2, 4, 7, 11]
    (Solution.search_insert(array, 0) == 0) |> IO.inspect()
    (Solution.search_insert(array, 1) == 0) |> IO.inspect()
    (Solution.search_insert(array, 2) == 1) |> IO.inspect()
    (Solution.search_insert(array, 3) == 2) |> IO.inspect()
    (Solution.search_insert(array, 4) == 2) |> IO.inspect()
    (Solution.search_insert(array, 5) == 3) |> IO.inspect()
    (Solution.search_insert(array, 6) == 3) |> IO.inspect()
    (Solution.search_insert(array, 7) == 3) |> IO.inspect()
    (Solution.search_insert(array, 8) == 4) |> IO.inspect()
    (Solution.search_insert(array, 9) == 4) |> IO.inspect()
    (Solution.search_insert(array, 10) == 4) |> IO.inspect()
    (Solution.search_insert(array, 11) == 4) |> IO.inspect()
    (Solution.search_insert(array, 12) == 5) |> IO.inspect()

    nums = [1, 3, 5, 6]
    Solution.search_insert(nums, 5) |> IO.inspect()
    nums = [1, 3, 5, 6]
    Solution.search_insert(nums, 2) |> IO.inspect()
    nums = [1, 3, 5, 6]
    Solution.search_insert(nums, 7) |> IO.inspect()
  end
end

# @lc code=end
