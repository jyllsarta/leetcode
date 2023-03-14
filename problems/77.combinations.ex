#
# @lc app=leetcode id=77 lang=elixir
#
# [77] Combinations
#

# @lc code=start
defmodule Solution do
  @moduledoc """
  これはなんかみたことある
  5C2を考えるとき、○2個を並べる方法を検討すればいいって感じだと思う
  1 2 3 4 5
  o x o x x

  最悪計算で440000くらいだから耐えてるんだか耐えてないんだか微妙な感じ
  通らないならメモ化しちゃえばいいだけなので、これでsubmitしてみよう
  """
  @spec combine(n :: integer, k :: integer) :: [[integer]]
  def combine(n, k) do
    combinations = list(n, k)
    nums = Enum.to_list(1..n)

    for combination <- combinations do
      for {selector, i} <- Enum.with_index(combination, 1), selector do
        i
      end
    end
  end

  def list(n, k) when n == k do
    [List.duplicate(true, n)]
  end

  def list(n, 0) do
    [List.duplicate(false, n)]
  end

  def list(n, k) do
    trues = Enum.map(list(n - 1, k - 1), &[true | &1])
    falses = Enum.map(list(n - 1, k), &[false | &1])
    trues ++ falses
  end
end

defmodule Test do
  def test do
    Solution.combine(20, 10)
  end

  def clock do
    :timer.tc(Solution, :combine, [20, 10]) |> IO.inspect()
    :timer.tc(Solution, :combine, [20, 1]) |> IO.inspect()
    :timer.tc(Solution, :combine, [20, 19]) |> IO.inspect()
    :timer.tc(Solution, :combine, [20, 15]) |> IO.inspect()
  end
end

# @lc code=end
