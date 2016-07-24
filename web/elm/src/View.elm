module View exposing (view)

import Html exposing (Html,h2,div,ul,li,button)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class,classList,disabled,id,property)
import Json.Encode

import Model exposing (..)
import Model.Page exposing (..)
import Model.Frame.Activity exposing (..)
import Model.Frame.Aspect exposing (..)
import Msg exposing (..)


view : Model -> Html Msg
view ({frame,currentPage} as model) =
  let
      matches = matchingActivities frame
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
            , renderResultsCount (List.length matches)
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
renderPageNav ({frame,currentPage} as model) =
  div
    [ id "elm-footer" ]
    [ renderNavbutton "Zurück" (previousPage frame.aspects currentPage)
    , renderPageNumber model
    , renderNavbutton "Weiter" (nextPage frame.aspects currentPage)
    ]


renderPageNumber : Model -> Html Msg
renderPageNumber ({frame} as model) =
  let
      pages = allPages frame.aspects
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
  let
      title = Html.h3 [] [ Html.text activity.title ]
      summary = Html.p [] [ Html.text activity.summary ]
      sections = List.map renderSection activity.sections
      sectionsContainer = Html.div [] sections
      hr = Html.hr [] []
  in
      li
        []
        [ div
          [ class "elm-search-result" ]
          [ title, summary, sectionsContainer, hr ]
        ]


renderSection : Section -> Html Msg
renderSection section =
  let
      title = Html.h4 [] [ Html.text section.title ]
      body =
        Html.span
          [ property "innerHTML" (Json.Encode.string section.body) ]
          []
  in
      Html.div [] [ title, body ]
