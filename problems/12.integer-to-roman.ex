#
# @lc app=leetcode id=12 lang=elixir
#
# [12] Integer to Roman
#

# @lc code=start
defmodule Solution do
  @spec int_to_roman(num :: integer) :: String.t()
  # 1 <= num <= 3999
  def int_to_roman(num) do
    do_int_to_roman(num, []) |> Enum.reverse() |> List.to_string()
  end

  def do_int_to_roman(num, acc) when num >= 1000 do
    do_int_to_roman(num - 1000, [?M | acc])
  end

  def do_int_to_roman(num, acc) when num >= 900 do
    do_int_to_roman(num - 900, [?M, ?C | acc])
  end

  def do_int_to_roman(num, acc) when num >= 500 do
    do_int_to_roman(num - 500, [?D | acc])
  end

  def do_int_to_roman(num, acc) when num >= 400 do
    do_int_to_roman(num - 400, [?D, ?C | acc])
  end

  def do_int_to_roman(num, acc) when num >= 100 do
    do_int_to_roman(num - 100, [?C | acc])
  end

  def do_int_to_roman(num, acc) when num >= 90 do
    do_int_to_roman(num - 90, [?C, ?X | acc])
  end

  def do_int_to_roman(num, acc) when num >= 50 do
    do_int_to_roman(num - 50, [?L | acc])
  end

  def do_int_to_roman(num, acc) when num >= 40 do
    do_int_to_roman(num - 40, [?L, ?X | acc])
  end

  def do_int_to_roman(num, acc) when num >= 10 do
    do_int_to_roman(num - 10, [?X | acc])
  end

  def do_int_to_roman(num, acc) when num >= 9 do
    do_int_to_roman(num - 9, [?X, ?I | acc])
  end

  def do_int_to_roman(num, acc) when num >= 5 do
    do_int_to_roman(num - 5, [?V | acc])
  end

  def do_int_to_roman(num, acc) when num >= 4 do
    do_int_to_roman(num - 4, [?V, ?I | acc])
  end

  def do_int_to_roman(num, acc) when num >= 1 do
    do_int_to_roman(num - 1, [?I | acc])
  end

  def do_int_to_roman(0, acc) do
    acc
  end
end

# @lc code=end
