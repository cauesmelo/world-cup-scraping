###############################################################################
#### Packages
###############################################################################

# Package install
install.packages("readxl",repos = "http://cran.us.r-project.org") 
install.packages("ggplot2",repos = "http://cran.us.r-project.org") 
install.packages("dplyr",repos = "http://cran.us.r-project.org")
install.packages("lubridate",repos = "http://cran.us.r-project.org")

# Package exec
library(RColorBrewer)
library(readxl)
library(ggplot2)
library(dplyr)
library(lubridate)

###############################################################################
## Data import
###############################################################################
# ref: https://stackoverflow.com/questions/12945687/read-all-worksheets-in-an-excel-workbook-into-an-r-list-with-data-frames
read_excel_allsheets <- function(filename, tibble = FALSE) {
  # I prefer straight data.frames
  # but if you like tidyverse tibbles (the default with read_excel)
  # then just pass tibble = TRUE
  sheets <- readxl::excel_sheets(filename)
  x <- lapply(sheets, function(X) readxl::read_excel(filename, sheet = X))
  if(!tibble) x <- lapply(x, as.data.frame)
  names(x) <- sheets
  x
}

# carregando sheets p uma lista
fifa <- read_excel_allsheets("~/desktop/world-cup-scraping/data.xlsx")

# tratando possíveis duplicatas
cup_info <- fifa$cup_info %>% distinct()
match_info <- fifa$match_info %>% distinct()
goal_info <- fifa$goal_info %>% distinct()
rank_info <- fifa$rank_info %>% distinct()
# percebi que umas 2 páginas do site da fifa tavam duplicando o conteudo
# achei melhor tratar as duplicatas dessa forma no R



###############################################################################
## Maiores autores de gol pela selecao
###############################################################################
# filtro somente os gols a favor e coloco num data frame
pro_goals <- goal_info %>% filter(pro == TRUE)

# agrupo por nome e realizo uma contagem de ocorrencias
goal_authors <- pro_goals %>%
  group_by(player) %>%
  summarise(n = n())

# ordeno do maior pro menor
goal_authors <- goal_authors %>%
  arrange(desc(n))

# seleciono os 15 primeiros da lista
goal_authors <- head(goal_authors, 10)

# ploto
goal_authors %>%
  # ordeno pela qtd de gols, preencho pela qtd de gols
  ggplot(aes(reorder(player, n), n, fill = as.factor(n))) +
  geom_bar(stat = 'identity') + 
  # ajusto legendas
  labs(x = "Jogador", y = "Qtd. Gols", fill = "Qtd.Gols") + 
  # seto escala de cor
  scale_color_discrete() +
  # coloco escala do maior pro menor
  guides(fill = guide_legend(reverse = TRUE)) +
  # rotaciono legenda do x
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  ggtitle("Maiores goleadores")
###############################################################################
## Jogadores que mais fizeram gol na seleção brasileira
###############################################################################

# filtro somente os gols a favor e coloco num data frame
con_goals <- goal_info %>% filter(pro == FALSE)

# agrupo por nome e realizo uma contagem de ocorrencias
con_goal_authors <- con_goals %>%
  group_by(player) %>%
  summarise(n = n())

# ordeno do maior pro menor
con_goal_authors <- con_goal_authors %>%
  arrange(desc(n))

# seleciono os 15 primeiros da lista
con_goal_authors <- head(con_goal_authors, 10)

# ploto
con_goal_authors %>%
  # ordeno pela qtd de gols, preencho pela qtd de gols
  ggplot(aes(reorder(player, n), n, fill = as.factor(n))) +
  geom_bar(stat = 'identity') + 
  # ajusto legendas
  labs(x = "Jogador", y = "Qtd. Gols", fill = "Qtd.Gols") + 
  # seto escala de cor
  scale_color_discrete() +
  # coloco escala do maior pro menor
  guides(fill = guide_legend(reverse = TRUE)) +
  # rotaciono legenda do x
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + 
  ggtitle("Jogadores que mais fizeram gol no Brasil")

###############################################################################
##### Evolucao do brasil no ranking FIFA
###############################################################################
# coverto a data p um formato entendivel pelo r
rank_info$date <- dmy(rank_info$date)

