{-# LANGUAGE BlockArguments #-}

import Control.Concurrent.STM
import Control.Concurrent
import Control.Monad

type Queue a = ([a], [a])

type BankersQueue a = TVar (Queue a)

newQueue :: STM (BankersQueue a)
newQueue = newTVar ([], [])

enqueue :: BankersQueue a -> a -> STM ()
enqueue q x = do
    (front, back) <- readTVar q
    writeTVar q (front, x : back)

dequeue :: BankersQueue a -> STM (Maybe a)
dequeue q = do
    (front, back) <- readTVar q
    case front of
        (x : xs) -> do
            writeTVar q (xs, back)
            return (Just x)
        [] -> case reverse back of
            [] -> return Nothing
            (x : xs) -> do
                writeTVar q (xs, [])
                return (Just x)

main :: IO ()
main = do
    let n = 100000

    queue <- atomically newQueue

    replicateM_ n do
        forkIO do
            atomically do
                enqueue queue "work"

    items <- replicateM n do
        atomically do
            result <- dequeue queue
            case result of
                Nothing -> retry
                Just item -> return item
    print (length items)


