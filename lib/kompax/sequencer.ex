defmodule Kompax.Sequencer do

  # takes models that each have a position field
  # and the id of a model that should be moved lower in the list
  def lower(models, id) do
    Enum.sort(models, &(&1.position < &2.position))
    |> Enum.with_index
    |> Enum.map(fn({model, i}) -> {model, (if to_string(model.id)==to_string(id), do: i-1.5, else: i)} end)
    |> Enum.sort(fn({_, new_pos_a}, {_, new_pos_b}) -> new_pos_a < new_pos_b end)
    |> Enum.map(fn({model, _}) -> model end)
    |> Enum.with_index
  end
end
