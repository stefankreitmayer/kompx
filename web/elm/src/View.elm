module View exposing (view)

import Html exposing (Html,h2,div,ul,li,button)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class,classList,disabled,id)

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
            , renderPageNav model
            ]
          SearchResultsPage ->
            [ h2 [] [ Html.text "Ergebnisse" ]
            , renderSearchResults matches
            , renderPageNav model
            ]
  in
      div [ id "elm-main"] pageContents


renderOptions : Criterion -> Html Msg
renderOptions criterion =
  criterion.options
  |> List.map (renderOption criterion)
  |> Html.ul [ class "elm-options" ]


renderOption : Criterion -> Option -> Html Msg
renderOption criterion option =
  li
    []
    [ button
      [ classList [ ("elm-optionbutton", True), ("elm-checked", option.checked) ]
      , onClick (Check criterion option)
      ]
      [ Html.text option.name ]
    ]


renderResultsCount : Int -> Html Msg
renderResultsCount n =
  let
      message = (toString n) ++ " Treffer"
      color = if n>3 then
                  "#eb5"
              else if n>0 then
                  "#5e5"
              else
                  "#a55"
  in
      div
        [ id "elm-results-preview"
        , Html.Attributes.style [ ("background", color) ] ]
        [ Html.text message ]


renderPageNav : Model -> Html Msg
renderPageNav ({criteria,currentPage} as model) =
  div
    [ id "elm-footer" ]
    [ renderNavbutton "Zurück" (previousPage criteria currentPage)
    , renderPageNumber model
    , renderNavbutton "Weiter" (nextPage criteria currentPage)
    ]


renderPageNumber : Model -> Html Msg
renderPageNumber model =
  let
      pages = allPages model.criteria
      pageCount = pages|> List.length |> toString
      pageNumber = pageIndex model.currentPage pages 1 |> toString
  in
      div
        [ id "elm-page-number" ]
        [ Html.p [] [ Html.text (pageNumber ++ " / " ++ pageCount) ] ]


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
  |> Html.ul [ class "elm-search-results" ]


renderSearchResult : Activity -> Html Msg
renderSearchResult activity =
  li
    []
    [ div
      [ class "elm-search-result"
      ]
      [ Html.text activity.title ]
    ]
