module Update exposing (..)

import Model exposing (..)
import Subscription exposing (..)


update : Msg -> Model -> (Model, Cmd Msg)
update action ({filters} as model) =
  case action of
    NoOp ->
      (model, Cmd.none)
    Check filter ->
      let
          filters' = toggleFilter filter filters
      in
          ({ model | filters = filters' }, Cmd.none)


toggleFilter : Filter -> List Filter -> List Filter
toggleFilter filter filters =
  filters
  |> List.map (\fil -> if fil==filter then (toggled fil) else fil)


toggled : Filter -> Filter
toggled filter =
  { filter | checked = (not filter.checked)}
