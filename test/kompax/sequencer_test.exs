defmodule SequencerTest do
  use ExUnit.Case, async: true

  alias Kompax.Sequencer

  defp dummies do
    a = %{id: 100, position: 10}
    b = %{id: 200, position: 11}
    c = %{id: 300, position: 12}
    { a, b, c }
  end

  defp output_position(results, input_item) do
    {_, pos} = Enum.find(results, fn({item, _}) -> item==input_item end)
    pos
  end

  test "empty list returns itself" do
    assert Sequencer.lower([], 0) == []
  end

  test "new positions start from zero" do
    model = %{id: 123, position: 5555}
    assert Sequencer.lower([model], model.id) == [{model, 0}]
  end

  test "reverse the order of two items" do
    a = %{id: 111, position: 9}
    b = %{id: 222, position: 5}
    output = Sequencer.lower([a, b], a.id)
    assert(Enum.any?(output, fn({par, pos}) -> par==a && pos==0 end))
    assert(Enum.any?(output, fn({par, pos}) -> par==b && pos==1 end))
  end

  test "changing the first item has no effect on the sequence" do
    {a, b, c} = dummies
    output = Sequencer.lower([a, b, c], a.id)
    assert output_position(output, a) == 0
    assert output_position(output, b) == 1
    assert output_position(output, c) == 2
  end

  test "changing the second item swaps it with the first" do
    {a, b, c} = dummies
    output = Sequencer.lower([a, b, c], b.id)
    assert output_position(output, a) == 1
    assert output_position(output, b) == 0
    assert output_position(output, c) == 2
  end

  test "changing the last item swaps it with the next-to-last" do
    {a, b, c} = dummies
    output = Sequencer.lower([a, b, c], c.id)
    assert output_position(output, a) == 0
    assert output_position(output, b) == 2
    assert output_position(output, c) == 1
  end

  test "input list order doesn't matter" do
    {a, b, c} = dummies
    assert Sequencer.lower([a, b, c], c.id) == Sequencer.lower([c, a, b], c.id)
  end
end
