#
# @lc app=leetcode id=93 lang=elixir
#
# [93] Restore IP Addresses
#

# @lc code=start
defmodule Solution do
  @moduledoc """
  255255255255 という max 12桁の数値に対して、ドットを挟める場所が11個
  任意の3箇所選んでドットを打って、結果がvalidかどうかを判定する問題かな
  11 C 3 なので、11 * 10 * 9 / 3 * 2 * 1 = 165
  なんか全探索しても十分に耐えられそうな組み合わせ数に見える
  もちろん一個のオクテットが4桁以上になるような組み合わせとかは捨てて良くて、あとから削れば良さそう
  1 <= s.length <= 20 && s consists of digits only. なので、Elixirであれば整数型で十分扱える
  """
  @spec restore_ip_addresses(s :: String.t) :: [String.t]
  def restore_ip_addresses(s) do
    numlist = s |> String.to_integer() |> to_numlist()
    digits = String.length(s)
    combinations = combinations(digits)
    chunks = Enum.map(combinations, & chunk(numlist, &1))
  end

  @doc """
  123 -> [1,2,3]
  """
  def to_numlist(num) do
    digits = :math.log10(num) |> Kernel.trunc()
    for x <- 0..(digits), into: [] do
      num |> div(10 ** x) |> rem(10)
    end
    |> Enum.reverse()
  end

  @doc """
  X個から3個取る組み合わせを列挙する
  5 -> [0,1,2], [0,1,3] ... [2,3,4]
  https://elixirforum.com/t/generate-all-combinations-having-a-fixed-array-size/26196/16
  あんまいい方法なさそう
  ちゃんとロジック考えるともっと詰められそうだけど、一旦正しい値が返ってくるのが確実な富豪的なやり方でいく
  """
  def combinations(digits) do
    range = 0..(digits - 1)
    # せめてもの抵抗で x != y, y != z, x != z の条件を足して組み合わせ数の増加を抑える
    candidates = for x <- range, y <- range, z <- range, x != y, y != z, x != z, do: Enum.sort([x, y, z])
    Enum.uniq(candidates)
  end

  @doc """
  第一引数を第二引数(must sorted)の位置でカットする
  [1,2,3,4,5,6,7,8,9], [0,1,5] -> [[1], [2], [3,4,5,6], [7,8,9]]
  """
  def chunk(list, cut_positions) do
    # これ考えてたけどnumlistじゃなくてString.split_at使うほうがスムーズかも
  end
end

# なんか 1ファイル構成よりも Mix プロジェクトにしてテストしたほうが楽かもな
defmodule Test do
  def test_numlist do
    Solution.to_numlist(123123123123) |> IO.inspect()
    Solution.to_numlist(98765) |> IO.inspect()
  end

  def test_combinations do

  end
end
# @lc code=end
