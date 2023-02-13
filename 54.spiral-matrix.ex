#
# @lc app=leetcode id=54 lang=elixir
#
# [54] Spiral Matrix
#

# @lc code=start
defmodule Solution do
  @moduledoc """
    特に何か変なことがあるわけでもなく、上削る 右削る 下削る 左削る を繰り返すだけなような気がする
    右削るところだけ計算量的にO(n)なのがいまいちだけど、それに引っかかるほど制約が厳しくないので工夫せずに行けそう
  """
  @spec spiral_order(matrix :: [[integer]]) :: [integer]
  def spiral_order(matrix) do
    cut_top(matrix, [])
  end

  def reverse(result), do: Enum.reverse(result)

  def cut_top([], result), do: reverse(result)
  def cut_top([[]], result), do: reverse(result)

  def cut_top(matrix, result) do
    [head | rest] = matrix
    line = Enum.reverse(head)
    cut_right(rest, line ++ result)
  end

  def cut_right([], result), do: reverse(result)
  def cut_right([[]], result), do: reverse(result)

  def cut_right(matrix, result) do
    splits = Enum.map(matrix, &Enum.split(&1, -1))
    heads = Enum.map(splits, &elem(&1, 1))
    rest = Enum.map(splits, &elem(&1, 0))

    line = heads |> List.flatten() |> Enum.reverse()
    cut_buttom(rest, line ++ result)
  end

  def cut_bottom([], result), do: reverse(result)
  def cut_bottom([[]], result), do: reverse(result)

  def cut_buttom(matrix, result) do
    [head | rest] = Enum.slide(matrix, -1, 0)
    line = head
    cut_left(rest, line ++ result)
  end

  def cut_left([], result), do: reverse(result)
  def cut_left([[]], result), do: reverse(result)

  def cut_left(matrix, result) do
    splits = Enum.map(matrix, &Enum.split(&1, 1))
    heads = Enum.map(splits, &elem(&1, 0))
    rest = Enum.map(splits, &elem(&1, 1))

    line = heads |> List.flatten()
    cut_top(rest, line ++ result)
  end
end

defmodule Test do
  def test do
    matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    Solution.spiral_order(matrix) |> IO.inspect()

    matrix = [
      [1, 2, 3, 4],
      [5, 6, 7, 8],
      [9, 10, 11, 12]
    ]

    Solution.spiral_order(matrix) |> IO.inspect()
  end
end

# @lc code=end
