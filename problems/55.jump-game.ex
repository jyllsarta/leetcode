#
# @lc app=leetcode id=55 lang=elixir
#
# [55] Jump Game
#

# @lc code=start
defmodule Solution do
  # 先に 45 jump game2 を解いてしまったのだけど、これはルール一緒で到達の可不可を回答すればいいらしい
  # じゃあ深さ優先探索にすれば良いんじゃない？ということで、それ前提でやってみましょう
  # 最悪ケースで引っかかりそうと思ってやってたら本当に引っかかってしまった
  # じゃあコピペは諦めてこの問題の特徴を使って解こう
  # 行き詰まるケースには必ず0が含まれていて、そのゼロを飛び越える方法がなければアウト...でたぶんOK
  # 「ゼロを飛び越える」 == 当該ゼロからの距離をnとして、数値がnを超える要素がある
  @spec can_jump(nums :: [integer]) :: boolean
  def can_jump([_]) do
    true
  end

  def can_jump(nums) do
    # 方針通り素朴に解くなら後ろから見ていくことになるが、Elixirのリストは後ろの方を触るのが苦手なのでひっくり返す
    # 最後のマスにぴったり到達 == セーフなので、最後のマスだけは自分を追い越すではなくぴったし到達も許可する
    [first | rest] = Enum.reverse(nums)

    if first == 0 && unreachable?(rest) do
      false
    else
      check(rest)
    end
  end

  def check([]) do
    true
  end

  def check([0 | rest]) do
    if no_overtake?(rest) do
      false
    else
      check(rest)
    end
  end

  def check([_ | rest]) do
    check(rest)
  end

  # 自分より 一歩先のマスに進める選択肢がないか
  def no_overtake?(nums) do
    Enum.with_index(nums, 2) |> Enum.all?(&(elem(&1, 0) < elem(&1, 1)))
  end

  # 自分自身にぴったり到達する選択肢がないか
  def unreachable?(nums) do
    Enum.with_index(nums, 1) |> Enum.all?(&(elem(&1, 0) < elem(&1, 1)))
  end
end

defmodule Test do
  def test do
    IO.inspect("truthy cases")
    [0] |> Solution.can_jump() |> IO.inspect()
    # 最後の一歩で到達はtrueを返さなければならない
    [2, 0, 0] |> Solution.can_jump() |> IO.inspect()
    [1, 1, 2, 0, 0] |> Solution.can_jump() |> IO.inspect()
    [2, 3, 1, 1, 4] |> Solution.can_jump() |> IO.inspect()
    [2, 3, 1, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1] |> Solution.can_jump() |> IO.inspect()
    [2, 5, 1, 1, 9, 7, 5, 1, 1, 1, 1, 1, 1, 1] |> Solution.can_jump() |> IO.inspect()
    [2, 3, 1, 1, 2, 1, 3, 1, 1, 1, 9, 1, 1, 1] |> Solution.can_jump() |> IO.inspect()
    [2, 0, 2, 0, 5, 0, 0, 0, 0, 1, 9, 1, 1, 1] |> Solution.can_jump() |> IO.inspect()
    nums = for _ <- 1..10000, into: [], do: :rand.uniform(1000)
    :timer.tc(Solution, :can_jump, [nums]) |> IO.inspect()

    IO.inspect("falsey cases")
    [10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] |> Solution.can_jump() |> IO.inspect()
    [2, 0, 2, 0, 4, 0, 0, 0, 0, 1, 9, 1, 1, 1] |> Solution.can_jump() |> IO.inspect()
    [3, 2, 1, 0, 4] |> Solution.can_jump() |> IO.inspect()
    nums = for x <- 9998..0, into: [], do: x
    :timer.tc(Solution, :can_jump, [nums ++ [0]]) |> IO.inspect()
  end

  def clock do
    nums = for _ <- 1..10000, into: [], do: :rand.uniform(1000)
    :timer.tc(Solution, :can_jump, [nums]) |> IO.inspect()
  end

  def clock2 do
    # チョークポイント判定法でのハズレケース1 [2, 0, 2, 0, ...] と続いて、ギリ飛び越せる判定がちまちまと続く回
    # {320035, false} 怪しいが許されそうな数値とみた
    nums = for {_, index} <- Enum.with_index(0..9999), into: [], do: rem(index, 2) * 2
    :timer.tc(Solution, :can_jump, [nums ++ [2]]) |> IO.inspect()
  end

  def clock3 do
    # チョークポイント判定法でのハズレケース2 [9999, 0, 0, 0, ...] と続いて、毎回諦めかけて最後に飛べることがわかる回
    # {1037981, true} ダメかもしれない、多分これの類似テストケース同士の累積ダメージでTLEなると思う
    # [5,_,_,_,0] の最後の0を処理するとき、5がある以上その途中4マスに何があってもチョークポイント足り得ないので枝刈りできそう
    nums = for {_, index} <- Enum.with_index(0..9999), into: [], do: 0
    :timer.tc(Solution, :can_jump, [[20000 | nums]]) |> IO.inspect()
  end
end

# @lc code=end
