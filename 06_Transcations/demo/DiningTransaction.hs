{-# LANGUAGE BlockArguments #-}
import Control.Concurrent
import Control.Concurrent.STM
import Control.Monad
import Control.Monad.STM
import GHC.Conc (unsafeIOToSTM)


pickup :: TVar Bool -> STM ()
pickup fork = do
    taken <- readTVar fork
    if taken
        then retry
        else writeTVar fork True

putdown :: TVar Bool -> STM ()
putdown fork = do
    taken <- readTVar fork
    if taken
        then writeTVar fork False
        else retry

wait :: TVar Int -> STM ()
wait done = do
    count <- readTVar done
    if count == 0
        then return ()
        else retry

add :: TVar Int -> Int -> STM ()
add done n = do
    count <- readTVar done
    writeTVar done (count + n)


main :: IO ()
main = do
    fork0 <- newTVarIO False
    fork1 <- newTVarIO False
    fork2 <- newTVarIO False
    fork3 <- newTVarIO False
    fork4 <- newTVarIO False
    done <- newTVarIO 5

    forkIO do
        atomically do
            pickup fork0
            unsafeIOToSTM (threadDelay 10000)
            pickup fork1
        putStrLn "0 eating"
        atomically do
            putdown fork0
            putdown fork1
            add done (-1)

    forkIO do
        atomically do
            pickup fork1
            unsafeIOToSTM (threadDelay 10000)
            pickup fork2
        putStrLn "1 eating"
        atomically do
            putdown fork1
            putdown fork2
            add done (-1)

    forkIO do
        atomically do
            pickup fork2
            unsafeIOToSTM (threadDelay 10000)
            pickup fork3
        putStrLn "2 eating"
        atomically do
            putdown fork2
            putdown fork3
            add done (-1)

    forkIO do
        atomically do
            pickup fork3
            unsafeIOToSTM (threadDelay 10000)
            pickup fork4
        putStrLn "3 eating"
        atomically do
            putdown fork3
            putdown fork4
            add done (-1)

    forkIO do
        atomically do
            pickup fork4
            unsafeIOToSTM (threadDelay 10000)
            pickup fork0
        putStrLn "4 eating"
        atomically do
            putdown fork4
            putdown fork0
            add done (-1)

    atomically (wait done)

