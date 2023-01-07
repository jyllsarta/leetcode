#
# @lc app=leetcode id=17 lang=elixir
#
# [17] Letter Combinations of a Phone Number
#

# @lc code=start
defmodule Solution do
  @spec letter_combinations(digits :: String.t()) :: [String.t()]

  @digits_to_letter %{
    2 => 'abc',
    3 => 'def',
    4 => 'ghi',
    5 => 'jkl',
    6 => 'mno',
    7 => 'pqrs',
    8 => 'tuv',
    9 => 'wxyz'
  }

  def letter_combinations("") do
    []
  end

  def letter_combinations(digits) do
    [first_digit | rest] = digits |> String.to_integer() |> Integer.digits()
    combinations = Map.fetch!(@digits_to_letter, first_digit) |> Enum.map(&List.wrap/1)
    calculate(combinations, rest)
  end

  def calculate(combinations, []) do
    combinations |> Enum.map(&(Enum.reverse(&1) |> List.to_string()))
  end

  def calculate(combinations, [digit | rest]) do
    chars = Map.fetch!(@digits_to_letter, digit)
    cateneted = Enum.flat_map(chars, &add(combinations, &1))
    calculate(cateneted, rest)
  end

  def add(combinations, char) do
    Enum.map(combinations, &[char | &1])
  end
end

defmodule Test do
  def test do
    Solution.letter_combinations("") |> IO.inspect()
    Solution.letter_combinations("2") |> IO.inspect()
    Solution.letter_combinations("23") |> IO.inspect()
    Solution.letter_combinations("44") |> IO.inspect()
  end

  def clock do
    :timer.tc(Solution, :letter_combinations, ["2345"])
  end
end

# @lc code=end
