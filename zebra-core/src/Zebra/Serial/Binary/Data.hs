{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
module Zebra.Serial.Binary.Data (
    Header(..)
  , BinaryVersion(..)

  , headerOfSchema
  , schemaOfHeader

  , BinaryEncodeError(..)
  , renderBinaryEncodeError

  , BinaryDecodeError(..)
  , renderBinaryDecodeError
  ) where

import           P

import           Zebra.Table.Encoding (Utf8Error)
import qualified Zebra.Table.Encoding as Encoding
import qualified Zebra.Table.Schema as Schema


data Header =
    HeaderV3 !Schema.Table
    deriving (Eq, Ord, Show)

data BinaryVersion =
--  BinaryV0 -- x Initial version.
--  BinaryV1 -- x Store factset-id instead of priority, this flips sort order.
--  BinaryV2 -- ^ Schema is stored in header, instead of encoding.
    BinaryV3 -- ^ Data is stored as tables instead of entity blocks.
    deriving (Eq, Ord, Show)

data BinaryEncodeError =
    BinaryEncodeUtf8 !Utf8Error
    deriving (Eq, Show)

data BinaryDecodeError =
    BinaryDecodeUtf8 !Utf8Error
    deriving (Eq, Show)

renderBinaryEncodeError :: BinaryEncodeError -> Text
renderBinaryEncodeError = \case
  BinaryEncodeUtf8 err ->
    "Failed encoding UTF-8 binary: " <>
    Encoding.renderUtf8Error err

renderBinaryDecodeError :: BinaryDecodeError -> Text
renderBinaryDecodeError = \case
  BinaryDecodeUtf8 err ->
    "Failed decoding UTF-8 binary: " <>
    Encoding.renderUtf8Error err

headerOfSchema :: BinaryVersion -> Schema.Table -> Header
headerOfSchema version schema =
  case version of
    BinaryV3 -> HeaderV3 schema

schemaOfHeader :: Header -> Schema.Table
schemaOfHeader = \case
  HeaderV3 table ->
    table
