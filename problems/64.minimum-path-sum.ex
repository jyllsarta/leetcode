#
# @lc app=leetcode id=64 lang=elixir
#
# [64] Minimum Path Sum
#

# @lc code=start
defmodule Solution do
  @moduledoc """
  63の計算方法違うバージョンでいけそう
  次のセル = min(左から来た合計コスト, 上から来た合計コスト) + 今のセルの値
  でしょ

  画面外について適切に境界値処理をするのが面倒なので、上端と左端はめちゃくちゃ大きい数字にしてしまう
  問題ではセルの値は100以下なので問題なし
  """

  @infinite_cost 999_999_999

  @spec min_path_sum(grid :: [[integer]]) :: integer
  def min_path_sum(grid) do
    n = grid |> List.first() |> Enum.count()
    # 最初のメモ用に [0, inf, inf, inf, inf, ...] の n要素リストを作る
    current = 1..(n - 1) |> Enum.map(fn _ -> @infinite_cost end)
    current = [0 | current]
    process(current, grid)
  end

  def process(current, []), do: List.last(current)

  def process(current, [line | rest]) do
    next = reduce(@infinite_cost, Enum.zip(current, line))
    # これ出すとmoduledocの可視化結果と同じのが出てくる
    # IO.inspect(next)
    process(next, rest)
  end

  def reduce(_acc, []) do
    []
  end

  def reduce(acc, [{memo, cell} | rest] = list) do
    cell_value = calc_cell(acc, memo, cell)
    [cell_value | reduce(cell_value, rest)]
  end

  def calc_cell(acc, memo, cell) do
    min(acc, memo) + cell
  end
end

defmodule Test do
  def test do
    grid = [
      [1, 3, 1],
      [1, 5, 1],
      [4, 2, 1]
    ]

    Solution.min_path_sum(grid)
  end
end

# @lc code=end
