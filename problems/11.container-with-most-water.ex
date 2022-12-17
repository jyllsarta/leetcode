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
    count = Enum.count(height)
    # list の末尾を触ることになるので大量のO(n)アクセスが発生してしまうので map にならす
    height_map = for {x, index} <- Enum.with_index(height), into: %{}, do: {index, x}
    if count < 2 do
      0
    else
      check(height_map, 0, count - 1, 0)
    end
  end

  def check(_, left, right, max_score) when left >= right do
    max_score
  end

  def check(height_map, left, right, max_score) do
    first = Map.fetch!(height_map, left)
    last = Map.fetch!(height_map, right)
    score = max(min(first, last) * (right - left), max_score)

    if first > last do
      check(height_map, left, right - 1, score)
    else
      check(height_map, left + 1, right, score)
    end  
  end
end

defmodule Test do
  def test do
    #case = [1,8,6,2,5,4,8,3,7]
    #Solution.max_area(case) |> IO.inspect()
    #case = for _ <- 1..100, into: [], do: :rand.uniform(10000)
    #:timer.tc(Solution, :max_area, [case]) |> IO.inspect
    #case = for _ <- 1..1000, into: [], do: :rand.uniform(10000)
    #:timer.tc(Solution, :max_area, [case]) |> IO.inspect
    case = for _ <- 1..10000, into: [], do: :rand.uniform(10000)
    :timer.tc(Solution, :max_area, [case]) |> IO.inspect
  end
end

# @lc code=end
