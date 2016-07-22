module Update exposing (..)

import Model exposing (..)
import Model.Page exposing (..)
import Model.Aspect exposing (..)
import Msg exposing (..)

import Debug exposing (log)

update : Msg -> Model -> (Model, Cmd Msg)
update action ({activities,aspects,currentPage} as model) =
  case action of

    Check aspect option ->
      let
          option' = { option | checked = (not option.checked)}
          options' = listReplace option option' aspect.options
          aspect' = { aspect | options = options' }
          aspects' = replaceAspect aspect aspect' aspects
          model' = { model | aspects = aspects'
                           , currentPage = AspectPage aspect' }
      in
          (model', Cmd.none)

    Navigate page ->
      let
          model' = { model | currentPage = page }
      in
          (model', Cmd.none)


listReplace : a -> a -> List a -> List a
listReplace xOld xNew xs =
  xs |> List.map (\x -> if x == xOld then xNew else x)


replaceAspect : Aspect -> Aspect -> List Aspect -> List Aspect
replaceAspect old new aspects =
  aspects
  |> List.map (\c -> if c.name == old.name then new else c)
