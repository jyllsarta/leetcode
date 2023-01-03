#
# @lc app=leetcode id=944 lang=elixir
#
# [944] Delete Columns to Make Sorted
#

# @lc code=start
defmodule Solution do
  @spec min_deletion_size(strs :: [String.t()]) :: integer
  def min_deletion_size(strs) do
    count = (strs |> Enum.map(&String.length/1) |> Enum.min()) - 1

    is_sorted_list =
      for i <- 0..count, into: [] do
        list = strs |> Enum.map(&String.at(&1, i))

        # 問題の制限がゆるいので sorted? みたいなのを自作しなくても大丈夫そう
        # strs[i] consists of lowercase English letters. なので、何も考えずソートするだけでいいはず
        list == Enum.sort(list)
      end

    Enum.count(is_sorted_list, &(&1 == false))
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
end

# @lc code=end
