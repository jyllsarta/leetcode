#
# @lc app=leetcode id=45 lang=elixir
#
# [45] Jump Game II
#

# @lc code=start
defmodule Solution do
  # 問題の解釈が間違っていなければ、直球のダイクストラ法問題っぽい
  # 2 3 1 1 4 の 2 からスタートして、 3 or 1 にいけるので 両方に1をマーク
  # 2(0) 3(1) 1(1) 1 4 になる
  # 次に3を見て、3から行ける範囲は 1 1 4 なので それぞれに 2 をマーク ただし 1 でいけるところは1で行ったほうが得なので放置
  # 2(0) 3(1) 1(1) 1(2) 4(2)
  # 同様に末尾ノードに行くまでリストを埋めていく メモよりも小さな数値を書き込むことができるならメモを上書きする
  # 末尾まで行ったときの末尾に書いてある数値が答え
  # 普通のダイクストラ法と違って、とりあえずリストを前からなめていけば解けるようになってるので一般の問題よりは簡単なはず
  # ↑ TLE。 O(n) と勘違いしてたけどたしかに len(nums) * max(num) の n^2 だった...
  # discussion をチラ見してみると BFS らしい。たしかに
  # https://qiita.com/drken/items/996d80bcae64649a6580
  @spec jump(nums :: [integer]) :: integer
  def jump([_]) do
    0
  end

  def jump(nums) do
    # ランダムアクセスするのでnumsをmapにならす
    nums_map = for {x, index} <- Enum.with_index(nums), into: %{}, do: {index, x}
    mark([{0, 0}], nums_map, Enum.count(nums) - 1, MapSet.new())
  end

  def mark(queue, nums_map, target, searched)

  def mark([], _nums_map, _target, _searched) do
    nil
  end

  def mark([{index, rank} | queue], nums_map, target, searched) do
    num = Map.fetch!(nums_map, index)

    if target <= index + num do
      rank + 1
    else
      range = (index+1)..(index+num)
      additional_check = Enum.map(range, & {&1, rank+1}) |> Enum.filter(& !MapSet.member?(searched, elem(&1, 0)))
      searched = if additional_check == [] do
        searched
      else
         MapSet.union(searched, MapSet.new(range))
      end
      next = queue ++ additional_check
      mark(next, nums_map, target, searched)
    end
  end
end

defmodule Test do
  def test do
    [0] |> Solution.jump() |> IO.inspect()
    [2, 3, 1, 1, 4] |> Solution.jump() |> IO.inspect()
    [2, 3, 1, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1] |> Solution.jump() |> IO.inspect()
    [2, 5, 1, 1, 9, 7, 5, 1, 1, 1, 1, 1, 1, 1] |> Solution.jump() |> IO.inspect()
    [2, 3, 1, 1, 2, 1, 3, 1, 1, 1, 9, 1, 1, 1] |> Solution.jump() |> IO.inspect()
    [2, 0, 2, 0, 5, 0, 0, 0, 0, 1, 9, 1, 1, 1] |> Solution.jump() |> IO.inspect()
  end

  def clock do
    nums = for _ <- 1..10000, into: [], do: :rand.uniform(1000)
    :timer.tc(Solution, :jump, [nums]) |> IO.inspect
  end
end

# @lc code=end
