module View exposing (view)

import Html exposing (Html,div,ul,li)

import Model exposing (..)
import Subscription exposing (..)


view : Model -> Html Msg
view {filters} =
  renderFilters filters


renderFilters : List Filter -> Html Msg
renderFilters filters =
  filters
  |> List.map renderFilter
  |> Html.ul []


renderFilter : Filter -> Html Msg
renderFilter filter =
  li
    []
    [ div
      []
      [ Html.text filter.text ]
    ]