# ordeno pela data
rank_info <- rank_info %>%
  arrange(date)

# ploto
rank_info %>%
  ggplot(aes(date, reorder(rank, desc(as.numeric(rank))), group = 1)) +
  geom_line(linetype = "solid", color = "steelblue") +
  labs(x = "Data", y = "Posição") + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  ggtitle("Evolução do Brasil no Ranking FIFA") +
  scale_x_date(date_breaks = "12 month", date_labels ="%Y") 


###############################################################################
## Selecoes que o brasil mais jogou contra
###############################################################################
# agrupo por nome e realizo uma contagem de ocorrencias
oponent_count <- match_info %>%
  group_by(versus) %>%
  summarise(n = n())

# ordeno do maior pro menor
oponent_count <- oponent_count %>%
  arrange(desc(n))

# seleciono os 10 primeiros da lista
oponent_count <- head(oponent_count, 10)

# ploto
oponent_count %>%
  # ordeno pela qtd de gols, preencho pela qtd de gols
  ggplot(aes(reorder(versus, n), n, fill = as.factor(n))) +
  geom_bar(stat = 'identity') + 
  # ajusto legendas
  labs(x = "Seleção", y = "Qtd. de jogos", fill = "Qtd. de jogos") + 
  # seto escala de cor
  scale_color_discrete() +
  # coloco escala do maior pro menor
  guides(fill = guide_legend(reverse = TRUE)) +
  # rotaciono legenda do x
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  ggtitle("Seleções que mais jogaram contra o Brasil")


## Selecoes que o brasil mais perdeu
lost_matches <- match_info %>% filter(result == "lose")

lost_matches <- lost_matches %>%
  group_by(versus) %>%
  summarise(n = n())

# ordeno do maior pro menor
lost_matches <- lost_matches %>%
  arrange(desc(n))

# seleciono os 10 primeiros da lista
lost_matches <- head(lost_matches, 10)

# ploto
lost_matches %>%
  # ordeno pela qtd de gols, preencho pela qtd de gols
  ggplot(aes(reorder(versus, n), n, fill = as.factor(n))) +
  geom_bar(stat = 'identity') + 
  # ajusto legendas
  labs(x = "Seleção", y = "Qtd. derrotas", fill = "Qtd. derrotas") + 
  # seto escala de cor
  scale_color_discrete() +
  # coloco escala do maior pro menor
  guides(fill = guide_legend(reverse = TRUE)) +
  # rotaciono legenda do x
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  ggtitle("Seleções que mais derrotaram o Brasil")

###############################################################################
## Selecoes que o brasil mais ganhou
###############################################################################
win_matches <- match_info %>% filter(result == "win")

win_matches <- win_matches %>%
  group_by(versus) %>%
  summarise(n = n())

# ordeno do maior pro menor
win_matches <- win_matches %>%
  arrange(desc(n))

# seleciono os 10 primeiros da lista
win_matches <- head(win_matches, 10)

# ploto
win_matches %>%
  # ordeno pela qtd de gols, preencho pela qtd de gols
  ggplot(aes(reorder(versus, n), n, fill = as.factor(n))) +
  geom_bar(stat = 'identity') + 
  # ajusto legendas
  labs(x = "Seleção", y = "Qtd. vitórias", fill = "Qtd. vitórias") + 
  # seto escala de cor
  scale_color_discrete() +
  # coloco escala do maior pro menor
  guides(fill = guide_legend(reverse = TRUE)) +
  # rotaciono legenda do x
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  ggtitle("Seleções que mais perderam para o Brasil")

###############################################################################
## Selecoes que o brasil mais fez gols
###############################################################################
# mergeio as duas tabelas pelo match_id
goals_pro_teams <- merge(goal_info, match_info, by="match_id")
#filtro para gols pro
goals_pro_teams <- goals_pro_teams %>% filter(pro == TRUE)

# agrupo e conto ocorrencias
goals_pro_teams <- goals_pro_teams %>%
  group_by(versus) %>%
  summarise(n = n())

# ordeno do maior pro menor
goals_pro_teams <- goals_pro_teams %>%
  arrange(desc(n))

# seleciono os 10 primeiros da lista
goals_pro_teams <- head(goals_pro_teams, 10)

