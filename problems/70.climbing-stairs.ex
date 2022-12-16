#
# @lc app=leetcode id=70 lang=elixir
#
# [70] Climbing Stairs
#

# @lc code=start
defmodule Solution do
  @spec climb_stairs(n :: integer) :: integer
  def climb_stairs(n) do
    {:ok, memo} = Memo.start_link()
    check(n, memo)
  end

  def check(0, _), do: 0
  def check(1, _), do: 1
  def check(2, _), do: 2

  # 5段の階段をのぼる方法は  (1歩 + 4段の方法) + (2歩 + 3段の方法)
  # やってることはフィボナッチ亜種なのでメモ化がガッツリ効く
  def check(n, memo) do
    if Memo.get(memo, n) do
      Memo.get(memo, n)
    else
      answer = check(n - 1, memo) + check(n - 2, memo)
      Memo.put(memo, n, answer)
      answer
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
end

# @lc code=end
