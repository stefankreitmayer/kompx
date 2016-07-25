module View exposing (view)

import Html exposing (Html,h2,div,ul,li,button)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class,classList,id,property,attribute)
import Json.Encode

import Model exposing (..)
import Model.Page exposing (..)
import Model.Frame.Activity exposing (..)
import Model.Frame.Aspect exposing (..)
import Msg exposing (..)


view : Model -> Html Msg
view ({connectionStatus} as model) =
  let
      content = case connectionStatus of
                    Connecting ->
                      renderUserMessage "Connecting..."

                    ConnectionOK ->
                      renderPage model

                    ConnectionError message ->
                      renderUserMessage message
  in
      div [ id "elm-main"] [ content ]


renderUserMessage : String -> Html Msg
renderUserMessage message =
  div
    [ class "elm-user-message" ]
    [ Html.text message ]


renderPage : Model -> Html Msg
renderPage ({frame,currentPage,chosenActivity} as model) =
  let
      matches = matchingActivities frame
      resultsCount = renderResultsCount (List.length matches)
      nav = renderPageNav model
      pageContent =
        case currentPage of
          AspectPage aspect ->
            [ resultsCount
            , nav
            , renderHelp model
            , h2 [] [ Html.text aspect.name ]
            , renderOptions aspect
            ]
          SearchResultsPage ->
            [ resultsCount
            , nav
            , renderHelp model
            -- , h2 [] [ Html.text "Passende Aufgaben" ]
            , renderSearchResults matches
            ]
          ChosenActivityPage ->
            [ renderChosenActivityTitle chosenActivity
            , nav
            , renderHelp model
            , renderChosenActivity chosenActivity
            ]
  in
      div [] pageContent


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
      message = (toString n) ++ " passende gefunden"
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
  let
      prev = previousPage frame.aspects currentPage
      next = nextPage frame.aspects currentPage
      rightButton = if isChosenActivityPage next then
                       div [] []
                    else
                      renderNavbutton "right" next
      leftButton = renderNavbutton "left" prev
  in
      div
        [ id "elm-header" ]
        [ leftButton
        , renderPageNumber model
        , renderHelpButton
        , rightButton
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
renderNavbutton direction targetPage =
  let
      classString = "glyphicon glyphicon-chevron-"++direction
  in
      case targetPage of
        Nothing ->
          button
            [ class (classString++" hidden") ]
            []

        Just page ->
          button
            [ class classString
            , onClick (Navigate page) ]
            []


renderSearchResults : List Activity -> Html Msg
renderSearchResults activities =
  activities
  |> List.map renderSearchResult
  |> Html.ul [ class "elm-search-results" ]


renderSearchResult : Activity -> Html Msg
renderSearchResult activity =
  let
      heading = div [ class "panel-heading" ] [ Html.text activity.title ]
      summary = div [ class "panel-body" ] [ Html.text activity.summary ]
      panel = div
                [ class "panel panel-default aspect-panel elm-search-result"
                , onClick (ChooseActivity activity) ]
                [ heading, summary ]
  in
      li
        []
        [ panel ]


renderChosenActivityTitle : Maybe Activity -> Html Msg
renderChosenActivityTitle activity =
  case activity of
    Nothing ->
      Html.text "Ein Fehler ist aufgetreten"

    Just activity ->
      div
        [ id "elm-results-preview"
        , Html.Attributes.style [ ("background", "#49b") ] ]
        [ Html.text activity.title ]


renderChosenActivity : Maybe Activity -> Html Msg
renderChosenActivity activity =
  case activity of
    Nothing ->
      div [] []

    Just activity ->
      let
          sections = List.map renderSection activity.sections
          sectionsContainer = Html.div [ class "elm-chosen-activity" ] sections
      in
          sectionsContainer


renderSection : Section -> Html Msg
renderSection section =
  let
      title = Html.h3 [] [ Html.text section.title ]
      body =
        Html.span
          [ property "innerHTML" (Json.Encode.string section.body) ]
          []
  in
      Html.div [] [ title, body ]


renderHelpButton : Html Msg
renderHelpButton =
  button
    [ onClick ToggleHelp
    , class "glyphicon glyphicon-question-sign elm-help-button" ]
    []


renderHelp : Model -> Html Msg
renderHelp model =
  let
      anyMatches = matchingActivities model.frame |> List.isEmpty |> not
      enabled = if model.helpVisible then " visible" else ""
      classString = "alert alert-info elm-help" ++ enabled
      message =
        case model.currentPage of
          AspectPage _ ->
            "Mehrfach-Auswahl = \"oder\""

          SearchResultsPage ->
            if anyMatches then
              "Bitte eine Aufgabe auswählen"
            else
              "Bitte Suchkriterien erweitern"

          ChosenActivityPage ->
            "Detailansicht. Zurück mit <"
  in
      div
        [ class classString ]
        [ Html.text message ]