# ploto
goals_pro_teams %>%
  # ordeno pela qtd de gols, preencho pela qtd de gols
  ggplot(aes(reorder(versus, n), n, fill = as.factor(n))) +
  geom_bar(stat = 'identity') + 
  # ajusto legendas
  labs(x = "Seleção", y = "Qtd. de gols", fill = "Qtd. de gols") + 
  # seto escala de cor
  scale_color_discrete() +
  # coloco escala do maior pro menor
  guides(fill = guide_legend(reverse = TRUE)) +
  # rotaciono legenda do x
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + 
  ggtitle("Seleções que mais sofreram gol do Brasil")

###############################################################################
## Selecoes que o brasil mais fez gols em um unico jogo
###############################################################################
# mergeio as duas tabelas pelo match_id
goals_pro_teams <- merge(goal_info, match_info, by="match_id")
#filtro para gols pro
goals_pro_teams <- goals_pro_teams %>% filter(pro == TRUE)

# agrupo e conto ocorrencias
goals_pro_teams <- goals_pro_teams %>%
  group_by(match_id) %>%
  summarise(n = n())

goals_pro_teams <- left_join(goals_pro_teams, match_info, by = "match_id")

# ordeno do maior pro menor
goals_pro_teams <- goals_pro_teams %>%
  arrange(desc(n))

# seleciono os 10 primeiros da lista
goals_pro_teams <- head(goals_pro_teams, 10)

# ploto
goals_pro_teams %>%
  # ordeno pela qtd de gols, preencho pela qtd de gols
  ggplot(aes(reorder(versus, n), n, fill = as.factor(n))) +
  geom_bar(stat = 'identity', position = "dodge") + 
  # ajusto legendas
  labs(x = "Seleção", y = "Qtd. de gols", fill = "Qtd. de gols") + 
  # seto escala de cor
  scale_color_discrete() +
  # coloco escala do maior pro menor
  guides(fill = guide_legend(reverse = TRUE)) +
  # rotaciono legenda do x
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + 
  ggtitle("Seleções que mais sofreram gol do Brasil em único jogo")

###############################################################################
## Selecoes que o brasil mais sofreu gol
###############################################################################
# mergeio as duas tabelas pelo match_id
goals_con_teams <- merge(goal_info, match_info, by="match_id")
#filtro para gols pro
goals_con_teams <- goals_con_teams %>% filter(pro == FALSE)

# agrupo e conto ocorrencias
goals_con_teams <- goals_con_teams %>%
  group_by(versus) %>%
  summarise(n = n())

# ordeno do maior pro menor
goals_con_teams <- goals_con_teams %>%
  arrange(desc(n))

# seleciono os 10 primeiros da lista
goals_con_teams <- head(goals_con_teams, 10)

# ploto
goals_con_teams %>%
  # ordeno pela qtd de gols, preencho pela qtd de gols
  ggplot(aes(reorder(versus, n), n, fill = as.factor(n))) +
  geom_bar(stat = 'identity') + 
  # ajusto legendas
  labs(x = "Seleção", y = "Qtd. de gols", fill = "Qtd. de gols") + 
  # seto escala de cor
  scale_color_discrete() +
  # coloco escala do maior pro menor
  guides(fill = guide_legend(reverse = TRUE)) +
  # rotaciono legenda do x
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + 
  ggtitle("Seleções que mais fizeram gol no Brasil")


###############################################################################
#################Selecoes que o brasil mais sofreu gol em um unico jogo
###############################################################################
# mergeio as duas tabelas pelo match_id
goals_con_teams <- merge(goal_info, match_info, by="match_id")
#filtro para gols pro
goals_con_teams <- goals_con_teams %>% filter(pro == FALSE)

# agrupo e conto ocorrencias
goals_con_teams <- goals_con_teams %>%
  group_by(match_id) %>%
  summarise(n = n())

goals_con_teams <- left_join(goals_con_teams, match_info, by = "match_id")

# ordeno do maior pro menor
goals_con_teams <- goals_con_teams %>%
  arrange(desc(n))

# seleciono os 10 primeiros da lista
goals_con_teams <- head(goals_con_teams, 10)

