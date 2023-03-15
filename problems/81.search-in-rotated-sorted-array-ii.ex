#
# @lc app=leetcode id=81 lang=elixir
#
# [81] Search in Rotated Sorted Array II
#

# @lc code=start
defmodule Solution do
  @moduledoc """
  これ題意を組むなら段差を二分探索か何かで探していってlogn+αの計算量で戦うんでしょうが、
  Elixirのリストは最後の要素へのアクセスがO(n)なのでしっぽを知る時点ですでにO(n)なんですよね
  なので、結局前から順に見ていくのが最速になるはず
  > You must decrease the overall operation steps as much as possible.
  これに対する正しいアプローチが「前から順に見る」になります
  """
  @spec search(nums :: [integer], target :: integer) :: boolean
  def search(nums, target) do
    target in nums
  end
end
# @lc code=end
