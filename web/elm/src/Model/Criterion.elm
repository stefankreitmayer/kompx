module Model.Criterion exposing (..)

type alias Criterion =
  { name : String
  , options : List Option }

type alias Option =
  { name : String
  , checked : Bool }

