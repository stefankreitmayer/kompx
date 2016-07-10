module Helpers exposing (..)

dropDuplicates : List a -> List a
dropDuplicates xs =
  case xs of
    [] -> []
    hd::tl ->
      if List.member hd tl then
        dropDuplicates tl
      else
        hd :: (dropDuplicates tl)
