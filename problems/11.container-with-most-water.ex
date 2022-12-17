#
# @lc app=leetcode id=11 lang=elixir
#
# [11] Container With Most Water
#

# @lc code=start
defmodule Solution do
  @spec max_area(height :: [integer]) :: integer
  # このヒント見ちゃった
  # https://leetcode.com/problems/container-with-most-water/discussion/comments/1567582
  # If we move from the smaller side, there is a chance that we might increase the area.
  # If we move from the bigger side, there is no chance in all possible cases:
  # ポインター狭め系アプローチでいけそう
  # 両脇からスタートして、小さい方を中央寄りに動かす
  # 同じならどっちを動かしても別に大きくなることはない
  def max_area(height) do
    distance = Enum.count(height) - 1
    {last_element, _} = List.pop_at(height, -1)
    check(height, 0, distance, last_element)
  end

  def check([], max_score, _, _) do
    max_score
  end

  def check([_], max_score, _, _) do
    max_score
  end

  def check(height, max_score, distance, last_element) do
    [first | remains] = height
    score = max(min(first, last_element) * distance, max_score)

    if first > last_element do
      # この2回操作はちょっとダサい...
      {_, tail} = List.pop_at(height, -1)
      {next_last, _} = List.pop_at(tail, -1)
      check(tail, score, distance - 1, next_last)
    else
      check(remains, score, distance - 1, last_element)
    end
  end
end

defmodule Test do
  def test do
    #case = [1,18,17,1]
    #Solution.max_area(case) |> IO.inspect()
    case = for _ <- 1..100, into: [], do: :rand.uniform(10000)
    :timer.tc(Solution, :max_area, [case]) |> IO.inspect
    case = for _ <- 1..1000, into: [], do: :rand.uniform(10000)
    :timer.tc(Solution, :max_area, [case]) |> IO.inspect
    case = for _ <- 1..10000, into: [], do: :rand.uniform(10000)
    :timer.tc(Solution, :max_area, [case]) |> IO.inspect
  end
end

# @lc code=end
