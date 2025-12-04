{-# LANGUAGE BlockArguments #-}

import Control.Concurrent
import Control.Concurrent.STM
import Control.Concurrent.STM.TArray
import Control.Monad
import Data.Array.MArray
import System.Random

transfer :: TArray Int Int -> Int -> Int -> Int -> STM ()
transfer accounts amount source target = do
  sourceBalance <- readArray accounts source
  if sourceBalance < amount
    then retry
    else do
      writeArray accounts source (sourceBalance - amount)
      targetBalance <- readArray accounts target
      writeArray accounts target (targetBalance + amount)

waitGroupAdd :: TVar Int -> IO ()
waitGroupAdd counter = atomically do
  modifyTVar counter (+1)

waitGroupDone :: TVar Int -> IO ()
waitGroupDone counter = atomically do
  modifyTVar counter (subtract 1)

waitGroupWait :: TVar Int -> IO ()
waitGroupWait counter = atomically do
  count <- readTVar counter
  unless (count == 0) retry

main :: IO ()
main = do
  accounts <- atomically (newArray (0, 99) 1000)
  counter <- newTVarIO 0

  replicateM_ 100000 do
    source <- randomRIO (0, 99)
    target <- randomRIO (0, 99)
    amount <- randomRIO (0, 99)

    waitGroupAdd counter
    forkIO do
      atomically do
        transfer accounts amount source target
      waitGroupDone counter

    waitGroupAdd counter
    forkIO do
      atomically do
        transfer accounts amount target source
      waitGroupDone counter

  waitGroupWait counter

  balances <- atomically do
    mapM (readArray accounts) [0..99]

  putStrLn ("Total: " ++ show (sum balances))

