{-# LANGUAGE BlockArguments #-}

import Control.Concurrent
import Control.Concurrent.MVar

main :: IO ()
main = do
    fork0 <- newMVar ()
    fork1 <- newMVar ()
    fork2 <- newMVar ()
    fork3 <- newMVar ()
    fork4 <- newMVar ()
    done <- newEmptyMVar

    forkIO do
        takeMVar fork0; threadDelay 10000; takeMVar fork1
        putStrLn "0 eating"; putMVar fork0 (); putMVar fork1 ()
        putMVar done ()

    forkIO do
        takeMVar fork1; threadDelay 10000; takeMVar fork2
        putStrLn "1 eating"; putMVar fork1 (); putMVar fork2 ()
        putMVar done ()

    forkIO do
        takeMVar fork2; threadDelay 10000; takeMVar fork3
        putStrLn "2 eating"; putMVar fork2 (); putMVar fork3 ()
        putMVar done ()

    forkIO do
        takeMVar fork3; threadDelay 10000; takeMVar fork4
        putStrLn "3 eating"; putMVar fork3 (); putMVar fork4 ()
        putMVar done ()

    forkIO do
        takeMVar fork0; threadDelay 10000; takeMVar fork4
        putStrLn "4 eating"; putMVar fork4 (); putMVar fork0 ()
        putMVar done ()

    takeMVar done
    takeMVar done
    takeMVar done
    takeMVar done
    takeMVar done

