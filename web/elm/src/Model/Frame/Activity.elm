module Model.Frame.Activity exposing (..)

type alias Activity =
  { id : Int
  , title : String
  , summary : String
  , author : String
  , sections : List Section
  , tagIds : List Int }

type alias Section =
  { title : String
  , body : String }
