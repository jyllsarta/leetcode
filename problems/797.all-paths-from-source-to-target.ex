#
# @lc app=leetcode id=797 lang=elixir
#
# [797] All Paths From Source to Target
#

# @lc code=start
defmodule Solution do
  @moduledoc """
  ノードを辿れる順に辿っていって、可能な道筋を各ノードに順番にメモってけばいいだけのような気がする
  """
  @spec all_paths_source_target(graph :: [[integer]]) :: [[integer]]
  def all_paths_source_target(graph) do
    {:ok, memo} = Memo.start_link()
    graph_map = construct(graph)
    goal = Enum.count(graph) - 1

    targets = Map.get(graph_map, 0)
    Enum.map(targets, &Memo.put(memo, &1, [[0]]))

    Enum.map(targets, &trace(graph_map, &1, goal, memo))
    Memo.get(memo, goal) |> Enum.uniq() |> Enum.map(&Enum.reverse([goal | &1]))
  end

  def construct(graph) do
    for {nodes, index} <- Enum.with_index(graph), into: %{} do
      {index, nodes}
    end
  end

  def trace(_graph_map, index, goal, _memo) when index == goal do
    :noop
  end

  def trace(graph_map, index, goal, memo) do
    targets = Map.get(graph_map, index)
    how_to_reach_here = Memo.get(memo, index)
    cateneted = Enum.map(how_to_reach_here, &[index | &1])

    Enum.map(targets, &Memo.put(memo, &1, cateneted))
    Enum.map(targets, &trace(graph_map, &1, goal, memo))
  end
end

defmodule Memo do
  use Agent

  def start_link do
    Agent.start_link(fn -> %{} end)
  end

  def get(memo, key) do
    Agent.get(memo, &Map.get(&1, key, []))
  end

  def put(memo, key, value) do
    current_value = get(memo, key)
    Agent.update(memo, &Map.put(&1, key, value ++ current_value))
  end
end

defmodule Test do
  def test do
    graph = [[4, 3, 1], [3, 2, 4], [3], [4], []]
    Solution.all_paths_source_target(graph) |> IO.inspect()
  end

  def space do
    graph = [[4,3,11,5,7,8,10,2,1,6],[2,9,3,11,10,6,7,4,5],[10,7,9,4,3,6,11,5],[9,4,11,6,8,10,7,5],[5,7,6,9,8,11,10],[8,7,11,9,10,6],[10,7,11,9,8],[9,10,11,8],[10,9],[11,10],[11],[]]
    Solution.all_paths_source_target(graph) |> IO.inspect()
  end
end

# @lc code=end
