#
# @lc app=leetcode id=74 lang=elixir
#
# [74] Search a 2D Matrix
#

# @lc code=start
defmodule Solution do
  @spec search_matrix(matrix :: [[integer]], target :: integer) :: boolean
  def search_matrix(matrix, target) do
    # まあlogn * logn にできるんだけど、条件的に要求きつくなさそうなので行側のインデックス探索はo(n)でやっちゃう
    first_values = matrix |> Enum.map(&Enum.at(&1, 0))
    index = Enum.find_index(first_values, &(&1 > target))

    cond do
      index == 0 -> false
      is_nil(index) -> binary_search(Enum.at(matrix, Enum.count(matrix) - 1), target)
      true -> binary_search(Enum.at(matrix, index - 1), target)
    end
  end

  def binary_search(nums, target) do
    # ランダムアクセスするのでnumsをmapにならす
    nums_map = for {x, index} <- Enum.with_index(nums), into: %{}, do: {index, x}
    do_binary_search(nums_map, target, 0, Enum.count(nums) - 1)
  end

  def do_binary_search(_, _, lp, rp) when lp > rp, do: false

  def do_binary_search(nums_map, target, lp, rp) do
    center = div(lp + rp, 2)
    num = Map.fetch!(nums_map, center)

    cond do
      num == target -> true
      num < target -> do_binary_search(nums_map, target, center + 1, rp)
      num > target -> do_binary_search(nums_map, target, lp, center - 1)
    end
  end
end

defmodule Test do
  def test do
    matrix = [
      [-10, 0, 100, 200],
      [201, 202, 203, 204],
      [500, 505, 555, 598],
      [600, 900, 901, 999]
    ]

    IO.puts("truthy")
    Solution.search_matrix(matrix, -10) |> IO.inspect()
    Solution.search_matrix(matrix, 0) |> IO.inspect()
    Solution.search_matrix(matrix, 100) |> IO.inspect()
    Solution.search_matrix(matrix, 200) |> IO.inspect()
    Solution.search_matrix(matrix, 201) |> IO.inspect()
    Solution.search_matrix(matrix, 202) |> IO.inspect()
    Solution.search_matrix(matrix, 203) |> IO.inspect()
    Solution.search_matrix(matrix, 204) |> IO.inspect()
    Solution.search_matrix(matrix, 500) |> IO.inspect()
    Solution.search_matrix(matrix, 598) |> IO.inspect()
    Solution.search_matrix(matrix, 600) |> IO.inspect()
    Solution.search_matrix(matrix, 901) |> IO.inspect()
    Solution.search_matrix(matrix, 999) |> IO.inspect()
    IO.puts("falsey")
    Solution.search_matrix(matrix, -11) |> IO.inspect()
    Solution.search_matrix(matrix, -110) |> IO.inspect()
    Solution.search_matrix(matrix, -2) |> IO.inspect()
    Solution.search_matrix(matrix, 101) |> IO.inspect()
    Solution.search_matrix(matrix, 205) |> IO.inspect()
    Solution.search_matrix(matrix, 499) |> IO.inspect()
    Solution.search_matrix(matrix, 501) |> IO.inspect()
    Solution.search_matrix(matrix, 550) |> IO.inspect()
    Solution.search_matrix(matrix, 599) |> IO.inspect()
    Solution.search_matrix(matrix, 601) |> IO.inspect()
    Solution.search_matrix(matrix, 998) |> IO.inspect()
    Solution.search_matrix(matrix, 1000) |> IO.inspect()
  end

  def test_bin_search do
    IO.puts("truthy")
    Solution.binary_search([0, 1, 2, 4, 8, 16, 32, 64, 128], 0) |> IO.inspect()
    Solution.binary_search([0, 1, 2, 4, 8, 16, 32, 64, 128], 1) |> IO.inspect()
    Solution.binary_search([0, 1, 2, 4, 8, 16, 32, 64, 128], 8) |> IO.inspect()
    Solution.binary_search([0, 1, 2, 4, 8, 16, 32, 64, 128], 16) |> IO.inspect()
    Solution.binary_search([0, 1, 2, 4, 8, 16, 32, 64, 128], 128) |> IO.inspect()
    IO.puts("falsey")
    Solution.binary_search([0, 1, 2, 4, 8, 16, 32, 64, 128], -1) |> IO.inspect()
    Solution.binary_search([0, 1, 2, 4, 8, 16, 32, 64, 128], 129) |> IO.inspect()
    Solution.binary_search([0, 1, 2, 4, 8, 16, 32, 64, 128], 5000) |> IO.inspect()
  end
end

# @lc code=end
