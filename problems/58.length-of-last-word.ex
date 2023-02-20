#
# @lc app=leetcode id=58 lang=elixir
#
# [58] Length of Last Word
#

# @lc code=start
defmodule Solution do
  @spec length_of_last_word(s :: String.t()) :: integer
  def length_of_last_word(s) do
    s |> String.split(" ") |> Enum.filter(&(&1 != "")) |> List.last() |> String.length()
  end
end

defmodule Test do
  def test do
    Solution.length_of_last_word("Hello World") |> IO.inspect()
    Solution.length_of_last_word("   fly me   to   the moon  ") |> IO.inspect()
    Solution.length_of_last_word("luffy is still joyboy") |> IO.inspect()
  end
end

# @lc code=end
