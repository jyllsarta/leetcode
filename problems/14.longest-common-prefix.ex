#
# @lc app=leetcode id=14 lang=elixir
#
# [14] Longest Common Prefix
#

# @lc code=start
defmodule Solution do
  @spec longest_common_prefix(strs :: [String.t]) :: String.t
  def longest_common_prefix(strs) do
    charlists = Enum.map(strs, & String.to_charlist/1)
    has_empty_string? = Enum.map(strs, &String.length/1) |> Enum.any?(& &1 == 0)
    if has_empty_string? do
      ""
    else
      check(charlists, []) |> Enum.reverse |> List.to_string
    end
  end

  def check(charlists, prefix) do
    elems = for [char | rest] <- charlists, into: [], do: {char, rest} 
    {first_elements, rest_charlists} = Enum.unzip(elems)
    first_element = Enum.at(first_elements, 0)

    cond do
      Enum.any?(first_elements, & &1 != first_element) -> prefix
      Enum.any?(rest_charlists, & &1 == []) -> [first_element | prefix]
      true -> check(rest_charlists, [first_element | prefix])
    end
  end 
end

defmodule Test do
  def test do
    strs = List.duplicate('1', 200) |> List.to_string |> List.duplicate(200)
    Solution.longest_common_prefix(strs) |> IO.inspect
    strs = ["flower","flow","flight"]
    Solution.longest_common_prefix(strs) |> IO.inspect
    strs = ["dog","racecar","car"]
    Solution.longest_common_prefix(strs) |> IO.inspect
    strs = ["123","1234","12345"]
    Solution.longest_common_prefix(strs) |> IO.inspect
    strs = [""]
    Solution.longest_common_prefix(strs) |> IO.inspect
  end
end
# @lc code=end
