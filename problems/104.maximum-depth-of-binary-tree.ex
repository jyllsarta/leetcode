#
# @lc app=leetcode id=104 lang=elixir
#
# [104] Maximum Depth of Binary Tree
#

# @lc code=start
# Definition for a binary tree node.
#
defmodule TreeNode do
  @type t :: %__MODULE__{
          val: integer,
          left: TreeNode.t() | nil,
          right: TreeNode.t() | nil
        }
  defstruct val: 0, left: nil, right: nil
end

defmodule Solution do
  @spec max_depth(root :: TreeNode.t | nil) :: integer
  def max_depth(root) do
    dig(root, 0)
  end

  defp dig(nil, depth) do
    depth
  end

  defp dig(node, depth) do
    max(dig(node.left, depth + 1), dig(node.right, depth + 1))
  end
end

defmodule Test do
  def test do
    t1 = %TreeNode{}
    t2 = %TreeNode{right: t1}
    t3 = %TreeNode{right: t2}
    t4 = %TreeNode{right: t3}
    t5 = %TreeNode{right: t4}
    t6 = %TreeNode{right: t5}
    y1 = %TreeNode{}
    y2 = %TreeNode{right: y1}
    y3 = %TreeNode{right: y2, left: t6}
    g1 = %TreeNode{right: y3}
    Solution.max_depth(g1)
  end
end

# @lc code=end
