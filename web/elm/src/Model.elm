module Model exposing (..)


type alias Model =
  { activities : List Activity
  , filters : List Filter }

type alias Activity =
  { title : String
  , tags : List String }

type alias Filter =
  { text : String
  , checked : Bool }


initialModel : Model
initialModel =
  let
      activities = dummyActivities
  in
      { activities = activities
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
      |> removeDuplicates
  in
      List.map (\tag -> Filter tag False) uniqueTagStrings


removeDuplicates : List a -> List a
removeDuplicates xs =
  case xs of
    [] -> []
    hd::tl ->
      if List.member hd tl then
        removeDuplicates tl
      else
        hd :: (removeDuplicates tl)
