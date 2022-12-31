#
# @lc app=leetcode id=1140 lang=elixir
#
# [1140] Stone Game II
#

# @lc code=start
defmodule Solution do
  @moduledoc """
  [1,2,3,4,5,100] の例が分かりやすかった
  A: 12 だと MAXが4に拡張されるので、その場でBに3,4,5,100全部持ってかれる
  A: 1 で B: 2,3 だと Aが4,5,100取れちゃうのでBの正解ではない
  A: 1 で B: 2 だと Aは3,4取れるけど返しで100持ってかれる
  A: 1 で B: 2 で A:3 だと Bはまだ幅MAXが2で100確定で持ってかれるので4,5 取るしかない
  A: 1 で B: 2 で A:3, B: 4,5, A: 100 で 1 + 3 + 100 = 104

  ゲーム木作っちゃうか？と思ったが piles.length <= 100 なので探索範囲広くなりすぎそう
  でもまあ、とりあえず解いてみるってことでミニマックスやってみます

  テストケース 1..30 で {61418450, 166} 、ダメですね
  """
  @spec stone_game_ii(piles :: [integer]) :: integer
  def stone_game_ii(piles) do
    piles_map = for {x, index} <- Enum.with_index(piles), into: %{}, do: {index + 1, x}
    pile_count = Enum.count(piles)
    solve(piles_map, 0, pile_count, true, 2, 0, 0, [-100])
  end

  def solve(piles_map, picked_count, pile_count, alice_side?, max_pick, score, depth, history) do
    choices = 1..max_pick

    results =
      for pick <- choices, into: [] do
        end_index = min(picked_count + pick, pile_count)
        current_score = collect(piles_map, picked_count + 1, end_index)
        
        # 取り切れるなら取り切った結果が結論になる
        if pick + picked_count >= pile_count do
          if alice_side? do
            score + current_score
          else
            score
          end
        else
          next_max_pick = max(max_pick, pick * 2)
          score =
            if alice_side? do
              score + current_score
            else
              score
            end
          solve(piles_map, end_index, pile_count, !alice_side?, next_max_pick, score, depth + 1, [
            score | history
          ])
        end
      end

    IO.puts("DP: #{depth} picked: #{picked_count} AS:#{alice_side?} max_pick:#{max_pick}, score: #{score}")
    IO.inspect(history)
    IO.inspect(results ++ [""])
    if alice_side? do
      Enum.max(results)
    else
      Enum.min(results)
    end
  end

  def collect(_piles_map, first_index, end_index) when first_index > end_index do
    0
  end

  def collect(piles_map, first_index, end_index) do
    Enum.map(first_index..end_index, &Map.fetch!(piles_map, &1)) |> Enum.sum()
  end
end

defmodule Test do
  def test do
    # piles = [1, 2, 3, 4, 5, 100]
    # Solution.stone_game_ii(piles) |> IO.inspect()

    # piles = [2, 7]
    # Solution.stone_game_ii(piles) |> IO.inspect()

    # piles = [2, 7, 9, 10]
    # Solution.stone_game_ii(piles) |> IO.inspect()

    # piles = 1..10
    # Solution.stone_game_ii(piles) |> IO.inspect()

    piles = [1,2,3,4,5,6,7,20,9,10]
    Solution.stone_game_ii(piles) |> IO.inspect()
  end

  def clock do
    piles = 1..25
    :timer.tc(Solution, :stone_game_ii, [piles]) |> IO.inspect()
  end
end

# @lc code=end
