module View exposing (view)

import Html exposing (Html,h2,div,ul,li,button)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class,classList,disabled)

import Model exposing (..)
import Model.Page exposing (..)
import Model.Criterion exposing (..)
import Msg exposing (..)


view : Model -> Html Msg
view ({criteria,currentPage} as model) =
  let
      matches = matchingActivities model
      pageContents =
        case currentPage of
          CriterionPage criterion ->
            [ h2 [] [ Html.text criterion.name ]
            , renderOptions criterion
            , renderResultsCount (List.length matches)
            , renderNavbuttons model
            ]
          SearchResultsPage ->
            [ h2 [] [ Html.text "Ergebnisse" ]
            , renderSearchResults matches
            , renderNavbuttons model
            ]
  in
      div [] pageContents


renderOptions : Criterion -> Html Msg
renderOptions criterion =
  criterion.options
  |> List.map (renderOption criterion)
  |> Html.ul [ class "option-list" ]


renderOption : Criterion -> Option -> Html Msg
renderOption criterion option =
  li
    []
    [ button
      [ classList [ ("optionbutton", True), ("checked", option.checked) ]
      , onClick (Check criterion option)
      ]
      [ Html.text option.name ]
    ]


renderResultsCount : Int -> Html Msg
renderResultsCount n =
  let
      message = (toString n) ++ " Suchergebnisse"
  in
      div
        []
        [ Html.text message ]


renderNavbuttons : Model -> Html Msg
renderNavbuttons {criteria,currentPage} =
  div
    []
    [ renderNavbutton "Zurück" (previousPage criteria currentPage)
    , renderNavbutton "Weiter" (nextPage criteria currentPage)
    ]


renderNavbutton : String -> Maybe Page -> Html Msg
renderNavbutton buttonText targetPage =
  let
      content = [ Html.text buttonText ]
  in
      case targetPage of
        Nothing ->
          button
            [ disabled True ]
            content

        Just page ->
          button
            [ onClick (Navigate page) ]
            content


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
