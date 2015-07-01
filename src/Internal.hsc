{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}

module Internal where

import Context

import Data.Monoid ((<>))

import Foreign.Ptr (Ptr)
import qualified Language.C.Inline as C

C.context $ C.baseCtx <> spielCtx

C.include "foo.c"

freeFoo :: Ptr Foo -- ^ Pointer to head of array
        -> IO C.CInt
freeFoo arr = [C.block| int {
    struct foo *arr = $(struct foo *arr);
    free(arr);
  }
|]
