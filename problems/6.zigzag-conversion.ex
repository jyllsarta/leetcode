#
# @lc app=leetcode id=6 lang=elixir
#
# [6] Zigzag Conversion
#

# @lc code=start
defmodule Solution do
  @spec convert(s :: String.t(), num_rows :: integer) :: String.t()
  def convert(s, num_rows) do
    efective_rows = min(num_rows, String.length(s))
    freq = max((efective_rows - 1) * 2, 1)

    # s consists of English letters (lower-case and upper-case), ',' and '.' なのでcharlistで管理可能
    mods =
      s
      |> String.to_charlist()
      |> Enum.with_index(&{&1, &2})
      |> Enum.group_by(fn {_, n} -> rem(n, freq) end, fn {x, _} -> x end)

    for n <- 1..efective_rows, into: [] do
      keys = keys(n, efective_rows)
      zip(mods, keys)
    end
    |> List.flatten()
    |> List.to_string()
  end

  def keys(1, _num_rows) do
    [0]
  end

  def keys(n, num_rows) when n == num_rows do
    [n - 1]
  end

  def keys(n, num_rows) do
    [n - 1, num_rows * 2 - n - 1]
  end

  def zip(mods, [key]) do
    Map.get(mods, key, [])
  end

  def zip(mods, [key1, key2]) do
    # すごいダーティなハックだけどkey2側は1文字足りない可能性があるので、flattenで消える空リストをappendする
    l1 = Map.get(mods, key1, [])
    l2 = Map.get(mods, key2, []) ++ [[]]
    Enum.zip_with(l1, l2, &[&1, &2])
  end
end

# @lc code=end
