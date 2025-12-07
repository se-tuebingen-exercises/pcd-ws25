{-# LANGUAGE BlockArguments #-}

import Control.Concurrent
import Control.Concurrent.STM
import Control.Monad

main :: IO ()
main = do
    counter <- newTVarIO 0
    replicateM_ 1000 do
        forkIO do
            atomically do
                value <- readTVar counter
                writeTVar counter (value + 1)
    threadDelay 100000
    result <- readTVarIO counter
    print result

