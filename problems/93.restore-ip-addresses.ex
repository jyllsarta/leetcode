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
  """
  @spec restore_ip_addresses(s :: String.t) :: [String.t]
  def restore_ip_addresses(s) do
    digits = String.length(s)
    combinations = combinations(digits - 1)
    ips = Enum.map(combinations, & chunk(s, &1))
    ips = Enum.filter(ips, &valid_ip?/1)
    Enum.map(ips, &format/1)
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
  第一引数を第二引数(must sorted)の位置でカット
  "123456789", [0,1,5] -> ["1","2","345","6789"]
  """
  def chunk(string, [c1, c2, c3]) do
    rest = string
    next_pos = c1 + 1
    {s1, rest} = String.split_at(rest, next_pos)
    next_pos = c2 - c1
    {s2, rest} = String.split_at(rest, next_pos)
    next_pos = c3 - c2
    {s3, s4} = String.split_at(rest, next_pos)
    [s1,s2,s3,s4]
  end

  @doc """
  ["123","123","123","123"] -> true
  ["123","123","123","0"]   -> true
  ["123","123","123","023"] -> false
  ["123","123","123","256"] -> false
  """
  def valid_ip?(ip) do
    valid_zero_padding?(ip) && valid_octet?(ip)
  end

  def valid_zero_padding?(ip) do
    Enum.all?(ip, &do_valid_zero_padding?/1)
  end

  def do_valid_zero_padding?(octet) do
    !(String.length(octet) > 1 && String.starts_with?(octet, "0"))
  end

  def valid_octet?(ip) do
    Enum.all?(ip, &do_valid_octet?/1)
  end

  def do_valid_octet?(octet) do
    num = String.to_integer(octet)
    0 <= num && num <= 255
  end

  def format(ip) do
    Enum.join(ip, ".")
  end
end

# なんか 1ファイル構成よりも Mix プロジェクトにしてテストしたほうが楽かもな
defmodule Test do
  def test_chunk do
    Solution.chunk("123123123123", [2,5,8]) |> IO.inspect()
    Solution.chunk("123456789", [0,1,4]) |> IO.inspect()
  end

  def test_combinations do
    Solution.combinations(5) |> IO.inspect()
  end

  def test do
    Solution.restore_ip_addresses("255255255255") |> IO.inspect()
    Solution.restore_ip_addresses("25525511135") |> IO.inspect()
    Solution.restore_ip_addresses("101023") |> IO.inspect()
    Solution.restore_ip_addresses("0000") |> IO.inspect()
  end
end
# @lc code=end
