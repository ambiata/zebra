{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE TemplateHaskell #-}
module Test.Zebra.Serial.Binary.Header where

import           Data.Map (Map)
import qualified Data.Map as Map

import           Disorder.Jack (Property, Jack)
import           Disorder.Jack (quickCheckAll, gamble, listOf, oneOf)

import           P

import           System.IO (IO)

import           Test.Zebra.Jack
import           Test.Zebra.Util

import           Zebra.Serial.Binary.Data
import           Zebra.Serial.Binary.Header

prop_roundtrip_header_v3 :: Property
prop_roundtrip_header_v3 =
  gamble jTableSchema $
    trippingSerial bHeaderV3 getHeaderV3

prop_roundtrip_header :: Property
prop_roundtrip_header =
  gamble jHeader $
    trippingSerial bHeader getHeader

jHeader :: Jack Header
jHeader =
  oneOf [
      HeaderV3 <$> jTableSchema
    ]

mapOf :: Ord k => Jack k -> Jack v -> Jack (Map k v)
mapOf k v =
  Map.fromList <$> listOf ((,) <$> k <*> v)

return []
tests :: IO Bool
tests =
  $quickCheckAll
