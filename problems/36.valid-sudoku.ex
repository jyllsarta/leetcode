#
# @lc app=leetcode id=36 lang=elixir
#
# [36] Valid Sudoku
#

# @lc code=start
defmodule Solution do
  @blank_value ?.

  @spec is_valid_sudoku(board :: [[char]]) :: boolean
  def is_valid_sudoku(board) do
    validate_rows(board) && validate_columns(board) && validate_boxes(board)
  end

  def validate_rows(board) do
    board |> Enum.all?(&validate/1)
  end

  def validate_columns(board) do
    transposed =
      board
      |> Enum.map(&Enum.with_index/1)
      |> List.flatten()
      |> Enum.group_by(&elem(&1, 1), &elem(&1, 0))
      |> Map.values()

    transposed |> Enum.all?(&validate/1)
  end

  def validate_boxes(board) do
    boxes =
      for {row, index} <- Enum.with_index(board), into: [] do
        col_offset = div(index, 3) * 3

        Enum.chunk_every(row, 3)
        |> Enum.with_index()
        |> Enum.map(&{col_offset + elem(&1, 1), elem(&1, 0)})
      end

    boxes
    |> List.flatten()
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
    |> Enum.map(&List.flatten(elem(&1, 1)))
    |> Enum.all?(&validate/1)
  end

  def validate(numbers) do
    numbers
    |> Enum.filter(&(&1 != @blank_value))
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.all?(&(&1 == 1))
  end
end

defmodule Test do
  def test() do
    # もうこれが完全嘘 typespecが正しい 変だとは思ったんだ
    # Input: board = 
    # [["5","3",".",".","7",".",".",".","."]
    # ,["6",".",".","1","9","5",".",".","."]
    # ,[".","9","8",".",".",".",".","6","."]
    # ,["8",".",".",".","6",".",".",".","3"]
    # ,["4",".",".","8",".","3",".",".","1"]
    # ,["7",".",".",".","2",".",".",".","6"]
    # ,[".","6",".",".",".",".","2","8","."]
    # ,[".",".",".","4","1","9",".",".","5"]
    # ,[".",".",".",".","8",".",".","7","9"]]
    # Output: true
    board = [
      '53..7....',
      '6..195...',
      '.98....6.',
      '8...6...3',
      '4..8.3..1',
      '7...2...6',
      '.6....28.',
      '...419..5',
      '....8..79'
    ]

    Solution.is_valid_sudoku(board) |> IO.inspect()

    board = [
      '83..7....',
      '6..195...',
      '.98....6.',
      '8...6...3',
      '4..8.3..1',
      '7...2...6',
      '.6....28.',
      '...419..5',
      '....8..79'
    ]

    Solution.is_valid_sudoku(board) |> IO.inspect()

    board = [
      '53..7....',
      '6..195...',
      '.98....6.',
      '8...6...3',
      '4..1.3..1',
      '7...2...6',
      '.6....28.',
      '...419..5',
      '....8..79'
    ]

    Solution.is_valid_sudoku(board) |> IO.inspect()

    board = [
      '53..7....',
      '6..195...',
      '.98....6.',
      '8...6...3',
      '4..8.3..1',
      '7...2...6',
      '.6....28.',
      '...419..5',
      '....8..71'
    ]

    Solution.is_valid_sudoku(board) |> IO.inspect()

    # 正しいやつ
    board = [
      '658921347',
      '914753826',
      '237846951',
      '192478635',
      '865132479',
      '743695218',
      '579364182',
      '386217594',
      '421589763'
    ]

    Solution.is_valid_sudoku(board) |> IO.inspect()
  end
end

# @lc code=end
