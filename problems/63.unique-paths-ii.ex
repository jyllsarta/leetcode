#
# @lc app=leetcode id=63 lang=elixir
#
# [63] Unique Paths II
#

# @lc code=start
defmodule Solution do
  @moduledoc """
  S.X.
  ....
  .X..
  ...G

  のとき こんな可視化で解けそう
  一番上行の左から順に精査していき、スタート地点に1を書く
  そのまま左に辿れるだけ1を書き込み続ける 石があったらそれ以降通れないのでゼロ

  11X0
  ....
  .X..
  ...G

  11X0
  1222
  .X..
  ...G

  次の行に移る はじっこは上から降りてくる1通りの到達方法があるので1を書く
  2つめのマスは上から1通り、左から1通りで到達できるので2を書き込む
  3つめのマスは上が石なので上からはゼロ 左から2通り来てるので2
  4つめも同様に上がゼロ 左が2なので2

  11X0
  1222
  1X24
  ...G

  同ロジックで左から埋めていく
  1つめは上からで1
  2つめは石なので無条件0
  3つめは左が0, 上が2なので2
  4つめは2+2で4

  S1X0
  1222
  1X24
  113G=7

  1つめは上からで1
  2つめは左が1, 上が0で1
  3つめは左が1, 上が2なので3
  4つめは左が3, 上が4なので7

  答えは7通り

  前問の7*3の方は
  .  .  .  .  .  .  .
  .  .  .  .  .  .  .
  .  .  .  .  .  .  .
  が
  1  1  1  1  1  1  1
  1  2  3  4  5  6  7
  1  3  6 10 15 21 28
  と可視化される
  同じ答えになるし、この図を部分的に切り取って2*3や3*3も前問と同じ回答になるのもみてわかる
  正しいアプローチっぽい
  """
  @spec unique_paths_with_obstacles(obstacle_grid :: [[integer]]) :: integer
  def unique_paths_with_obstacles(obstacle_grid) do
    n = obstacle_grid |> List.first() |> Enum.count()
    # 最初のメモ用に [1, 0, 0, 0, ...] の n要素リストを作る
    current = 1..(n - 1) |> Enum.map(fn _ -> 0 end)
    current = [1 | current]
    process(current, obstacle_grid)
  end

  def process(current, []), do: List.last(current)

  def process(current, [line | rest]) do
    next = reduce(0, Enum.zip(current, line))
    # これ出すとmoduledocの可視化結果と同じのが出てくる
    # IO.inspect(next)
    process(next, rest)
  end

  def reduce(_acc, []) do
    []
  end

  def reduce(acc, [{memo, cell} | rest]) do
    cell_value = calc_cell(acc, memo, cell)
    [cell_value | reduce(cell_value, rest)]
  end

  def calc_cell(_acc, _memo, 1) do
    0
  end

  def calc_cell(acc, memo, _cell) do
    acc + memo
  end
end

defmodule Test do
  def test do
    grid = [
      [0, 0, 0],
      [0, 0, 0],
      [0, 0, 0]
    ]

    Solution.unique_paths_with_obstacles(grid) |> IO.inspect()

    grid = [
      [0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0]
    ]

    Solution.unique_paths_with_obstacles(grid) |> IO.inspect()

    grid = [
      [0, 0, 1, 0],
      [0, 0, 0, 0],
      [0, 1, 0, 0],
      [0, 0, 0, 0]
    ]

    Solution.unique_paths_with_obstacles(grid) |> IO.inspect()

    grid = [
      [0]
    ]

    Solution.unique_paths_with_obstacles(grid) |> IO.inspect()

    grid = [
      [1]
    ]

    Solution.unique_paths_with_obstacles(grid) |> IO.inspect()

    grid = [
      [0],
      [0],
      [0],
      [0],
      [0]
    ]

    Solution.unique_paths_with_obstacles(grid) |> IO.inspect()

    grid = [
      [0, 0, 0, 0, 0]
    ]

    Solution.unique_paths_with_obstacles(grid) |> IO.inspect()

    # choke があるパターン
    grid = [
      [0, 0, 1, 0],
      [0, 1, 0, 0],
      [0, 1, 0, 0],
      [0, 0, 1, 0]
    ]

    Solution.unique_paths_with_obstacles(grid) |> IO.inspect()

    # choke があるパターン2
    grid = [
      [0, 1, 1, 1],
      [1, 1, 1, 1],
      [1, 1, 1, 1],
      [1, 1, 1, 0]
    ]

    Solution.unique_paths_with_obstacles(grid) |> IO.inspect()

    # 最大サイズ
    grid = 1..100 |> Enum.map(fn _ -> 0 end) |> List.duplicate(100)
    Solution.unique_paths_with_obstacles(grid) |> IO.inspect()

    # 最大サイズ2
    grid = 1..100 |> Enum.map(fn _ -> 1 end) |> List.duplicate(100)
    Solution.unique_paths_with_obstacles(grid) |> IO.inspect()
  end
end

# @lc code=end
