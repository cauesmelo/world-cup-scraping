# package install
install.packages("readxl",repos = "http://cran.us.r-project.org") 
install.packages("ggplot2",repos = "http://cran.us.r-project.org") 
install.packages("dplyr",repos = "http://cran.us.r-project.org")

# package exec
library(readxl)
library(ggplot2)
library(dplyr)

# data import
path <- read_excel("~/desktop/world-cup-scraping/data.xlsx")
sheetnames <- excel_sheets(path)
data <- lapply(excel_sheets(path), read_excel, path = path)
names(data) <- sheetnames


# evolucao do brasil no ranking

# maiores autor de gol pela selecao

# selecoes que o brasil mais jogou contra

# selecoes que o brasil mais perdeu

# selecoes que o brasil mais ganhou

# selecoes que o brasil mais goleou

# selecoes que o brasil mais goleou em um unico jogo

# selecoes que o brasil mais sofreu gol

# selecoes que o brasil mais sofreu gol em um unico jogo

