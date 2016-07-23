module Model.Frame.Activity exposing (..)

type alias Activity =
  { title : String
  , summary : String
  , published : Bool
  , sections : List String
  , annotations : List String }
