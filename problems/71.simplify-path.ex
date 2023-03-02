#
# @lc app=leetcode id=71 lang=elixir
#
# [71] Simplify Path
#

# @lc code=start
defmodule Solution do
  @moduledoc """
  書いてある通りにすればいいだけなんだろうけど、それにしてはacceptance_rate低くて気持ち悪いな
  多分、 /a/../ とかが入ってんだろうなとは思う
  bashは普通にそれを受け付けるので、ちゃんと処理してみるかあ

  /a/../入ってたし、 /a/./ も入ってた
  """

  @spec simplify_path(path :: String.t()) :: String.t()
  def simplify_path(path) do
    path |> remove_duplicated_slash() |> remove_trailing_slash() |> resolve_parent_directories()
  end

  def remove_duplicated_slash(path) do
    Regex.replace(~r/\/+/, path, "/")
  end

  def remove_trailing_slash("/"), do: "/"

  def remove_trailing_slash(path) do
    Regex.replace(~r/\/$/, path, "")
  end

  def resolve_parent_directories(path) do
    # /a/b/c -> ["", "a", "b", "c"] で、最初の "" が不要
    [_ | chunks] = String.split(path, "/")
    do_resolve(chunks, []) |> Enum.join("/") |> then(&("/" <> &1))
  end

  def do_resolve(["." | rest], acc) do
    do_resolve(rest, acc)
  end

  def do_resolve([".." | rest], []) do
    do_resolve(rest, [])
  end

  def do_resolve([".." | rest], [_ | removed]) do
    do_resolve(rest, removed)
  end

  def do_resolve([item | rest], acc) do
    do_resolve(rest, [item | acc])
  end

  def do_resolve([], acc) do
    Enum.reverse(acc)
  end
end

defmodule Test do
  def test do
    do_test("/home/", "/home")
    do_test("/home//foo/", "/home/foo")
    do_test("/../", "/")
    do_test("/.", "/")
    do_test("/./", "/")
    do_test("/a/../", "/")
    do_test("/a/./", "/a")
    do_test("/a/./.a//b/./../", "/a/.a")
    do_test("/a/../b", "/b")
    do_test("/a/../b/../../..///../c/../../e/e/e/../..///////", "/e")
    do_test("/a/./b/../../c/", "/c")
    do_test("/", "/")
    :ok
  end

  def do_test(testcase, expected) do
    actual = Solution.simplify_path(testcase)

    IO.puts(
      "#{if expected == actual, do: :ok, else: :ng}. CASE:#{testcase} EXP:#{expected} ACT:#{actual}"
    )
  end
end

# @lc code=end
