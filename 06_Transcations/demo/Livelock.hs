{-# LANGUAGE BlockArguments #-}

import Control.Concurrent
import Control.Concurrent.STM
import Control.Monad
import GHC.Conc


main :: IO ()
main = do

  counter <- newTVarIO 0

  forkIO do
    forever do
      atomically do
        value <- readTVar counter
        unsafeIOToSTM (threadDelay 10000)
        writeTVar counter (value + 1000)

  forkIO do
    forever do
      atomically do
        value <- readTVar counter
        writeTVar counter (value + 1)
      atomically do
        value <- readTVar counter
        writeTVar counter (value - 1)

  forever do
    threadDelay 100000
    value <- readTVarIO counter
    print value

  threadDelay 1000000

