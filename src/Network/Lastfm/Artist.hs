{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
-- | Lastfm artist API
--
-- This module is intended to be imported qualified:
--
-- @
-- import qualified Network.Lastfm.Artist as Artist
-- @
module Network.Lastfm.Artist
  ( ArtistOrMBID
  , addTags, getCorrection, getEvents, getInfo
  , getPastEvents, getPodcast, getShouts
  , getSimilar, getTags, getTopAlbums
  , getTopFans, getTopTags, getTopTracks
  , removeTag, search, share, shout
  ) where

import Control.Applicative

import Network.Lastfm.Request

-- | Unify ('Artist' -> …) and ('MBID' -> …)
class ArtistOrMBID r a

instance ArtistOrMBID r MBID
instance ArtistOrMBID r Artist


-- | Tag an artist with one or more user supplied tags.
--
-- <http://www.last.fm/api/show/artist.addTags>
addTags :: Request f (Artist -> [Tag] -> APIKey -> SessionKey -> Sign)
addTags = api "artist.addTags" <* post
{-# INLINE addTags #-}


-- | Use the last.fm corrections data to check whether the
-- supplied artist has a correction to a canonical artist
--
-- <http://www.last.fm/api/show/artist.getCorrection>
getCorrection :: Request f (Artist -> APIKey -> Ready)
getCorrection = api "artist.getCorrection"
{-# INLINE getCorrection #-}


-- | Get a list of upcoming events for this artist. Easily
-- integratable into calendars, using the ical standard (see feeds section below).
--
-- Optional: 'autocorrect', 'limit', 'pages', 'festivalsonly'
--
-- <http://www.last.fm/api/show/artist.getEvents>
getEvents :: ArtistOrMBID Ready a => Request f (a -> APIKey -> Ready)
getEvents = api "artist.getEvents"
{-# INLINE getEvents #-}


-- | Get the metadata for an artist. Includes biography.
--
-- Optional: 'language', 'autocorrect', 'username'
--
-- <http://www.last.fm/api/show/artist.getInfo>
getInfo :: ArtistOrMBID Ready a => Request f (a -> APIKey -> Ready)
getInfo = api "artist.getInfo"
{-# INLINE getInfo #-}


-- | Get a paginated list of all the events this artist has played at in the past.
--
-- Optional: 'page', 'autocorrect', 'limit'
--
-- <http://www.last.fm/api/show/artist.getPastEvents>
getPastEvents :: ArtistOrMBID Ready a => Request f (a -> APIKey -> Ready)
getPastEvents = api "artist.getPastEvents"
{-# INLINE getPastEvents #-}


-- | Get a podcast of free mp3s based on an artist
--
-- Optional: 'autocorrect'
--
-- <http://www.last.fm/api/show/artist.getPodcast>
getPodcast :: ArtistOrMBID Ready a => Request f (a -> APIKey -> Ready)
getPodcast = api "artist.getPodcast"
{-# INLINE getPodcast #-}


-- | Get shouts for this artist. Also available as an rss feed.
--
-- Optional:'autocorrect', 'limit', 'page'
--
-- <http://www.last.fm/api/show/artist.getShouts>
getShouts :: ArtistOrMBID Ready a => Request f (a -> APIKey -> Ready)
getShouts = api "artist.getShouts"
{-# INLINE getShouts #-}


-- | Get all the artists similar to this artist
--
-- Optional: 'limit', 'autocorrect'
--
-- <http://www.last.fm/api/show/artist.getSimilar>
getSimilar :: ArtistOrMBID Ready a => Request f (a -> APIKey -> Ready)
getSimilar = api "artist.getSimilar"
{-# INLINE getSimilar #-}


-- | Get the tags applied by an individual user to an artist on Last.fm.
-- If accessed as an authenticated service /and/ you don't supply a
-- user parameter then this service will return tags for
-- the authenticated user. To retrieve the list of top tags applied
-- to an artist by all users use 'Network.Lastfm.Artist.getTopTags'.
--
-- Optional: 'user', 'autocorrect'
--
-- <http://www.last.fm/api/show/artist.getTags>
getTags :: ArtistOrMBID r a => Request f (a -> APIKey -> r)
getTags = api "artist.getTags"
{-# INLINE getTags #-}


-- | Get the top albums for an artist on Last.fm, ordered by popularity.
--
-- Optional: 'autocorrect', 'page', 'limit'
--
-- <http://www.last.fm/api/show/artist.getTopAlbums>
getTopAlbums :: ArtistOrMBID Ready a => Request f (a -> APIKey -> Ready)
getTopAlbums = api "artist.getTopAlbums"
{-# INLINE getTopAlbums #-}


-- | Get the top fans for an artist on Last.fm, based on listening data.
--
-- Optional: 'autocorrect'
--
-- <http://www.last.fm/api/show/artist.getTopFans>
getTopFans :: ArtistOrMBID Ready a => Request f (a -> APIKey -> Ready)
getTopFans = api "artist.getTopFans"
{-# INLINE getTopFans #-}


-- | Get the top tags for an artist on Last.fm, ordered by popularity.
--
-- Optional: 'autocorrect'
--
-- <http://www.last.fm/api/show/artist.getTopTags>
getTopTags :: ArtistOrMBID Ready a => Request f (a -> APIKey -> Ready)
getTopTags = api "artist.getTopTags"
{-# INLINE getTopTags #-}


-- | Get the top tracks by an artist on Last.fm, ordered by popularity
--
-- Optional: 'autocorrect', 'page', 'limit'
--
-- <http://www.last.fm/api/show/artist.getTopTracks>
getTopTracks :: ArtistOrMBID Ready a => Request f (a -> APIKey -> Ready)
getTopTracks = api "artist.getTopTracks"
{-# INLINE getTopTracks #-}


-- | Remove a user's tag from an artist.
--
-- <http://www.last.fm/api/show/artist.removeTag>
removeTag :: Request f (Artist -> Tag -> APIKey -> SessionKey -> Sign)
removeTag = api "artist.removeTag" <* post
{-# INLINE removeTag #-}


-- | Search for an artist by name. Returns artist matches sorted by relevance.
--
-- Optional: 'limit', 'page'
--
-- <http://www.last.fm/api/show/artist.search>
search :: Request f (Artist -> APIKey -> Ready)
search = api "artist.search"
{-# INLINE search #-}


-- | Share an artist with Last.fm users or other friends.
--
-- Optional: 'message', 'public'
--
-- <http://www.last.fm/api/show/artist.share>
share :: Request f (Artist -> Recipient -> APIKey -> SessionKey -> Sign)
share = api "artist.share" <* post
{-# INLINE share #-}


-- | Shout in this artist's shoutbox
--
-- <http://www.last.fm/api/show/artist.shout>
shout :: Request f (Artist -> Message -> APIKey -> SessionKey -> Sign)
shout = api "artist.shout" <* post
{-# INLINE shout #-}
