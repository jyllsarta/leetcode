#
# @lc app=leetcode id=78 lang=elixir
#
# [78] Subsets
#

# @lc code=start
defmodule Solution do
  @moduledoc """
  すべての要素に対して、使うか使わないかを全部任意に設定するだけぽい
  10フラグの数え上げですね

  """
  @spec subsets(nums :: [integer]) :: [[integer]]
  def subsets(nums) do
    combinations = nums |> Enum.count() |> list()

    for combination <- combinations do
      for {selector, i} <- Enum.zip(combination, nums), selector do
        i
      end
    end
  end

  def list(1) do
    [[true], [false]]
  end

  def list(n) do
    trues = Enum.map(list(n - 1), &[true | &1])
    falses = Enum.map(list(n - 1), &[false | &1])
    trues ++ falses
  end
end

defmodule Test do
  def test do
    Solution.subsets([1, 2, 3])
  end

  def clock do
    :timer.tc(Solution, :subsets, [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]]) |> IO.inspect()
  end
end

# @lc code=end
