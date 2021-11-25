library(rvest)
library(dplyr)

link = "https://store.steampowered.com/stats/"
page = read_html(link)

game_title = page %>% html_nodes(".gameLink") %>% html_text()
game_link = page %>% html_nodes(".gameLink") %>%
  html_attr("href")

peak_today = page %>% html_nodes("td+ td .currentServers") %>% html_text()
current_players = page %>% html_nodes("td:nth-child(1) .currentServers") %>% html_text()

get_description = function(game_link){
  game_page = read_html(game_link)
  game_description = game_page %>% html_nodes(".game_description_snippet") %>% 
    html_text() %>% paste(collapse = ",")
  return(game_description)
}

get_date = function(game_link){
  #game_link = "https://store.steampowered.com/app/730/CounterStrike_Global_Offensive/" #for testing purposes
  game_page1 = read_html(game_link)
  game_date = game_page1 %>% html_nodes(".date") %>%
    html_text() %>% paste(collapse = ",")
  return(game_date)
}

get_review = function(game_link){
  #game_link = "https://store.steampowered.com/app/570/Dota_2/"
  game_page2 = read_html(game_link)
  game_review = game_page2 %>% html_nodes(".user_reviews_summary_row:nth-child(1) .positive") %>%
    html_text() %>% paste(collapse = ",")
  return(game_review)
}

description = sapply(game_link, FUN = get_description, USE.NAMES = FALSE)
date = sapply(game_link, FUN = get_date, USE.NAMES = FALSE)
review = sapply(game_link, FUN = get_review, USE.NAMES = FALSE)

games = data.frame(game_title, peak_today, current_players, description, date, review, stringsAsFactors = FALSE)
games_simple = data.frame(game_title, peak_today, current_players, stringAsFactors = FALSE)
View(games_simple)
View(games)
write.csv(games_simple, "games_simple.csv")

