{-# LANGUAGE BlockArguments #-}

module Main where

import Control.Concurrent.STM
import Control.Concurrent
import Network.Socket
import Network.Socket.ByteString


waitTimeout :: TVar Bool -> STM (Maybe a)
waitTimeout tvar = do
    t <- readTVar tvar
    if t then return Nothing else retry


main :: IO ()
main = do
    result <- newEmptyTMVarIO
    timer <- registerDelay 3000000

    forkIO do
        response <- fetch "localhost" "8000"
        atomically (putTMVar result response)

    outcome <- atomically do
        orElse (takeTMVar result) (waitTimeout timer)

    print outcome


fetch :: String -> String -> IO ByteString
fetch host port = do
    address : _ <- getAddrInfo Nothing (Just host) (Just port)
    socket <- socket (addrFamily address) Stream defaultProtocol
    connect socket (addrAddress address)
    response <- recv socket 4096
    close socket
    return response

