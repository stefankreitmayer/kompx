module Model.Page exposing (..)

import Model.Aspect exposing (..)


type Page
  = AspectPage Aspect
  | SearchResultsPage


allPages : List Aspect -> List Page
allPages aspects =
  let
      aspectPages = List.map AspectPage aspects
  in
      aspectPages ++ [ SearchResultsPage ]


previousPage : List Aspect -> Page -> Maybe Page
previousPage aspects currentPage =
  listPredecessor (allPages aspects) currentPage


nextPage : List Aspect -> Page -> Maybe Page
nextPage aspects currentPage =
  listSuccessor (allPages aspects) currentPage


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
