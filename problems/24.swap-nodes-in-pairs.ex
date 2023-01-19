#
# @lc app=leetcode id=24 lang=elixir
#
# [24] Swap Nodes in Pairs
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
  シンプルに、2個とって入れ替える、2個とって入れ替えるを繰り返せば良いはず
  """
  @spec swap_pairs(head :: ListNode.t() | nil) :: ListNode.t() | nil
  def swap_pairs(head) do
    swap(head)
  end

  def swap(nil) do
    nil
  end

  def swap(%ListNode{next: nil} = head) do
    head
  end

  def swap(head) do
    # head = %{val: 1, next: next}
    # next = %{val: 2, next: %{val: 3}}
    nextnext = swap(head.next.next)
    head_to_nextnext = %ListNode{head | next: nextnext}
    %ListNode{head.next | next: head_to_nextnext}
  end
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
    Solution.swap_pairs(l1) |> IO.inspect()
  end
end

# @lc code=end
