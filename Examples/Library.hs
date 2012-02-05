#!/usr/bin/env runhaskell

import Control.Monad ((<=<))

import Network.Lastfm.Core
import Network.Lastfm.Types
import qualified Network.Lastfm.API.Library as Library

apiKey = APIKey "b25b959554ed76058ac220b7b2e0a026"
user = User "smpcln"

getAlbums :: IO ()
getAlbums = do response <- Library.getAlbums user (Just $ Artist "Burzum") Nothing (Just $ Limit 5) apiKey
               putStr "Top 5 popular Burzum albums: "
               case response of
                 Left e  -> print e
                 Right r -> print $ albums r
  where albums = mapM (getContent <=< lookupChild "name") <=< lookupChildren "album" <=< lookupChild "albums"

getArtists :: IO ()
getArtists = do response <- Library.getArtists user Nothing (Just $ Limit 7) apiKey
                putStr "Top 7 popular artists playcounts: "
                case response of
                  Left e  -> print e
                  Right r -> print $ playcounts r
  where playcounts = mapM (getContent <=< lookupChild "name") <=< lookupChildren "artist" <=< lookupChild "artists"

getTracks :: IO ()
getTracks = do response <- Library.getTracks user (Just $ Artist "Burzum") Nothing Nothing (Just $ Limit 4) apiKey
               putStr "First 4 Burzum tracks: "
               case response of
                 Left e  -> print e
                 Right r -> print $ tracks r
  where tracks = mapM (getContent <=< lookupChild "name") <=< lookupChildren "track" <=< lookupChild "tracks"

main :: IO ()
main = do -- addAlbum (requires authorization)
          -- addArtist (requires authorization)
          -- addTrack (requires authorization)
          getAlbums
          getArtists
          getTracks
          -- removeAlbum (requires authorization)
          -- removeArtist (requires authorization)
          -- removeScrobble (requires authorization)
          -- removeTrack (requires authorization)