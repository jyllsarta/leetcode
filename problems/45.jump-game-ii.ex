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
  @spec jump(nums :: [integer]) :: integer
  def jump(nums) do
    {:ok, memo} = Memo.start_link()
    # スタート地点にはゼロ歩で行ける
    Memo.put(memo, 0, 0)

    for {num, index} <- Enum.with_index(nums) do
      mark(num, index, memo)
    end

    Memo.get(memo, Enum.count(nums) - 1)
  end

  def mark(0, _, _), do: :noop

  def mark(num, index, memo) do
    cost_to_reach_here = Memo.get(memo, index)

    for distance <- 1..num do
      memoized = Memo.get(memo, index + distance)

      cond do
        is_nil(memoized) ->
          Memo.put(memo, index + distance, cost_to_reach_here + 1)

        cost_to_reach_here + 1 < memoized ->
          Memo.put(memo, index + distance, cost_to_reach_here + 1)

        true ->
          :noop
      end
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

  def dump(memo) do
    Agent.get(memo, &Kernel.tap(&1, fn -> IO.inspect(&1) end))
  end
end

defmodule Test do
  def test do
    [2, 3, 1, 1, 4] |> Solution.jump() |> IO.inspect()
    [2, 3, 1, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1] |> Solution.jump() |> IO.inspect()
    [2, 5, 1, 1, 9, 7, 5, 1, 1, 1, 1, 1, 1, 1] |> Solution.jump() |> IO.inspect()
    [2, 3, 1, 1, 2, 1, 3, 1, 1, 1, 9, 1, 1, 1] |> Solution.jump() |> IO.inspect()
    [2, 0, 2, 0, 5, 0, 0, 0, 0, 1, 9, 1, 1, 1] |> Solution.jump() |> IO.inspect()
  end

  def clock do
    nums = for _ <- 1..1000, into: [], do: :rand.uniform(100)
    :timer.tc(Solution, :jump, [nums]) |> IO.inspect
  end
end

# @lc code=end
