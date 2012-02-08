module EAlbum (start) where

import Control.Monad ((<=<))

import Network.Lastfm.Response
import Network.Lastfm.Types
import qualified Network.Lastfm.API.Album as Album

import Kludges

apiKey = APIKey "b25b959554ed76058ac220b7b2e0a026"

addTags :: APIKey -> SessionKey -> IO ()
addTags apiKey sessionKey = do response <- Album.addTags (Artist "Pink Floyd", Album "The Wall") [Tag "70s", Tag "awesome"] apiKey sessionKey
                               case response of
                                 Left e  -> print e
                                 Right () -> return ()

getBuylinks :: IO ()
getBuylinks = do response <- Album.getBuyLinks (Just (Artist "Pink Floyd", Album "The Wall")) Nothing Nothing (Country "United Kingdom") apiKey
                 putStr "Download suppliers: "
                 case response of
                   Left e  -> print e
                   Right r -> print (suppliers r)
                 putStrLn ""
  where suppliers = mapM (getContent <=< lookupChild "supplierName") <=< lookupChildren "affiliation" <=< lookupChild "downloads" <=< lookupChild "affiliations" <=< wrap

getInfo :: IO ()
getInfo = do response <- Album.getInfo (Just (Artist "Pink Floyd", Album "The Wall")) Nothing Nothing Nothing Nothing apiKey
             putStr "Top 5 tags: "
             case response of
               Left e  -> print e
               Right r -> print (suppliers r)
             putStrLn ""
  where suppliers = mapM (getContent <=< lookupChild "name") <=< lookupChildren "tag" <=< lookupChild "toptags" <=< lookupChild "album" <=< wrap

getShouts :: IO ()
getShouts = do response <- Album.getShouts (Just (Artist "Pink Floyd", Album "The Wall")) Nothing Nothing Nothing (Just (Limit 7)) apiKey
               putStr "Last 7 shouts: "
               case response of
                 Left e  -> print e
                 Right r -> print (shouts r)
               putStrLn ""
  where shouts = mapM (getContent <=< lookupChild "body") <=< lookupChildren "shout" <=< lookupChild "shouts" <=< wrap

getTopTags :: IO ()
getTopTags = do response <- Album.getTopTags (Just (Artist "Pink Floyd", Album "The Wall")) Nothing Nothing apiKey
                putStr "Top tags counts: "
                case response of
                  Left e  -> print e
                  Right r -> print (counts r)
                putStrLn ""
  where counts = mapM (getContent <=< lookupChild "count") <=< lookupChildren "tag" <=< lookupChild "toptags" <=< wrap

removeTag :: APIKey -> SessionKey -> IO ()
removeTag apiKey sessionKey = do response <- Album.removeTag (Artist "Pink Floyd") (Album "The Wall") (Tag "awesome") apiKey sessionKey
                                 case response of
                                   Left e  -> print e
                                   Right () -> return ()

search :: IO ()
search = do response <- Album.search (Album "wall") Nothing (Just (Limit 5)) apiKey
            putStr "5 search results for \"wall\" query: "
            case response of
              Left e  -> print e
              Right r -> print (albums r)
            putStrLn ""
  where albums = mapM (getContent <=< lookupChild "name") <=< lookupChildren "album" <=< lookupChild "albummatches" <=< lookupChild "results" <=< wrap

start :: IO ()
start = do getBuylinks
           getInfo
           getShouts
           getTopTags
           search
           (apiKey, sessionKey, secret) <- getConfig ".lastfm.conf"
           withSecret secret $ do addTags apiKey sessionKey
                                  --getTags apiKey sessionKey
                                  removeTag apiKey sessionKey
                                  --share apiKey sessionKey