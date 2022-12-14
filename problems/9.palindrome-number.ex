#
# @lc app=leetcode id=9 lang=elixir
#
# [9] Palindrome Number
#

# @lc code=start
defmodule Solution do
  @spec is_palindrome(x :: integer) :: boolean
  def is_palindrome(x) when x < 0 do
    false
  end

  def is_palindrome(x) do
    x |> Integer.to_string() |> check
  end

  def check(str) do
    cond do
      String.length(str) <= 1 ->
        true

      String.at(str, 0) == String.at(str, -1) ->
        str |> String.slice(1, String.length(str) - 2) |> check

      true ->
        false
    end
  end
end

# @lc code=end
