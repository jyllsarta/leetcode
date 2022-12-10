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
  @spec add_two_numbers(l1 :: ListNode.t | nil, l2 :: ListNode.t | nil) :: ListNode.t | nil
  def add_two_numbers(l1, l2) do
    sum = value(l1) + value(l2)
    output(sum)
  end

  defp value(list_node) do
    value(list_node, 0, 0)
  end

  defp value(%ListNode{next: nil, val: val}, sum, rank) do
    sum + val * pow10(rank)
  end

  defp value(list_node, sum, rank) do
    value(list_node.next, sum + list_node.val * pow10(rank), rank + 1)
  end

  defp output(sum) when sum >= 10 do
    %ListNode{val: rem(sum, 10), next: output(div(sum, 10))}
  end

  defp output(sum) do
    %ListNode{val: sum, next: nil}
  end

  # https://qiita.com/torifukukaiou/items/2f739c12c031325016a2
  # :math.pow(10, 23) 以降はfloatで壊れていくので自作するしかないっぽい
  def pow10(rank) do
    for _ <- List.duplicate(nil, rank), reduce: 1 do acc-> acc * 10 end
  end
end