# ploto
goals_con_teams %>%
  # ordeno pela qtd de gols, preencho pela qtd de gols
  ggplot(aes(reorder(versus, n), n, fill = as.factor(n))) +
  geom_bar(stat = 'identity', position = "dodge") + 
  # ajusto legendas
  labs(x = "Seleção", y = "Qtd. de gols", fill = "Qtd. de gols") + 
  # seto escala de cor
  scale_color_discrete() +
  # coloco escala do maior pro menor
  guides(fill = guide_legend(reverse = TRUE)) +
  # rotaciono legenda do x
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + 
  ggtitle("Seleções que mais fizeram gol no Brasil em único jogo")

###############################################################################
################# Estadios que o brasil mais jogou
###############################################################################
# agrupo por nome e realizo uma contagem de ocorrencias
stadium_count <- match_info %>%
  group_by(stadium) %>%
  summarise(n = n())

# ordeno do maior pro menor
stadium_count <- stadium_count %>%
  arrange(desc(n))

# seleciono os 10 primeiros da lista
stadium_count <- head(stadium_count, 10)

# ploto
stadium_count %>%
  # ordeno pela qtd de gols, preencho pela qtd de gols
  ggplot(aes(reorder(stadium, n), n, fill = as.factor(n))) +
  geom_bar(stat = 'identity') + 
  # ajusto legendas
  labs(x = "Estádio", y = "Qtd. de jogos", fill = "Qtd. de jogos") + 
  # seto escala de cor
  scale_color_discrete() +
  # coloco escala do maior pro menor
  guides(fill = guide_legend(reverse = TRUE)) +
  # rotaciono legenda do x
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  ggtitle("Estádios que o Brasil mais jogou")


###############################################################################
################# Evolução de média de gols por copa
###############################################################################
# primeiro pegamos o total de gols na copa
cup_goals <- merge(goal_info, cup_info, by="cup_id")

cup_goals <- cup_goals %>% filter(pro == TRUE)

cup_goals <- cup_goals %>%
  group_by(cup_id) %>%
  summarise(n_goals = n())

cup_goals <- left_join(cup_goals, cup_info, by = "cup_id")

# agora pegamos o total de partidas na copa
cup_matches <- merge(match_info, cup_info, by="cup_id")

cup_matches <- cup_matches %>%
  group_by(cup_id) %>%
  summarise(n_matches = n())

# juntamos as duas tabelas
cup_goals <- merge(cup_goals, cup_matches, by ="cup_id")

# criamos uma outra coluna com a media de gols
cup_goals$mean <- (cup_goals$n_goals / cup_goals$n_matches)

cup_goals %>%
  # ordeno pela qtd de gols, preencho pela qtd de gols
  ggplot(aes(year, mean, group = 1)) +
  geom_line(linetype = "dashed") +
  geom_point() + 
  # ajusto legendas
  labs(x = "Ano", y = "Média de gols") + 
  # seto escala de cor
  # coloco escala do maior pro menor
  # rotaciono legenda do x
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  ggtitle("Média de gols feitos por edição")


###############################################################################
################# Media de gols sofridos
###############################################################################
# primeiro pegamos o total de gols na copa
cup_goals <- merge(goal_info, cup_info, by="cup_id")

cup_goals <- cup_goals %>% filter(pro == FALSE)

cup_goals <- cup_goals %>%
  group_by(cup_id) %>%
  summarise(n_goals = n())

cup_goals <- left_join(cup_goals, cup_info, by = "cup_id")

# agora pegamos o total de partidas na copa
cup_matches <- merge(match_info, cup_info, by="cup_id")

cup_matches <- cup_matches %>%
  group_by(cup_id) %>%
  summarise(n_matches = n())

# juntamos as duas tabelas
cup_goals <- merge(cup_goals, cup_matches, by ="cup_id")

# criamos uma outra coluna com a media de gols
cup_goals$mean <- (cup_goals$n_goals / cup_goals$n_matches)

cup_goals %>%
  # ordeno pela qtd de gols, preencho pela qtd de gols
  ggplot(aes(year, mean, group = 1)) +
  geom_line(linetype = "dashed") +
  geom_point() + 
  # ajusto legendas
  labs(x = "Ano", y = "Média de gols") + 
  # seto escala de cor
  # coloco escala do maior pro menor
  # rotaciono legenda do x
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  ggtitle("Média de gols sofridos por edição")

