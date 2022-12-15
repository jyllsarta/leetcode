#
# @lc app=leetcode id=1143 lang=elixir
#
# [1143] Longest Common Subsequence
#

# @lc code=start
defmodule Solution do
  @spec longest_common_subsequence(text1 :: String.t(), text2 :: String.t()) :: integer
  def longest_common_subsequence(text1, text2) do
    {:ok, memo} = Memo.start_link()
    check(text1, text2, String.length(text1), String.length(text2), memo)
  end

  def check(_, _, _, 0, _), do: 0
  def check(_, _, 0, _, _), do: 0

  def check(t1, t2, p1, p2, memo) do
    cond do
      Memo.get(memo, {p1, p2}) ->
        Memo.get(memo, {p1, p2})

      String.at(t1, p1 - 1) == String.at(t2, p2 - 1) ->
        answer = 1 + check(t1, t2, p1 - 1, p2 - 1, memo)
        Memo.put(memo, {p1, p2}, answer)
        answer

      true ->
        left = check(t1, t2, p1 - 1, p2, memo)
        right = check(t1, t2, p1, p2 - 1, memo)
        max = max(left, right)
        Memo.put(memo, {p1, p2}, max)
        max
    end
  end
end

defmodule Memo do
  use Agent

  def start_link do
    Agent.start_link(fn -> %{} end)
  end

  def get(memo, key) do
    Agent.get(memo, &Map.get(&1, key))
  end

  def put(memo, key, value) do
    Agent.update(memo, &Map.put(&1, key, value))
  end
end

defmodule Test do
  def test do
    IO.inspect(Solution.longest_common_subsequence("abc", "def"))
    IO.inspect(Solution.longest_common_subsequence("nematode knowledge", "empty bottle"))
  end
end

# @lc code=end
