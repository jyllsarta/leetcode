#
# @lc app=leetcode id=39 lang=elixir
#
# [39] Combination Sum
#

# @lc code=start
defmodule Solution do
  @moduledoc """
  パッと見ヤバそうなんだけど、数値40候補30個なんでなんだかんだ数え上げられる説がある
  選択肢が2,3のとき
  T(n) = T(n-2) + T(n-3)
  な関係がある

  ターゲット40とかの場合からスタートする場合いろんな経路で残数5のシチュエーションにたどり着くので、メモ化が効く問題なのは間違いなさそう

  - - -

  ルートの重複は考慮したい
  7とるのに2-2-3 なのか、2-3-2 なのかで、両方数えて最後にuniq は計算量もったいなさそう
  7とるのにありえる選択肢は全部盛っちゃう戦略とかも考えられそう
  [2, 2*2, 2*3, 3, 3*2, 4]
  これで、この中から任意のパーツを重複なしに取っていくみたいな
  うーん、2 + 2*2 と 2*3 取りで選択が重複して良くないな
  あ、一個取ったら他の同一数値選択肢が消えれば良いのか
  [2, 2*2, 2*3, 3, 3*2, 4] vs 7
  =
    [2] + [3, 3*2, 4] vs 5
    [2*2] + [3, 3*2, 4] vs 3
    [2*3] + [3, 3*2, 4] vs 1 = []
    [3] + [2, 2*2, 2*3, 4] vs 4
    [3*2] + [2, 2*2, 2*3, 4] vs 1 = []
    [4] + [2, 2*2, 2*3, 3, 3*2] vs 3

  あーいや、ダメそうだ
  [2*2, 3] と [3, 2*2] が両方素朴に計算されちゃう

  - - -

  ターゲットが8, 選択肢が2,3,4とする
  T(0) = S{}
  T(1) = :unreachable
  T(2) = S{2}
  T(3) = S{3}
  T(4) = 2+T(2) ++ 3+T(1) ++ 4+T(0) = S{2+2} U S{} U S{4} = S{2+2, 4}
  T(5) = 2+T(3) ++ 3+T(2) ++ 4+T(1) = S{2,3} U S{2,3} U S{} = S{2+3}
  T(6) = 2+T(4) ++ 3+T(3) ++ 4+T(2) = S{2+2+2, 4+2} U S{3+3} U S{4+2} = S{2+2+2, 3+3, 4+2}
  T(7) は T(8) から参照されていないので気にしない
  T(8) = 2+T(6) ++ 3+T(5) ++ 4+T(4) = S{2+2+2+2, 2+3+3, 2+4+2} U S{3+2+3} U S{4+2+2, 4+4}
       = S{2+2+2+2, 2+3+3, 2+4+2, 3+2+3, 4+2+2, 4+4}
       = S{2+2+2+2, 2+3+3, 4+2+2, 4+4}
  (この重複排除は、2+2+2+2を 2*4 の multiset として扱えば良いはず)

  素朴！そしてメモに書き込む瞬間の時点でセットの最小化をできるので、メモを参照したのに重いってことにはならなさそう

  * add_memberができるmultiset を作ってテスト
  * multiset にメンバー足しながらルート集合を構築する1サイクルのスニペット
  * メモ化なしで解空間を構築してみる
  * 解のフォーマッティング
  * テスト
  * clock
  * メモ化してみる

  メモ化無しでclockが121297
  :timer.tc(Solution, :combination_sum, [[2,3,4,6,7], 30])
  """
  @spec combination_sum(candidates :: [integer], target :: integer) :: [[integer]]
  def combination_sum(candidates, target) do
    # candidates をソートする(多分不要だけどいちゃもんつけられたくないので...)
    candidates = Enum.sort(candidates)
    find(candidates, target)
  end

  def find(_candidates, 0), do: MapSet.new([%{}])
  def find([minimum | _], target) when target < minimum, do: :unreachable

  def find(candidates, target) do
    results = Enum.map(candidates, &incr_candidate(find(candidates, target - &1), &1))
    # IO.inspect(target)
    # IO.inspect(results)
    results = Enum.filter(results, & &1 != :unreachable)
    Enum.reduce(results, & MapSet.union(&1, &2))
  end

  # 経路一覧に、自分を一個追加する
  # S(2+2, 4), 2 -> S(2+2+2, 2+4)
  def incr_candidate(:unreachable, _candidate), do: :unreachable

  def incr_candidate(mapset, candidate) do
    # to_list 挟むの結構重そう...
    mapset |> MapSet.to_list() |> Enum.map(& incr_map(&1, candidate)) |> MapSet.new()
  end

  # multiset わざわざやんないでもこんなんでよさそう
  def incr_map(map, key) do
    if(Map.has_key?(map, key)) do
      %{map | key => map[key] + 1}
    else
      Map.put(map, key, 1)
    end
  end
end

defmodule Test do
  def test do
    Solution.combination_sum([2,3,4], 8)
  end

  def clock do
    :timer.tc(Solution, :combination_sum, [[2,3,4,6,7], 30])
  end
end
# @lc code=end
