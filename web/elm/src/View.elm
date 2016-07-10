module View exposing (view)

import Html exposing (Html,h2,div,ul,li,input)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class,classList)

import Model exposing (..)
import Subscription exposing (..)


view : Model -> Html Msg
view ({filters} as model) =
  div
    []
    [ h2 [] [ Html.text "Kategorien auswählen" ]
    , renderFilters filters
    , renderResultsCount (List.length model.filteredActivities)
    ]


renderFilters : List Filter -> Html Msg
renderFilters filters =
  filters
  |> List.map renderFilter
  |> Html.ul [ class "filterlist" ]


renderFilter : Filter -> Html Msg
renderFilter filter =
  li
    []
    [ div
      [ classList [ ("filterbutton", True), ("checked", filter.checked) ]
      , onClick (Check filter)
      ]
      [ Html.text filter.tag ]
    ]


renderResultsCount : Int -> Html Msg
renderResultsCount n =
  let
      message = (toString n) ++ " Suchergebnisse"
  in
      div
        []
        [ Html.text message ]
