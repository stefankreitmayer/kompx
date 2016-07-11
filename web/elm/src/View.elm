module View exposing (view)

import Html exposing (Html,h2,div,ul,li,button)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class,classList,disabled)

import Model exposing (..)
import Subscription exposing (..)


view : Model -> Html Msg
view ({filters,currentPage} as model) =
  let
      pageContents =
        case currentPage of
          FilterPage ->
            [ h2 [] [ Html.text "Kategorien wählen" ]
            , renderFilters filters
            , renderResultsCount (List.length model.filteredActivities)
            , renderForwardNavbutton model
            ]
          Serp ->
            [ h2 [] [ Html.text "Aufgabe wählen" ]
            , renderSearchResults model.filteredActivities
            , renderBackNavbutton model
            ]
  in
      div [] pageContents


renderFilters : List Filter -> Html Msg
renderFilters filters =
  filters
  |> List.map renderFilter
  |> Html.ul [ class "filter-list" ]


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


renderBackNavbutton : Model -> Html Msg
renderBackNavbutton model =
  button
    [ disabled (not (backNavbuttonEnabled model))
    , onClick (Navigate FilterPage) ]
    [ Html.text "Zurück" ]


renderForwardNavbutton : Model -> Html Msg
renderForwardNavbutton model =
  button
    [ disabled (not (forwardNavbuttonEnabled model))
    , onClick (Navigate Serp) ]
    [ Html.text "Weiter" ]


backNavbuttonEnabled : Model -> Bool
backNavbuttonEnabled model =
  model.currentPage == Serp


forwardNavbuttonEnabled : Model -> Bool
forwardNavbuttonEnabled model =
  List.length model.filteredActivities > 0


renderSearchResults : List Activity -> Html Msg
renderSearchResults activities =
  activities
  |> List.map renderSearchResult
  |> Html.ul [ class "search-results-list" ]


renderSearchResult : Activity -> Html Msg
renderSearchResult activity =
  li
    []
    [ div
      [ class "search-result"
      ]
      [ Html.text activity.title ]
    ]
