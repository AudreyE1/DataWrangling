library(tidyr)
library(dplyr)

# Read csv file
titanic_original = read.csv("titanic_original.csv", sep=",")

# inspect embarked column
unique(titanic_original$embarked)
titanic_original %>% filter(embarked == "")

# Replace missing value with S
titanic_original$embarked[titanic_original$embarked == ""] <- "S"

# Replace missing ages with mean
titanic_original <- titanic_original %>% 
   replace_na(list(age = mean(titanic_original$age, na.rm=TRUE)))

# In this case I would treat the missing vales as a separte category

titanic_original <-  titanic_original %>% mutate(boat = replace(boat, boat=="", NA))

titanic_new <- titanic_original %>%
  mutate(cabin, has_cabin_number = ifelse(cabin == "", 0, 1))

# Write output to file
write.csv(titanic_new, "titanic_new.csv", quote = FALSE, row.names = FALSE)
