#
# @lc app=leetcode id=56 lang=elixir
#
# [56] Merge Intervals
#

# @lc code=start
defmodule Solution do
  @moduledoc """
    [[1,4], [0,4]] とかいうテストケースあって泣いた
    昇順ソートはぜんぜん本質じゃないのにやらなきゃいけないのか...
    ソート無ければ O(n) なのにソートのせいで O(nlogn) になるの結構もったいなくない？
  """
  @spec merge(intervals :: [[integer]]) :: [[integer]]
  def merge([]), do: []
  def merge([item]), do: [item]

  def merge(intervals) do
    [head | rest] = Enum.sort(intervals, & List.first(&1) <= List.first(&2))
    do_merge(head, rest, [])
  end

  def do_merge(current, [], completed) do
    [current | completed] |> Enum.reverse()
  end

  def do_merge([current_head, current_tail], [[head, tail] | rest], completed) when head <= current_tail do
    new_tail = max(current_tail, tail)
    do_merge([current_head, new_tail], rest, completed)
  end

  def do_merge(current, [head | rest], completed) do
    do_merge(head, rest, [current | completed])
  end
end

defmodule Test do
  def test do
    list = [
      [1,3],
      [2,6],
      [7,9],
      [11,15],
      [12,13]
    ]
    Solution.merge(list) |> IO.inspect()

    list = [
      [1,4],
      [0,4]
    ]
    Solution.merge(list) |> IO.inspect()
  end
end
# @lc code=end
