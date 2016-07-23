module Model exposing (..)

import Model.Knowledgebase exposing (..)
import Model.Knowledgebase.Activity exposing (..)
import Model.Knowledgebase.Aspect exposing (..)
import Model.Page exposing (..)

import Helpers exposing (..)


type alias Model =
  { knowledgebase : Knowledgebase
  , currentPage : Page }


emptyModel : Model
emptyModel =
  buildModel emptyKnowledgebase


buildModel : Knowledgebase -> Model
buildModel kb =
  { knowledgebase = kb
  , currentPage = firstPage kb
  }


matchingActivities : Knowledgebase -> List Activity
matchingActivities {aspects,activities} =
  activities
  |> List.filter (doesTheActivityMatchAllAspects aspects)


doesTheActivityMatchAllAspects : List Aspect -> Activity -> Bool
doesTheActivityMatchAllAspects aspects activity =
  aspects
  |> List.all (doesTheActivityMatchTheAspect activity)


doesTheActivityMatchTheAspect : Activity -> Aspect -> Bool
doesTheActivityMatchTheAspect activity {options} =
  let
      checkedOptions = options |> List.filter (\o -> o.checked)
  in
      List.isEmpty checkedOptions ||
      List.any (doesTheActivityMatchTheOption activity) checkedOptions


doesTheActivityMatchTheOption : Activity -> Option -> Bool
doesTheActivityMatchTheOption activity option =
  List.member option.name activity.annotations


firstPage : Knowledgebase -> Page
firstPage {aspects} =
  let
      head = allPages aspects |> List.head
  in
      case head of
        Nothing ->
          SearchResultsPage

        Just page ->
          page
