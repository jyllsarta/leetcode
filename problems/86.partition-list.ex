#
# @lc app=leetcode id=86 lang=elixir
#
# [86] Partition List
#

# @lc code=start
# Definition for singly-linked list.
#
defmodule ListNode do
  @type t :: %__MODULE__{
          val: integer,
          next: ListNode.t() | nil
        }
  defstruct val: 0, next: nil
end

defmodule Solution do
  @moduledoc """
  これはまあ、おっきいものリストとちっちゃいものリストを作って最後にがっちゃんするだけじゃないの？
  順番の保存が必要だから最後にリバースが必要なくらいかしら

  あ、だめだ リストのコピー祭りになっちゃう
  おっきい物リストをなめながら溜め込むアプローチになるか
  おっきい物リストを...

  あれ？これもしかしてバブルソートの気持ちで行ける？

  いやそれもむりか しっぽから前に返していく再帰をやるのか
  小さい子はしっぽに興味があり、大きい子は頭に興味がある
  なんかだるいなこれ

  あーーーー、一回で舐めようとしないで2周フィルタすれば簡単だ、コードも読みやすくなるしそうしちゃお......
  """
  @spec partition(head :: ListNode.t() | nil, x :: integer) :: ListNode.t() | nil
  def partition(head, x) do
    smallers = select_small(head, x)
    biggers = select_bigger(head, x)
    catenate(smallers,biggers)
  end

  def select_small(nil, _x), do: nil
  def select_small(%{val: val, next: next} = head, x) when val < x do
    %ListNode{head | next: select_small(next, x)}
  end
  def select_small(%{next: next}, x), do: select_small(next, x)

  def select_bigger(nil, _x), do: nil
  def select_bigger(%{val: val, next: next} = head, x) when val >= x do
    %ListNode{head | next: select_bigger(next, x)}
  end
  def select_bigger(%{next: next}, x), do: select_bigger(next, x)

  def catenate(%{next: nil} = a, b) do
    %ListNode{a | next: b}
  end

  def catenate(nil, b) do
    b
  end
  def catenate(a, b) do
    %ListNode{a | next: catenate(a.next, b)}
  end
end

defmodule Test do
  def test do
    l7 = %ListNode{val: 1, next: nil}
    l6 = %ListNode{val: 2, next: l7}
    l5 = %ListNode{val: 3, next: l6}
    l4 = %ListNode{val: 4, next: l5}
    l3 = %ListNode{val: 5, next: l4}
    l2 = %ListNode{val: 6, next: l3}
    l1 = %ListNode{val: 7, next: l2}

    IO.puts("7654321,3 -> 21 | 76543")
    Solution.partition(l1, 3) |> IO.inspect()

    l7 = %ListNode{val: 7, next: nil}
    l6 = %ListNode{val: 6, next: l7}
    l5 = %ListNode{val: 6, next: l6}
    l4 = %ListNode{val: 4, next: l5}
    l3 = %ListNode{val: 1, next: l4}
    l2 = %ListNode{val: 1, next: l3}
    l1 = %ListNode{val: 1, next: l2}

    IO.puts("1114667,4 -> 111 | 4667")
    Solution.partition(l1, 4) |> IO.inspect()

    l7 = %ListNode{val: 1, next: nil}
    l6 = %ListNode{val: 5, next: l7}
    l5 = %ListNode{val: 3, next: l6}
    l4 = %ListNode{val: 2, next: l5}
    l3 = %ListNode{val: 8, next: l4}
    l2 = %ListNode{val: 9, next: l3}
    l1 = %ListNode{val: 2, next: l2}

    IO.puts("2982351,5 -> 2231 | 985")
    Solution.partition(l1, 5) |> IO.inspect()

    IO.puts("2982351,1 -> nil | 2982351")
    Solution.partition(l1, 1) |> IO.inspect()

    IO.puts("2982351,9 -> 282351 | 9")
    Solution.partition(l1, 9) |> IO.inspect()

    IO.puts("2982351,10 -> 2982351 | nil")
    Solution.partition(l1, 10) |> IO.inspect()

    IO.puts("nil -> nil | nil")
    Solution.partition(nil, 10) |> IO.inspect()
    :ok
  end
end

# @lc code=end
