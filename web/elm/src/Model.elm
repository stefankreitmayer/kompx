module Model exposing (..)

import Model.Page exposing (..)
import Model.Criterion exposing (..)
import Helpers exposing (..)


type alias Model =
  { activities : List Activity
  , criteria : List Criterion
  , currentPage : Page }

type alias Activity =
  { title : String
  , tags : List String }


initialModel : Model
initialModel =
  let
      activities = dummyActivities
      criteria = dummyCriteria
      firstPage = allPages criteria |> List.head
  in
      { activities = activities
      , criteria = criteria
      , currentPage =
          case firstPage of
            Nothing -> SearchResultsPage
            Just page -> page
      }


dummyActivities : List Activity
dummyActivities =
  [ { title = "Drink coffee", tags = ["At Home", "At Work", "Morning", "Afternoon"] }
  , { title = "Have lunch", tags = ["At Home", "At Work", "Lunchtime"] }
  , { title = "Sleep", tags = ["At Home", "Night"] }
  , { title = "Run", tags = ["At Home", "Morning", "Afternoon", "Evening"] }
  ]


dummyCriteria : List Criterion
dummyCriteria =
  let
      dummies = [ ("Time", ["Morning", "Lunchtime", "Afternoon", "Night"])
                , ("Place", ["At Home", "At Work"])
                ]
      tagsToOptions = List.map (\t -> Option t False)
      createCriterion name tags = Criterion name (tagsToOptions tags)
  in
      dummies
      |> List.map (\(name,tags) -> createCriterion name tags)


matchingActivities : Model -> List Activity
matchingActivities {criteria,activities} =
  activities
  |> List.filter (doesTheActivityMatchAllCriteria criteria)


doesTheActivityMatchAllCriteria : List Criterion -> Activity -> Bool
doesTheActivityMatchAllCriteria criteria activity =
  criteria
  |> List.all (doesTheActivityMatchTheCriterion activity)


doesTheActivityMatchTheCriterion : Activity -> Criterion -> Bool
doesTheActivityMatchTheCriterion activity {options} =
  let
      checkedOptions = options |> List.filter (\o -> o.checked)
  in
      List.isEmpty checkedOptions ||
      List.any (doesTheActivityMatchTheOption activity) checkedOptions


doesTheActivityMatchTheOption : Activity -> Option -> Bool
doesTheActivityMatchTheOption activity option =
  List.member option.name activity.tags
