{-# LANGUAGE BlockArguments #-}

module AtomicOperations where

import Control.Monad
import Control.Concurrent.STM
import Control.Concurrent


testAndSet :: TVar Bool -> IO Bool
testAndSet flag = atomically do
  current <- readTVar flag
  when (not current)
    do writeTVar flag True
  return current

fetchAndAdd :: TVar Int -> Int -> IO Int
fetchAndAdd reference delta = atomically do
  current <- readTVar reference
  writeTVar reference (current + delta)
  return current

compareAndSet :: Eq a => TVar a -> a -> a -> IO Bool
compareAndSet reference expected value = atomically do
  current <- readTVar reference
  if current == expected
    then do
      writeTVar reference value
      return True
    else
      return False

compareAndSwap :: Eq a => TVar a -> a -> a -> IO a
compareAndSwap reference expected value = atomically do
  current <- readTVar reference
  if current == expected
    then writeTVar reference value
    else return ()
  return current


type LLSCVar a = (TVar a, TVar [ThreadId])

createLLSCVar :: a -> STM (LLSCVar a)
createLLSCVar value = do
  location <- newTVar value
  reservations  <- newTVar []
  return (location, reservations)

loadLinked :: LLSCVar a -> IO a
loadLinked (location, reservations) = do
  myself <- myThreadId
  atomically do
    others <- readTVar reservations
    writeTVar reservations (myself : others)
    readTVar location

storeConditional :: LLSCVar a -> a -> IO Bool
storeConditional (location, reservations) value = do
  myself <- myThreadId
  atomically do
    owners <- readTVar reservations
    writeTVar reservations []
    if elem myself owners
      then do
        writeTVar location value
        return True
      else do
        return False

