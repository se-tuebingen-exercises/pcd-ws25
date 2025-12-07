{-# LANGUAGE BlockArguments #-}

import Data.IORef
import Control.Concurrent
import Control.Concurrent.STM
import Control.Monad


swapIORefs :: IORef a -> IORef a -> IO ()
swapIORefs r1 r2 = do
    v1 <- readIORef r1
    v2 <- readIORef r2
    writeIORef r1 v2
    writeIORef r2 v1

swapMVars :: MVar a -> MVar a -> IO ()
swapMVars m1 m2 = do
    v1 <- takeMVar m1
    v2 <- takeMVar m2
    putMVar m1 v2
    putMVar m2 v1

swapTVars :: TVar a -> TVar a -> STM ()
swapTVars t1 t2 = do
    v1 <- readTVar t1
    v2 <- readTVar t2
    writeTVar t1 v2
    writeTVar t2 v1

main :: IO ()
main = do
    r1 <- newIORef 1
    r2 <- newIORef 2
    replicateM_ 1000 do
        forkIO do
            swapIORefs r1 r2
    threadDelay 100000
    v1 <- readIORef r1
    v2 <- readIORef r2
    putStrLn ("IORef final values: " ++ show (v1, v2))

    r1 <- newMVar 1
    r2 <- newMVar 2
    replicateM_ 1000 do
        forkIO do
            swapMVars r1 r2
    threadDelay 100000
    v1 <- readMVar r1
    v2 <- readMVar r2
    putStrLn ("MVar final values: " ++ show (v1, v2))

    t1 <- newTVarIO 1
    t2 <- newTVarIO 2
    replicateM_ 500 do
        forkIO do
            atomically do
              swapTVars t1 t2
        forkIO do
            atomically do
              swapTVars t2 t1
    threadDelay 100000
    v1 <- readTVarIO t1
    v2 <- readTVarIO t2
    putStrLn ("TVar final values: " ++ show (v1, v2))

