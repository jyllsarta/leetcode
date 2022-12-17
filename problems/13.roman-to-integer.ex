#
# @lc app=leetcode id=13 lang=elixir
#
# [13] Roman to Integer
#

# @lc code=start
defmodule Solution do
  @romans %{
    ?I => 1,
    ?V => 5,
    ?X => 10,
    ?L => 50,
    ?C => 100,
    ?D => 500,
    ?M => 1000
  }

  @spec roman_to_int(s :: String.t()) :: integer
  def roman_to_int(s) do
    charlist = String.to_charlist(s)
    check(charlist, 0)
  end

  def check([], sum) do
    sum
  end

  def check([char], sum) do
    Map.fetch!(@romans, char) + sum
  end

  def check([?I , char | remains], sum) when char in [?V, ?X] do
    acc = Map.fetch!(@romans, char) - Map.fetch!(@romans, ?I) + sum
    check(remains, acc)
  end

  def check([?X , char | remains], sum) when char in [?L, ?C] do
    acc = Map.fetch!(@romans, char) - Map.fetch!(@romans, ?X) + sum
    check(remains, acc)
  end

  def check([?C , char | remains], sum) when char in [?D, ?M] do
    acc = Map.fetch!(@romans, char) - Map.fetch!(@romans, ?C) + sum
    check(remains, acc)
  end

  def check([char | remains], sum) do
    acc = Map.fetch!(@romans, char) + sum
    check(remains, acc)
  end
end

defmodule Test do
  def test do
    "MCMXCIV" |> Solution.roman_to_int() |> IO.inspect()
  end
end

# @lc code=end
