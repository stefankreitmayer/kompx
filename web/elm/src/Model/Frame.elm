module Model.Frame exposing (..)

import Model.Frame.Aspect exposing (..)
import Model.Frame.Activity exposing (..)

type alias Frame =
  { activities : List Activity
  , aspects : List Aspect }


emptyFrame : Frame
emptyFrame =
  { activities = []
  , aspects = [] }
