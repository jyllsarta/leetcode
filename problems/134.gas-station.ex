#
# @lc app=leetcode id=134 lang=elixir
#
# [134] Gas Station
#

# @lc code=start
defmodule Solution do
  @moduledoc """
  え、わからん　適切に枝刈りする総当りじゃダメっぽい値域設定なんだけど、オーダーを下げるアイデアが特に無い
  楽観的に行くならガスの供給量が多いところかコストの安いところから見当をつけて探索するのが良いんだろうけど、意地悪なケースがありそうに感じる
  うーん　旅行失敗するには ガス < コスト の壁みたいなところが何箇所か必要で、それを計算元に使えそうで使えない
  1000ガス最初に手に入れて1コスずつ払うケースだと壁999箇所の探索が必要
  1ガス手に入れ続けて最後に1000コス払うケースだと1ガス999箇所の探索が必要
  あー、でいうと差し引きコストの数列にして、1軸で簡単化することはできる
  差し引きコストがマイナスのところは考慮不要、一個検討したあと、検討箇所の次がプラスだったら前の条件より悪くなるだけなので検討不要
  最悪ケースは[1, -1, 1, -1, 1 ... -2]でプラ1の場所を全部検討しなきゃいけないけど、結局毎回-2を食らって諦めなきゃいけないパターン？
  ダメなケースは総和マイナスになる？
  総和マイナスじゃないけどダメなケースはある？途中にある宝の山を拾えないパターンになりそう なんかなさそうだぞ
  総和ゼロで時間かかるケースは... [1, -2, 2, -3, 3, -4, 1, 1, 1, 1] で、末尾スタートが正解の場合かな
  もしかすると、ある場所から区間を単純化することができて、単純化した結果プラスになる場所を探している？
  単純化の結果起点になりうる場所を潰してしまう可能性があるので、安易にやっちゃいけなさそう
  だが、クイックソート的な考え方は導入できそう、半分に分けて総和がマイナスの場所はダメとか検討できる？
  [-5,-5,-5, 14], [1, 1, 0, 0] の14を見逃す可能性がある、ダメ
  連続するマイナスを固める、連続するプラスを固めるはできる、めちゃめちゃ入り乱れてる場合は無理かな
  いや、乱れてる場合でも起点候補から圧縮していけそう

  [1, -2, 2, -3, 3, -4, 1, 1, 1]
  プラスを圧縮する
  [1, -2, 2, -3, 3, -4, 3]
  起点候補(=プラスのやつ全部)に印をつける 前から順番に
  [1(a), -2, 2(b), -3, 3(c), -4, 3(d)]
  a スタート ダメだった (aから-2) は全体的には -1
  [-1, 2(b), -3, 3(c), -4, 3(d)]
  b スタート ダメだった (bから-3) は全体的には -1
  [-1, -1, 3(c), -4, 3(d)]
  c スタート ダメだった (cから-4) は全体的には -1
  [-1, -1, -1, 3(d)]
  d スタート マイナス1が3つしかない 総和ゼロ 勝ち
  [-1, -1, -1, 3(d)]

  いけそうなのはいいんだけど、Elixirでこのアルゴリズムが無駄なく表現できるデータ構造どうすっかな
  あー、前のマイナスは累積負債として1項で表現できる？そして、プラスの合体はどうせ前から見ていく関係上一番最初に一番いいやつを検討するのでわざわざやんなくても良さそう

  0, [1(a), -2, 2(b), -3, 3(c), -4, 1(d), 1(e), 1(f)]
  a 行けそうと思ったら マイナス2にやられた、 a から -2 までを通ると1減るんだな、メモっとこ
  -1, [2(b), -3, 3(c), -4, 1(d), 1(e), 1(f)]
  b 行けそうと思ったらマイナス2にやられた、 b から -3 までを通ると1減るんだな、つまりaから全体で見て-2だ
  -2, [3(c), -4, 1(d), 1(e), 1(f)]
  同様に
  -3, [1(d), 1(e), 1(f)]
  d の総和 >= メモにある累積負債 なので dからいくのが正解です！ dのインデックスを回答する

  めちゃO(n) っぽい、これだ(厳密にO(n) ではなく、毎チャレンジごとに最悪ケースでn回計算入るので三角形のn^2)

  総和ゼロなのにいけないことあるんだろうか、ない気がする
  どこかの壁を高くした分だけどこかのガス供給が増えて、その供給箇所が解になるように移動する気がする

  これの最悪は [1,1,1,1,-5,1] かな これでダメなようなら複数のプラスを圧縮する処理を導入する

  測ってみると上記最悪ケースでも{471786, 9999} なので許容範囲っぽい処理時間 まだ詰めれるけどこれでいいか

  ↑ 10^5だから桁一個間違えてた、プラスとマイナスの連続消化やりましょう...
  プラマイ連続消化によって、
  * プラマイ激しく入れ替わって目先に死因がある場合はreduce_whileでhaltしてくれる
  * 遠くにある場合はaccumulateされてくれる
  でほぼO(n)になったはず
  """
  @spec can_complete_circuit(gas :: [integer], cost :: [integer]) :: integer
  def can_complete_circuit(gas, cost) do
    deltas =
      for {{plus, minus}, index} <- Enum.zip(gas, cost) |> Enum.with_index(),
          do: {plus - minus, index}

    # TODO: sum(deltas) < 0: -1
    solve(0, deltas)
  end

  def solve(_total_minus, []) do
    -1
  end

  # マイナスの連続消化
  def solve(total_minus, [{delta, index} | rest]) when delta < 0 do
    solve(total_minus + delta, rest)
  end

  def solve(total_minus, [{delta, index} | rest] = route) do
    # IO.inspect("total_minus: #{total_minus}")
    sum =
      Enum.reduce_while(route, 0, fn {delta, _}, acc ->
        if delta + acc < 0, do: {:halt, nil}, else: {:cont, delta + acc}
      end)

    # IO.inspect("sum: #{sum}")
    # IO.inspect(route)

    if !is_nil(sum) && sum + total_minus >= 0 do
      index
    else
      {plus_delta, rest} = accumulate_non_neg_area(0, route)
      solve(total_minus + plus_delta, rest)
    end
  end

  def accumulate_non_neg_area(acc, []) do
    {acc, []}
  end

  def accumulate_non_neg_area(acc, [{delta, _} | _] = route) when delta < 0 do
    {acc, route}
  end

  def accumulate_non_neg_area(acc, [{delta, _} | rest]) do
    accumulate_non_neg_area(acc + delta, rest)
  end
