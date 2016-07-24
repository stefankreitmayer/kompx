module Model.Frame.Aspect exposing (..)

type alias Aspect =
  { name : String
  , position : Int
  , options : List Option }

type alias Option =
  { name : String
  , tagId : Int
  , checked : Bool }

