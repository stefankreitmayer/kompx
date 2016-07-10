module Model exposing (..)

import Helpers exposing (..)

type alias Model =
  { activities : List Activity
  , filteredActivities : List Activity
  , filters : List Filter }

type alias Activity =
  { title : String
  , tags : List String }

type alias Filter =
  { tag : String
  , checked : Bool }


initialModel : Model
initialModel =
  let
      activities = dummyActivities
  in
      { activities = activities
      , filteredActivities = []
      , filters = createFilters activities }


dummyActivities : List Activity
dummyActivities =
  [ { title = "Schnipsel", tags = ["Common", "ST1", "ST2"] }
  , { title = "Wegemusik", tags = ["Common", "WT"] }
  ]


createFilters : List Activity -> List Filter
createFilters activities =
  let
      uniqueTagStrings = activities
      |> List.map (\activity -> activity.tags)
      |> List.concat
      |> dropDuplicates
  in
      List.map (\tag -> Filter tag False) uniqueTagStrings
