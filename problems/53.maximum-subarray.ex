#
# @lc app=leetcode id=53 lang=elixir
#
# [53] Maximum Subarray
#

# @lc code=start
defmodule Solution do
  @moduledoc """
  両側から削っていくタイプの問題...ぽい
  現在のリスト全体の総和を S とおく
  リストの手前の端っこから処理をしていく
  プラスが連続していたらマージして、手前区間の総和 A としておく
  マイナス B に突き当たったら
  Aと反対側から削ったときの合計 C (= S - A - B)
  をまず比較する、C>Aなら手前側にあるものが美味しくなくて、奥に確実に夢がある
  この場合はA+B<0なら、AもBもセットで切り落せばSがA+B分だけ増える
  A>=Cなら奥の夢次第で結果が読みきれないので保留... でもなんかいまいち！
  結構保留パターンが増えそう

  ちょっと動画見に行ったらKadane's Algorhythmというので解くらしい
  現状のMaxをHP的に前から順番に保持していって、
  * 前から進んできて今回を取り込んだ結果
  * 過去を捨てて今から再スタートした結果
  のmaxを次のターンに持ち込むって感じぽい
  """
  @spec max_sub_array(nums :: [integer]) :: integer
  def max_sub_array([head | rest]) do
    kadane(rest, head, head)
  end

  def kadane([], _score, result) do
    result
  end

  def kadane([head | rest], score, result) do
    next = max(head, score + head)
    result = max(next, result)
    kadane(rest, next, result)
  end
end

defmodule Test do
  def test do
    nums = [-2,1,-3,4,-1,2,1,-5,4]
    Solution.max_sub_array(nums) |> IO.inspect()
  end
end
# @lc code=end
