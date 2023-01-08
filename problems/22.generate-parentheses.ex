#
# @lc app=leetcode id=22 lang=elixir
#
# [22] Generate Parentheses
#

# @lc code=start
defmodule Solution do
  @moduledoc """
  n=3を考えてみると、開いてスタートして、開いた数 >= 閉じた数 を維持するようにパターンを列挙してflat_mapすればいい？
  ( + (2 )3

  () + (2 )2
  (( + (1 )3

  ()( + (1 )2
  ()) is invalid = []
  ((( + (0 )3 is just [((()))]
  (() + (1 )2

  ()(( + (0 )2 is just [()(())]
  ()() + (1 )1
  (()( + (0 )2 is just [(()())]
  (()) + (1 )1

  ()()( + (0 )1 is just [()()()]
  ()()) + (1 )0 is invalid = []
  (())( + (0 )1 is just [(())()]
  (())) + (1 )0 is invalid = []

  open == 0, close > 0 is あとは閉じるだけ
  open > 0, close == 0 is invalid
  open == 0, close == 0 になることはない(openとcloseはいずれか1ずつ減る)
  open > 0, close > 0 is ( + loop(open-1, close) ++ ) + loop(open, close-1)
  """
  @spec generate_parenthesis(n :: integer) :: [String.t()]
  def generate_parenthesis(n) do
    listup('(', n - 1, n)
  end

  # 先に閉じすぎて手詰まりになったパターン
  def listup(current, open, close) when open > close do
    []
  end

  # あとは閉じるだけ
  def listup(current, 0, close) do
    closes = List.duplicate(')', close)
    [Enum.reverse(closes ++ current) |> List.to_string()]
  end

  # もう一つ開く or 一個閉じる
  def listup(current, open, close) do
    listup(['(' | current], open - 1, close) ++ listup([')' | current], open, close - 1)
  end
end

defmodule Test do
  def test do
    Solution.generate_parenthesis(3)
  end

  def clock do
    :timer.tc(Solution, :generate_parenthesis, [8])
  end
end

# @lc code=end
