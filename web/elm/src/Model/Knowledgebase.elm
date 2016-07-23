module Model.Knowledgebase exposing (..)

import Model.Knowledgebase.Aspect exposing (..)
import Model.Knowledgebase.Activity exposing (..)

type alias Knowledgebase =
  { activities : List Activity
  , aspects : List Aspect }


emptyKnowledgebase : Knowledgebase
emptyKnowledgebase =
  { activities = []
  , aspects = [] }
