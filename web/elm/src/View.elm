module View exposing (view)

import Html exposing (Html,h2,div,ul,li,button)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class,classList,disabled,id)

import Model exposing (..)
import Model.Page exposing (..)
import Model.Aspect exposing (..)
import Msg exposing (..)


view : Model -> Html Msg
view ({aspects,currentPage} as model) =
  let
      matches = matchingActivities model
      pageContents =
        case currentPage of
          AspectPage aspect ->
            [ h2 [] [ Html.text aspect.name ]
            , renderOptions aspect
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


renderOptions : Aspect -> Html Msg
renderOptions aspect =
  aspect.options
  |> List.map (renderOption aspect)
  |> Html.ul [ class "elm-options" ]


renderOption : Aspect -> Option -> Html Msg
renderOption aspect option =
  li
    []
    [ button
      [ classList [ ("elm-optionbutton", True), ("elm-checked", option.checked) ]
      , onClick (Check aspect option)
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
renderPageNav ({aspects,currentPage} as model) =
  div
    [ id "elm-footer" ]
    [ renderNavbutton "Zurück" (previousPage aspects currentPage)
    , renderPageNumber model
    , renderNavbutton "Weiter" (nextPage aspects currentPage)
    ]


renderPageNumber : Model -> Html Msg
renderPageNumber model =
  let
      pages = allPages model.aspects
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
