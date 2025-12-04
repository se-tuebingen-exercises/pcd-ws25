{-# LANGUAGE BlockArguments #-}
import Control.Concurrent
import Control.Concurrent.STM
import Control.Monad

data Event = Reindeer | Elves

main :: IO ()
main = do
  waitingReindeer <- newTVarIO []
  waitingElves <- newTVarIO []

  replicateM_ 9 do
    forkIO do
      reindeer <- newEmptyTMVarIO
      forever do
        threadDelay 3000000
        atomically (modifyTVar waitingReindeer (reindeer :))
        atomically (takeTMVar reindeer)

  replicateM_ 10 do
    forkIO do
      elf <- newEmptyTMVarIO
      forever do
        threadDelay 700000
        atomically (modifyTVar waitingElves (elf :))
        atomically (takeTMVar elf)

  forever do
    event <- atomically do
      error "TODO santa claus"
    case event of
      Reindeer -> do
        putStrLn "Reindeer"
        threadDelay 2000000
      Elves -> do
        putStrLn "Elves"
        threadDelay 1000000

