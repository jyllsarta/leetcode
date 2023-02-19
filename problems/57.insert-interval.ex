#
# @lc app=leetcode id=57 lang=elixir
#
# [57] Insert Interval
#

# @lc code=start
defmodule Solution do
  @moduledoc """
  やることは56と一緒なので、56と同じ解き方をしちゃおう...
  """
  @spec insert(intervals :: [[integer]], new_interval :: [integer]) :: [[integer]]
  def insert(intervals, new_interval) do
    merge([new_interval | intervals])
  end

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
    intervals = [[1,3],[6,9]]
    new = [2,5]
    Solution.insert(intervals, new) |> IO.inspect()
  end
end
# @lc code=end
