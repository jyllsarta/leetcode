#
# @lc app=leetcode id=49 lang=elixir
#
# [49] Group Anagrams
#

# @lc code=start
defmodule Solution do
  @moduledoc """
  なんか、素因数分解すればいいだけな予感はする
  """
  @spec group_anagrams(strs :: [String.t()]) :: [[String.t()]]
  def group_anagrams(strs) do
    factorized = Enum.map(strs, &factorize/1)

    groups =
      for {factor, str} <- factorized, reduce: MultiValueSet.new() do
        acc -> MultiValueSet.put(acc, factor, str)
      end

    Map.values(groups)
  end

  def factorize(str) do
    chars = String.to_charlist(str)
    {do_factorize(chars, Multiset.new()), str}
  end

  def do_factorize([], set) do
    set
  end

  def do_factorize([head | rest], set) do
    do_factorize(rest, Multiset.incr(set, head))
  end
end

defmodule Multiset do
  @moduledoc """
  空のMapからはじめて、特定のkeyをincrするたびにその回数をカウントしてくれる
  ms = Multiset.new()
  ms = Multiset.put(ms, :a) # -> %{a: 1}
  ms = Multiset.put(ms, :a) # -> %{a: 2}
  ms = Multiset.put(ms, :b) # -> %{a: 2, b: 1}
  """
  def new do
    %{}
  end

  def incr(map, key) do
    if(Map.has_key?(map, key)) do
      %{map | key => map[key] + 1}
    else
      Map.put(map, key, 1)
    end
  end
end

defmodule MultiValueSet do
  @moduledoc """
  空のMapからはじめて、特定のkeyでputするたびに配列に追加してくれる
  mvs = MultiValueSet.new()
  mvs = MultiValueSet.put(mvs, :a, 1) # -> %{a: [1]}
  mvs = MultiValueSet.put(mvs, :a, 2) # -> %{a: [2, 1]}
  mvs = MultiValueSet.put(mvs, :b, 3) # -> %{a: [2, 1], b: [3]}
  """
  def new do
    %{}
  end

  def put(map, key, value) do
    if(Map.has_key?(map, key)) do
      %{map | key => [value | map[key]]}
    else
      Map.put(map, key, [value])
    end
  end
end

defmodule Test do
  def test do
    Solution.group_anagrams(["aba", "aab", "bba"])
  end
end

# @lc code=end
