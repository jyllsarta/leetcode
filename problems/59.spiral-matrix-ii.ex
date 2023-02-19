#
# @lc app=leetcode id=59 lang=elixir
#
# [59] Spiral Matrix II
#

# @lc code=start
defmodule Solution do
  @moduledoc """
  素朴に問題を考えたらややこしいアルゴリズムしか思いつかなかったけど、 spiral-matrix 1の答えを再利用できますねこれ
  spiral_order(matrix) した順番に数字を読み上げればいい

  n = 3 のとき

  1 2 3
  4 5 6
  7 8 9

  を spiral_order(matrix) すると

  1 2 3 6 9 8 7 4 5 が得られる

  この数列を口に出して読み上げた場合

  1は 1 回目に読み上げられる
  2は 2 回目に読み上げられる
  3は 3 回目に読み上げられる
  6は 4 回目に読み上げられる
  9は 5 回目に読み上げられる
  8は 6 回目に読み上げられる
  7は 7 回目に読み上げられる
  4は 8 回目に読み上げられる
  5は 9 回目に読み上げられる

  ということ。ソートして

  1は 1 回目に読み上げられる
  2は 2 回目に読み上げられる
  3は 3 回目に読み上げられる
  4は 8 回目に読み上げられる
  5は 9 回目に読み上げられる
  6は 4 回目に読み上げられる
  7は 7 回目に読み上げられる
  8は 6 回目に読み上げられる
  9は 5 回目に読み上げられる

  123894765 は 見やすく表示すると

  1 2 3
  8 9 4
  7 6 5

  4のあった場所は8回目に書き込まれ...最後に真ん中にn^2を書いて終了
  書き込む順番 = 書き込むべき値なのでそれをそのまま出力すればOK
  """
  @spec generate_matrix(n :: integer) :: [[integer]]
  def generate_matrix(n) do
    1..(n * n)
    |> Enum.chunk_every(n)
    |> SpiralMatrix.spiral_order()
    |> Enum.with_index(1)
    |> Enum.sort(&(elem(&1, 0) < elem(&2, 0)))
    |> Enum.map(&elem(&1, 1))
    |> Enum.chunk_every(n)
  end
end

defmodule SpiralMatrix do
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
    Solution.generate_matrix(1) |> IO.inspect()
    Solution.generate_matrix(2) |> IO.inspect()
    Solution.generate_matrix(3) |> IO.inspect()
    Solution.generate_matrix(10) |> IO.inspect()
    Solution.generate_matrix(20) |> IO.inspect()
  end
end

# @lc code=end
