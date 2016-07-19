module Update exposing (..)

import Model exposing (..)
import Model.Page exposing (..)
import Model.Criterion exposing (..)
import Msg exposing (..)

import Debug exposing (log)

update : Msg -> Model -> (Model, Cmd Msg)
update action ({activities,criteria,currentPage} as model) =
  case action of

    Check criterion option ->
      let
          option' = { option | checked = (not option.checked)}
          options' = listReplace option option' criterion.options
          criterion' = { criterion | options = options' }
          criteria' = replaceCriterion criterion criterion' criteria
          model' = { model | criteria = criteria'
                           , currentPage = CriterionPage criterion' }
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


replaceCriterion : Criterion -> Criterion -> List Criterion -> List Criterion
replaceCriterion old new criteria =
  criteria
  |> List.map (\c -> if c.name == old.name then new else c)
