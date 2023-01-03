#
# @lc app=leetcode id=21 lang=elixir
#
# [21] Merge Two Sorted Lists
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
  @spec merge_two_lists(list1 :: ListNode.t() | nil, list2 :: ListNode.t() | nil) ::
          ListNode.t() | nil
  def merge_two_lists(list1, nil) do
    list1
  end

  def merge_two_lists(nil, list2) do
    list2
  end

  def merge_two_lists(list1, list2) do
    if list1.val > list2.val do
      merge(list1, list2.next, %ListNode{list2 | next: nil})
    else
      merge(list1.next, list2, %ListNode{list1 | next: nil})
    end
  end

  def merge(list1, nil, head) do
    append(head, list1)
  end

  def merge(nil, list2, head) do
    append(head, list2)
  end

  def merge(list1, list2, head) do
    if list1.val > list2.val do
      merge(list1, list2.next, append(head, %ListNode{list2 | next: nil}))
    else
      merge(list1.next, list2, append(head, %ListNode{list1 | next: nil}))
    end
  end

  # NOTE: O(n)
  # The number of nodes in both lists is in the range [0, 50]. なので気にしていない
  def append(%{next: nil} = head, list) do
    %ListNode{head | next: list}
  end

  def append(head, list) do
    %ListNode{head | next: append(head.next, list)}
  end
end

defmodule Test do
  def test do
    l3 = %ListNode{val: 5, next: nil}
    l2 = %ListNode{val: 3, next: l3}
    l1 = %ListNode{val: 1, next: l2}
    m3 = %ListNode{val: 6, next: nil}
    m2 = %ListNode{val: 4, next: m3}
    m1 = %ListNode{val: 2, next: m2}
    Solution.merge_two_lists(l1, m1)
  end
end

# @lc code=end
