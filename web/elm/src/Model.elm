module Model exposing (..)

import Model.Frame exposing (..)
import Model.Frame.Activity exposing (..)
import Model.Frame.Aspect exposing (..)
import Model.Page exposing (..)

import Helpers exposing (..)


type alias Model =
  { frame : Frame
  , currentPage : Page }


emptyModel : Model
emptyModel =
  buildModel emptyFrame


buildModel : Frame -> Model
buildModel kb =
  { frame = kb
  , currentPage = firstPage kb
  }


matchingActivities : Frame -> List Activity
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
  List.member option.tagId activity.tagIds


firstPage : Frame -> Page
firstPage {aspects} =
  let
      head = allPages aspects |> List.head
  in
      case head of
        Nothing ->
          SearchResultsPage

        Just page ->
          page
