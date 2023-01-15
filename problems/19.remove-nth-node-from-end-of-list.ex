#
# @lc app=leetcode id=19 lang=elixir
#
# [19] Remove Nth Node From End of List
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
  ノードの個数が30個までな以上、めちゃくちゃ素直にノードの繋ぎ変えをした結果をレスポンスとすれば良いんじゃないかな？
  本当の最小の計算回数を追おうとすると先にサイズを計算しちゃうのは悪手になりそうだけど、この制約条件であればわかりやすさ重視で良さそう
  """
  @spec remove_nth_from_end(head :: ListNode.t() | nil, n :: integer) :: ListNode.t() | nil
  def remove_nth_from_end(head, n) do
    size = size(head)
    remove_at = size - n
    reconstruct(head, remove_at)
  end

  def size(node) do
    size(node, 0)
  end

  def size(nil, n) do
    n
  end

  def size(node, n) do
    size(node.next, n + 1)
  end

  def reconstruct(node, 0) do
    node.next
  end

  def reconstruct(node, remove_at) do
    %ListNode{val: node.val, next: reconstruct(node.next, remove_at - 1)}
  end
end

defmodule Test do
  def test_size do
    l3 = %ListNode{val: 3, next: nil}
    l2 = %ListNode{val: 2, next: l3}
    l1 = %ListNode{val: 1, next: l2}
    Solution.size(l1) |> IO.inspect()
  end

  def test do
    l7 = %ListNode{val: 7, next: nil}
    l6 = %ListNode{val: 6, next: l7}
    l5 = %ListNode{val: 5, next: l6}
    l4 = %ListNode{val: 4, next: l5}
    l3 = %ListNode{val: 3, next: l4}
    l2 = %ListNode{val: 2, next: l3}
    l1 = %ListNode{val: 1, next: l2}
    Solution.remove_nth_from_end(l1, 1) |> IO.inspect()
    Solution.remove_nth_from_end(l1, 2) |> IO.inspect()
    Solution.remove_nth_from_end(l1, 3) |> IO.inspect()
    Solution.remove_nth_from_end(l1, 4) |> IO.inspect()
    Solution.remove_nth_from_end(l1, 5) |> IO.inspect()
    Solution.remove_nth_from_end(l1, 6) |> IO.inspect()
    Solution.remove_nth_from_end(l1, 7) |> IO.inspect()
  end
end

# @lc code=end
