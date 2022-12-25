#
# @lc app=leetcode id=20 lang=elixir
#
# [20] Valid Parentheses
#

# @lc code=start
defmodule Solution do
  @start_chars [?(, ?{, ?[]

  @spec is_valid(s :: String.t()) :: boolean
  def is_valid(s) do
    charlist = String.to_charlist(s)
    check(charlist, [])
  end

  def check([], []) do
    true
  end

  def check([], _stack) do
    false
  end

  def check([char | rest], stack) when char in @start_chars do
    check(rest, [char | stack])
  end

  def check([?] | rest], [?[ | stack]) do
    check(rest, stack)
  end

  def check([?} | rest], [?{ | stack]) do
    check(rest, stack)
  end

  def check([?) | rest], [?( | stack]) do
    check(rest, stack)
  end

  def check(_, _) do
    false
  end
end

defmodule Test do
  def test do
    Solution.is_valid("((())){}(){}[]{{([])}}") |> IO.inspect()
    Solution.is_valid("((()){}(){}[]{{([])}}") |> IO.inspect()
    Solution.is_valid("") |> IO.inspect()
    Solution.is_valid(")") |> IO.inspect()
  end
end
# @lc code=end
