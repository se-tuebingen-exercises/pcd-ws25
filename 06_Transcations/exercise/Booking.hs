{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE BlockArguments #-}

import Servant
import Network.Wai.Handler.Warp
import Network.Wai.Middleware.Cors
import Data.Aeson
import GHC.Generics
import Data.IORef
import qualified Data.Set as Set
import qualified Data.Map as Map
import Control.Monad.IO.Class

data BookingRequest = BookingRequest
  { room :: Int
  , dates :: [Int]
  } deriving (Generic)

data BookingResponse = BookingResponse
  { success :: Bool
  , bookedDates :: [Int]
  } deriving (Generic)

instance FromJSON BookingRequest
instance ToJSON BookingResponse

type BookingState = IORef (Map.Map Int (Set.Set Int))

type BookingAPI =
       "api" :> "book" :> ReqBody '[JSON] BookingRequest :> Post '[JSON] BookingResponse
  :<|> "api" :> "bookings" :> Capture "room" Int :> Get '[JSON] [Int]
  :<|> Raw

bookRoom :: BookingState -> BookingRequest -> Handler BookingResponse
bookRoom bookings request = liftIO do
  current <- readIORef bookings
  let requestedDates = Set.fromList (dates request)
  let existingDates = Map.findWithDefault Set.empty (room request) current
  let conflict = not (Set.null (Set.intersection requestedDates existingDates))
  let updated = Map.insertWith Set.union (room request) requestedDates current
  if conflict
    then return (BookingResponse False [])
    else do
      writeIORef bookings updated
      return (BookingResponse True (dates request))

getBookings :: BookingState -> Int -> Handler [Int]
getBookings bookings roomNum = liftIO do
  current <- readIORef bookings
  let roomDates = Map.findWithDefault Set.empty roomNum current
  return (Set.toList roomDates)

server :: BookingState -> Server BookingAPI
server bookings = bookRoom bookings :<|> getBookings bookings :<|> serveDirectoryWebApp "static"

app :: BookingState -> Application
app bookings = cors (const (Just simpleCorsResourcePolicy)) (serve (Proxy :: Proxy BookingAPI) (server bookings))

main :: IO ()
main = do
  bookings <- newIORef Map.empty
  run 3000 (app bookings)

