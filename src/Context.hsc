{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}

module Context where

import Control.Monad (liftM2)

import qualified Data.Map as Map
import Data.Word (Word64(..))

import Foreign.Storable
  ( Storable(..) )

import qualified Language.C.Inline as C
import qualified Language.C.Inline.Context as C
import qualified Language.C.Types as C

#include "foo.c"

#let alignment t = "%lu", (unsigned long)offsetof(struct {char x__; t (y__);}, y__)

C.include "foo.c"

data Foo = Foo { f_slithy :: {-# UNPACK #-} !Word64
               , f_toves :: {-# UNPACK #-} !Word64
               }
  deriving (Eq, Show)

instance Storable Foo where
  sizeOf    _           = #{size struct a0_foo}
  alignment _           = #{alignment struct a0_foo}
  peek      p           = liftM2 Foo
                            (#{peek struct a0_foo, f_slithy} p)
                            (#{peek struct a0_foo, f_toves} p)
  poke      p (Foo c k) = do #{poke struct a0_foo, f_slithy} p c
                             #{poke struct a0_foo, f_toves} p k

spielCtx :: C.Context
spielCtx = mempty {
  C.ctxTypesTable = Map.fromList [
    (C.TypeName "struct a0_foo", [t| Foo |])
  ]
}
