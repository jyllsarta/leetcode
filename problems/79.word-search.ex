#
# @lc app=leetcode id=79 lang=elixir
#
# [79] Word Search
#

# @lc code=start
defmodule Solution do
  @moduledoc """
  cbaba
  aabab
  から
  ababababc を探すみたいなケースがめちゃくちゃだるい

  とっかかりになる a がたくさんあるし、abab ... 地帯のグネグネパターンがめっちゃある
  ぐねぐねが本当にめっちゃあるかどうかは知らん
  ないのか？もしや... 自分にぶつかるのが禁止なので、6*6の空間内ではじつは辿れる道筋がいい感じに制限され続けて発散しない？
  ないと信じて素朴に解いてみます

  ぬああ惜しい！1文字だけパターンを通さなきゃいけないか
  """
  @spec exist(board :: [[char]], word :: String.t()) :: boolean
  def exist(board, word) do
    h = Enum.count(board)
    w = board |> Enum.at(0) |> Enum.count()

    word = String.to_charlist(word)
    first_letter = Enum.at(word, 0)
    start_position_candidates = find_start_position(board, first_letter)
    Enum.any?(start_position_candidates, &run(&1, board, {w, h}, [], word))
  end

  # 最後の一文字も消化し終わることができたら探索成功
  def run(_current, _board, _board_size, _route, []), do: true

  # ボードの外に出ることはできない
  def run({x, _y}, _board, {_w, _h}, _route, _rest_word) when x < 0, do: false
  def run({_x, y}, _board, {_w, _h}, _route, _rest_word) when y < 0, do: false
  def run({x, _y}, _board, {w, _h}, _route, _rest_word) when x >= w, do: false
  def run({_x, y}, _board, {_w, h}, _route, _rest_word) when y >= h, do: false

  # 文字が残っていたら上下左右に移動してみる
  def run({x, y}, board, board_size, route, [char | rest_word]) do
    current_char = board |> Enum.at(y) |> Enum.at(x)

    cond do
      # 今踏んでいる文字が間違っていたら諦める
      current_char != char -> false
      # 自分の足跡にぶつかってしまったら諦める
      {x, y} in route -> false
      # それ以外の場合はここまでのルートはあってるので、次の文字の探索をする
      true -> do_run({x, y}, board, board_size, route, [char | rest_word])
    end
  end

  def do_run({x, y}, board, board_size, route, [_char | rest_word]) do
    new_route = [{x, y} | route]
    up = run({x, y - 1}, board, board_size, new_route, rest_word)
    down = run({x, y + 1}, board, board_size, new_route, rest_word)
    left = run({x - 1, y}, board, board_size, new_route, rest_word)
    right = run({x + 1, y}, board, board_size, new_route, rest_word)
    Enum.any?([up, down, left, right])
  end

  def find_start_position(board, first_letter) do
    for {word, y} <- Enum.with_index(board),
        {letter, x} <- Enum.with_index(word),
        letter == first_letter do
      {x, y}
    end
  end
end

defmodule Test do
  def test do
    board = [
      'abce',
      'sfcs',
      'adee'
    ]

    IO.inspect("-----truthy case-----")
    Solution.exist(board, "abf") |> IO.inspect()
    Solution.exist(board, "see") |> IO.inspect()
    Solution.exist(board, "abcced") |> IO.inspect()
    IO.inspect("-----falsey case-----")
    Solution.exist(board, "abceed") |> IO.inspect()
    Solution.exist(board, "abcb") |> IO.inspect()

    board = [
      'cbaba',
      'aabab'
    ]

    IO.inspect("-----truthy case-----")
    Solution.exist(board, "ababababc") |> IO.inspect()
    IO.inspect("-----falsey case-----")
    Solution.exist(board, "ababababa") |> IO.inspect()

    board = [
      'a',
    ]

    IO.inspect("-----truthy case-----")
    Solution.exist(board, "a") |> IO.inspect()
    IO.inspect("-----falsey case-----")
    Solution.exist(board, "b") |> IO.inspect()
  end
end

# @lc code=end
