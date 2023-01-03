#
# @lc app=leetcode id=944 lang=elixir
#
# [944] Delete Columns to Make Sorted
#

# @lc code=start
defmodule Solution do
  @spec min_deletion_size(strs :: [String.t()]) :: integer
  def min_deletion_size(strs) do
    str_maps =
      for str <- strs, into: [] do
        charlist = String.to_charlist(str)
        for {char, index} <- Enum.with_index(charlist), into: %{}, do: {index, char}
      end

    count = (Enum.at(strs, 0) |> String.length()) - 1

    is_sorted =
      for i <- 0..count, into: [] do
        chars = Enum.map(str_maps, &Map.fetch!(&1, i))
        chars == Enum.sort(chars)
      end

    Enum.count(is_sorted, &(&1 == false))
  end
end

defmodule Test do
  def test do
    strs = ["cba", "daf", "ghi"]
    Solution.min_deletion_size(strs) |> IO.inspect()
    strs = ["a", "b"]
    Solution.min_deletion_size(strs) |> IO.inspect()
    strs = ["zyx", "wvu", "tsr"]
    Solution.min_deletion_size(strs) |> IO.inspect()
  end

  def clock do
    str = List.duplicate("a", 10000) |> Enum.join()
    strs = [str]
    :timer.tc(Solution, :min_deletion_size, [strs])
  end
end

# @lc code=end
