module Update exposing (..)

import Model exposing (..)
import Subscription exposing (..)


update : Msg -> Model -> (Model, Cmd Msg)
update action ({activities,filters} as model) =
  case action of

    NoOp ->
      (model, Cmd.none)

    Check filter ->
      let
          filters' = toggleFilter filter filters
          checkedFilters = filters' |> List.filter (\f -> f.checked)
          filteredActivities' = activities |> applyFilters checkedFilters
      in
          ({ model | filters = filters'
                   , filteredActivities = filteredActivities' }
           , Cmd.none)


toggleFilter : Filter -> List Filter -> List Filter
toggleFilter filter filters =
  filters
  |> List.map (\fil -> if fil.tag == filter.tag then (toggled fil) else fil)


toggled : Filter -> Filter
toggled filter =
  { filter | checked = (not filter.checked)}


applyFilters : List Filter -> List Activity -> List Activity
applyFilters filters activities =
  List.filter (matchesAnyFilter filters) activities


matchesAnyFilter : List Filter -> Activity -> Bool
matchesAnyFilter filters activity =
  case filters of
    [] ->
      False
    hd::tl ->
      if matchesFilter hd activity then
         True
      else
         matchesAnyFilter tl activity


matchesFilter : Filter -> Activity -> Bool
matchesFilter filter activity =
  List.member filter.tag activity.tags
