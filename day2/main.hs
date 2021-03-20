type Password = (Int, Int, Char, String)


parse :: [String] -> Password
parse [bounds, char:_, str] = (read a, read b, char, str)
    where (a, '-':b) = break (=='-') bounds


policy1 :: Password -> Bool
policy1 (lower, upper, _, []) = lower <= 0 && upper >= 0
policy1 (lower, upper, char, (c:cs))
    | c == char = policy1 (lower-1, upper-1, char, cs)
    | otherwise = policy1 (lower,   upper,   char, cs)


policy2 :: Password -> Bool
policy2 (lower, upper, char, str) = (indexMatch lower) /= (indexMatch upper)
    where indexMatch i = str !! (i-1) == char


main :: IO ()
main = do
    contents <- getContents
    let passwords = map (parse . words) (lines contents)

    putStrLn $ "Part 1: " ++ (show . sum . map (fromEnum . policy1)) passwords
    putStrLn $ "Part 2: " ++ (show . sum . map (fromEnum . policy2)) passwords
