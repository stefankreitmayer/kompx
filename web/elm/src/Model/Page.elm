module Model.Page exposing (..)

import Model.Criterion exposing (..)


type Page
  = CriterionPage Criterion
  | SearchResultsPage


allPages : List Criterion -> List Page
allPages criteria =
  let
      criterionPages = List.map CriterionPage criteria
  in
      criterionPages ++ [ SearchResultsPage ]


previousPage : List Criterion -> Page -> Maybe Page
previousPage criteria currentPage =
  listPredecessor (allPages criteria) currentPage


nextPage : List Criterion -> Page -> Maybe Page
nextPage criteria currentPage =
  listSuccessor (allPages criteria) currentPage


listSuccessor : List a -> a -> Maybe a
listSuccessor xs x =
  case xs of
    [] ->
      Nothing

    [_] ->
      Nothing

    first :: second :: tl ->
      if first==x then Just second else listSuccessor (second::tl) x


listPredecessor : List a -> a -> Maybe a
listPredecessor xs x =
  listSuccessor (List.reverse xs) x


pageIndex : Page -> List Page -> Int -> Int
pageIndex page pages startIndex =
  case pages of
    [] ->
      -1

    hd::tl ->
      if hd==page then
        startIndex
      else
        pageIndex page tl (startIndex+1)