end

defmodule Test do
  def test do
    IO.puts("truthy")
    gas = [1, 2, 3, 4, 5]
    cost = [3, 4, 5, 1, 2]
    Solution.can_complete_circuit(gas, cost) |> IO.inspect()

    gas = [1, -2, 2, -3, 3, -4, 1, 1, 1]
    cost = for _ <- 0..1000, into: [], do: 0
    Solution.can_complete_circuit(gas, cost) |> IO.inspect()

    gas = [1, 1, 1, 1, -6, 2]
    cost = for _ <- 0..1000, into: [], do: 0
    Solution.can_complete_circuit(gas, cost) |> IO.inspect()

    gas = [2]
    cost = [2]
    Solution.can_complete_circuit(gas, cost) |> IO.inspect()

    IO.puts("falsey")
    gas = [2, 3, 4]
    cost = [3, 4, 3]
    Solution.can_complete_circuit(gas, cost) |> IO.inspect()

    gas = [1, 1, 1, 1, -6, 1]
    cost = for _ <- 0..1000, into: [], do: 0
    Solution.can_complete_circuit(gas, cost) |> IO.inspect()

    # 34
    gas = [1, 2, 3, 4, 3, 2, 4, 1, 5, 3, 2, 4]
    # 36
    cost = [1, 1, 1, 3, 2, 4, 3, 6, 7, 4, 3, 1]
    Solution.can_complete_circuit(gas, cost) |> IO.inspect()
  end

  # 最悪OK
  def clock do
    gas = for _ <- 0..99997, into: [], do: 1
    cost = for _ <- 0..99999, into: [], do: 0
    gas = gas ++ [-99999, 2]
    :timer.tc(Solution, :can_complete_circuit, [gas, cost]) |> IO.inspect()
  end

  # 最悪ダメケース
  def clock2 do
    gas = for _ <- 0..99997, into: [], do: 1
    cost = for _ <- 0..99999, into: [], do: 0
    gas = gas ++ [-100_000, 1]
    :timer.tc(Solution, :can_complete_circuit, [gas, cost]) |> IO.inspect()
  end

  # ゼロだらけケース
  def clock3 do
    gas = for _ <- 0..99996, into: [], do: 0
    cost = for _ <- 0..99999, into: [], do: 0
    gas = [-1 | gas] ++ [-1, 1]
    :timer.tc(Solution, :can_complete_circuit, [gas, cost]) |> IO.inspect()
  end
end

# @lc code=end
