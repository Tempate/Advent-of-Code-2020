import Data.Maybe


star1 :: [Int] -> Int -> Maybe Int
star1 [] _ = Nothing
star1 (n:ns) target
    | (target - n) `elem` ns = Just (n * (target - n))
    | otherwise = star1 ns target


star2 :: [Int] -> Int -> Maybe Int
star2 [] _ = Nothing
star2 (n:ns) target = case star1 ns (target - n) of
    Just m -> Just (n * m)
    Nothing -> star2 ns target


main :: IO ()
main = do
    contents <- getContents
    let numbers = map read (lines contents) :: [Int]
    
    putStrLn $ "Part 1: " ++ show (fromJust (star1 numbers 2020))
    putStrLn $ "Part 2: " ++ show (fromJust (star2 numbers 2020))
