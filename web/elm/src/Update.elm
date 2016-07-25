module Update exposing (..)

import Model exposing (..)
import Model.Page exposing (..)
import Model.Frame.Activity exposing (..)
import Model.Frame.Aspect exposing (..)
import Msg exposing (..)

import Debug exposing (log)

update : Msg -> Model -> (Model, Cmd Msg)
update action ({frame,currentPage} as model) =
  let
      activities = frame.activities
      aspects = frame.aspects
  in
      case action of

        Check aspect option ->
          let
              option' = { option | checked = (not option.checked)}
              options' = listReplace option option' aspect.options
              aspect' = { aspect | options = options' }
              aspects' = replaceAspect aspect aspect' aspects
              frame' = { frame | aspects = aspects' }
              model' = { model | frame = frame'
                               , currentPage = AspectPage aspect' }
          in
              (model', Cmd.none)

        Navigate page ->
          let
              model' = { model | currentPage = page }
          in
              (model', Cmd.none)

        ChooseActivity activity ->
          let
              model' = { model | chosenActivity = Just activity
                               , currentPage = ChosenActivityPage }
          in
              (model', Cmd.none)

        ToggleHelp ->
          let
              helpVisible = not model.helpVisible
              model' = { model | helpVisible = helpVisible }
          in
              (model', Cmd.none)

        FetchSuccess frame ->
          let
              model' = buildModel frame ConnectionOK
          in
              (model', Cmd.none)

        FetchFailure httpError ->
          let
              connectionStatus =
                ConnectionError ("Connection Error! "++(toString httpError))
              model' = emptyModel connectionStatus
          in
              (model', Cmd.none)


listReplace : a -> a -> List a -> List a
listReplace xOld xNew xs =
  xs |> List.map (\x -> if x == xOld then xNew else x)


replaceAspect : Aspect -> Aspect -> List Aspect -> List Aspect
replaceAspect old new aspects =
  aspects
  |> List.map (\c -> if c.name == old.name then new else c)
