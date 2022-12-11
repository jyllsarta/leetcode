#
# @lc app=leetcode id=3 lang=elixir
#
# [3] Longest Substring Without Repeating Characters
#

# @lc code=start
defmodule Solution do
  @spec length_of_longest_substring(s :: String.t) :: integer
  def length_of_longest_substring(s) do
    s |> String.to_charlist() |> search
  end

  defp search(charlist) do
    do_search(charlist, [], 0)
  end

  defp do_search(charlist, current_chars, max_score)

  defp do_search([], _current_chars, max_score) do
    max_score
  end

  defp do_search([char | rest] = charlist, current_chars, max_score) do
    #IO.inspect("#{char} #{current_chars} #{charlist} #{max_score}")
    # かぶりが発生したら先頭一文字だけ削ってまた頭から数え直す
    # Ex: anviaj -> [a] [nviaj] ... [anvi] [aj] までいってaに当たってリセット
    # 先頭のa を削って [] [nviaj] にして再開
    if char in current_chars do
      [_ | next] = current_chars
      do_search(next ++ charlist, [], max_score)
    else
      do_search(rest, current_chars ++ [char], max(Enum.count(current_chars) + 1, max_score))
    end
  end
end
# @lc code=end
