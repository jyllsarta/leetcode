#
# @lc app=leetcode id=61 lang=elixir
#
# [61] Rotate List
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
  @spec rotate_right(head :: ListNode.t() | nil, k :: integer) :: ListNode.t() | nil
  def rotate_right(nil, _k), do: nil
  def rotate_right(%{next: nil} = head, _k), do: head
  def rotate_right(head, 0), do: head

  def rotate_right(head, k) do
    count = count_length(head)
    effective = count - rem(k, count)

    header = only_head(head, effective)
    tailer = only_tail(head, effective)

    if is_nil(tailer) do
      header
    else
      amend(tailer, header)
    end
  end

  def only_head(head, 1) do
    %{head | next: nil}
  end

  def only_head(head, effective) do
    %{head | next: only_head(head.next, effective - 1)}
  end

  def only_tail(head, 1) do
    head.next
  end

  def only_tail(head, effective) do
    only_tail(head.next, effective - 1)
  end

  def amend(%{next: nil} = head, tail) do
    %{head | next: tail}
  end

  def amend(head, tail) do
    %{head | next: amend(head.next, tail)}
  end

  def count_length(list) do
    do_length(list, 0)
  end

  def do_length(nil, count), do: count
  def do_length(list, count), do: do_length(list.next, count + 1)
end

defmodule Test do
  def test do
    l7 = %ListNode{val: 7, next: nil}
    l6 = %ListNode{val: 6, next: l7}
    l5 = %ListNode{val: 5, next: l6}
    l4 = %ListNode{val: 4, next: l5}
    l3 = %ListNode{val: 3, next: l4}
    l2 = %ListNode{val: 2, next: l3}
    l1 = %ListNode{val: 1, next: l2}

    Solution.amend(l5, l5) |> IO.inspect()
    Solution.only_head(l1, 3) |> IO.inspect()
    Solution.only_tail(l1, 3) |> IO.inspect()
    IO.puts("---case---: 0")
    Solution.rotate_right(l1, 0) |> IO.inspect()
    IO.puts("---case---: 1")
    Solution.rotate_right(l1, 1) |> IO.inspect()
    IO.puts("---case---: 3")
    Solution.rotate_right(l1, 3) |> IO.inspect()
    IO.puts("---case---: 7")
    Solution.rotate_right(l1, 7) |> IO.inspect()
    IO.puts("---case---: 7x")
    Solution.rotate_right(l1, 7 * 1_000_000) |> IO.inspect()
    IO.puts("---case---: 7x+1")
    Solution.rotate_right(l1, 7 * 1_000_000 + 1) |> IO.inspect()
  end
end

# @lc code=end
