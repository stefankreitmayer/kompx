module Model exposing (..)

import Model.Page exposing (..)
import Model.Aspect exposing (..)
import Helpers exposing (..)


type alias Model =
  { activities : List Activity
  , aspects : List Aspect
  , currentPage : Page }

type alias Activity =
  { title : String
  , summary : String
  , published : Bool
  , sections : List String
  , annotations : List String }


initialModel : Model
initialModel =
  let
      activities = []
      aspects = []
      firstPage = allPages aspects |> List.head
  in
      { activities = activities
      , aspects = aspects
      , currentPage =
          case firstPage of
            Nothing -> SearchResultsPage
            Just page -> page
      }


matchingActivities : Model -> List Activity
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
