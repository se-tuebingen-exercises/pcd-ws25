{-# LANGUAGE BlockArguments #-}

import Control.Concurrent
import Control.Concurrent.Chan
import Control.Monad

main :: IO ()
main = do
    queue1 <- newChan
    queue2 <- newChan
    forkIO do
        producer queue1
    forkIO do
        transformer queue1 queue2
    forkIO do
        consumer queue2
    threadDelay (1000000)

producer :: Chan (Maybe Int) -> IO ()
producer queue1 = do
    forM_ [0..4] \i ->
        writeChan queue1 (Just i)
    writeChan queue1 Nothing

transformer :: Chan (Maybe Int) -> Chan (Maybe Int) -> IO ()
transformer queue1 queue2 = do
    value <- readChan queue1
    case value of
        Nothing -> do
            writeChan queue2 Nothing
        Just v -> do
            writeChan queue2 (Just (v + 1))
            transformer queue1 queue2

consumer :: Chan (Maybe Int) -> IO ()
consumer queue2 = do
    value <- readChan queue2
    case value of
        Nothing -> return ()
        Just v -> do
            print v
            consumer queue2
