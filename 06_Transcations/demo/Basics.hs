{-# LANGUAGE BlockArguments #-}

import Control.Concurrent
import Data.IORef
import Control.Monad

main :: IO ()
main = do
    counter <- newIORef 0
    replicateM_ 1000 do
        forkIO do
            value <- readIORef counter
            writeIORef counter (value + 1)
    threadDelay 100000
    result <- readIORef counter
    print result

