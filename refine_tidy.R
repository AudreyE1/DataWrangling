library(tidyr)
library(dplyr)

# Read csv file
refine_original = read.csv("refine_original.csv", sep=",")

# inspect company column
refine_original$company = tolower(refine_original$company)
unique(refine_original$company)

# Clean Up brand names
refine_original$company[substr(refine_original$company, start=1, stop=1) == "p"] <- "philips"
refine_original$company[refine_original$company == "fillips"] <- "philips"
refine_original$company[substr(refine_original$company, start=1, stop=1) == "a"] <- "akzo"
refine_original$company[refine_original$company == "unilver"] <- "unilever"

# Separate Product codes
refine <- refine_original %>% separate(Product.code...number, c("product_code", "product_number"), sep = "-")

head(refine)

# Create Product categories
refine <- refine %>% mutate(product_category = ifelse(product_code == "p", "Smartphone",
                                               ifelse(product_code == "v", "TV",
                                               ifelse(product_code == "x", "Laptop",
                                               ifelse(product_code == "q", "Tablet", NA)))))
head(refine)

# Full addresses
refine <- refine %>% unite(full_address, address, city, country, sep = ",")

# Binary columns
refine_new <- refine %>%
  mutate(company, product_company = paste("company_", company, sep="")) %>%
  mutate(yesno = 1) %>%
  spread(product_company, yesno, fill = 0) %>%
  mutate(product_category, category = paste("product_", product_category, sep="")) %>%
  mutate(yesno = 1) %>%
  spread(category, yesno, fill = 0)

# Write output to file
write.csv(refine_new, "refine_new.csv", quote=FALSE, row.names=FALSE)
