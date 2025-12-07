{-# LANGUAGE BlockArguments #-}

import Control.Concurrent
import Control.Concurrent.MVar
import Network.Socket
import Network.Socket.ByteString
import Data.ByteString


main :: IO ()
main = do
    timeoutMVar <- newEmptyMVar
    requestMVar <- newEmptyMVar

    forkIO do
        threadDelay 10000000
        putMVar timeoutMVar "timeout"

    forkIO do
        response <- fetch "localhost" "8001"
        putMVar requestMVar response

    result <- race timeoutMVar requestMVar
    case result of
        Left msg -> putStrLn msg
        Right body -> print body

race :: MVar a -> MVar b -> IO (Either a b)
race mvar1 mvar2 = do
    result <- newEmptyMVar
    forkIO do
        value1 <- takeMVar mvar1
        tryPutMVar result (Left value1)
        return ()
    forkIO do
        value2 <- takeMVar mvar2
        tryPutMVar result (Right value2)
        return ()
    takeMVar result

fetch :: String -> String -> IO ByteString
fetch host port = do
  address : _ <- getAddrInfo Nothing (Just host) (Just port)
  socket <- socket (addrFamily address) Stream defaultProtocol
  connect socket (addrAddress address)
  response <- recv socket 4096
  close socket
  return response

