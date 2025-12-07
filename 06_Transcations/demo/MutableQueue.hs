{-# LANGUAGE BlockArguments #-}

import Control.Concurrent.STM
import Control.Concurrent
import Control.Monad

data Node a = Nil | Cons a (TVar (Node a))

type MutableQueue a = (TVar (TVar (Node a)), TVar (TVar (Node a)))

newQueue :: STM (MutableQueue a)
newQueue = do
    nil <- newTVar Nil
    front <- newTVar nil
    back <- newTVar nil
    return (front, back)

enqueue :: MutableQueue a -> a -> STM ()
enqueue (_, back) value = do
    backVar <- readTVar back
    restVar <- newTVar Nil
    writeTVar backVar (Cons value restVar)
    writeTVar back restVar

dequeue :: MutableQueue a -> STM (Maybe a)
dequeue (front, _) = do
    frontVar <- readTVar front
    frontNode <- readTVar frontVar
    case frontNode of
        Nil -> return Nothing
        Cons value next -> do
          writeTVar front next
          return (Just value)


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


