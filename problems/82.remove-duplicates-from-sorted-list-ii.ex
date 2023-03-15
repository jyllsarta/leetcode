#
# @lc app=leetcode id=82 lang=elixir
#
# [82] Remove Duplicates from Sorted List II
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
  @spec delete_duplicates(head :: ListNode.t() | nil) :: ListNode.t() | nil
  def delete_duplicates(head) do
    solve(head)
  end

  def solve(nil) do
    nil
  end

  # 自身と次と次が同じ -> 次の次をひとつだけ消す
  def solve(%{val: x, next: %{val: y, next: %{val: z}}} = head) when x == y and x == z do
    solve(%ListNode{head | next: head.next.next})
  end

  # 自身と次が同じ -> 自分と次を両方消す
  def solve(%{val: x, next: %{val: y}} = head) when x == y do
    solve(head.next.next)
  end

  # 自身と次が違う -> 自身を残す
  def solve(head) do
    %ListNode{head | next: solve(head.next)}
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

    IO.puts("1234567")
    Solution.delete_duplicates(l1) |> IO.inspect()

    l7 = %ListNode{val: 7, next: nil}
    l6 = %ListNode{val: 6, next: l7}
    l5 = %ListNode{val: 6, next: l6}
    l4 = %ListNode{val: 4, next: l5}
    l3 = %ListNode{val: 1, next: l4}
    l2 = %ListNode{val: 1, next: l3}
    l1 = %ListNode{val: 1, next: l2}

    IO.puts("1114667")
    Solution.delete_duplicates(l1) |> IO.inspect()

    l7 = %ListNode{val: 6, next: nil}
    l6 = %ListNode{val: 6, next: l7}
    l5 = %ListNode{val: 4, next: l6}
    l4 = %ListNode{val: 4, next: l5}
    l3 = %ListNode{val: 2, next: l4}
    l2 = %ListNode{val: 2, next: l3}
    l1 = %ListNode{val: 1, next: l2}

    IO.puts("1224466")
    Solution.delete_duplicates(l1) |> IO.inspect()
    :ok
  end
end

# @lc code=end
