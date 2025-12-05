#Импорт необходимых для работы библиотек
library(tidyverse)
library(lavaan)
library(semTools)
library(semPlot)

ncol(df)

df <- df %>% 
  select(-(1:7))  # удаляет столбцы со 1-го по 7-й

df <- df %>% 
  slice(-1)

df <- df %>% 
  select(-(123:129))

df_dop <- df_n %>% 
  filter(Q7p == 1 & Q10g == 4 & Q13m == 5)

table(df_n$Q14_3_text)

df_n <- df_n %>% 
  filter(Q14_3_text != "дельфин")

df_n <- df_n %>% 
  select(-Q14_3_text, -Q16_2_text)

write.csv(df_n, "with_corruption.csv", row.names = FALSE)

which(names(df_n) == "Q12a")

df_without_c <- df_n %>% 
  select(-(99:110))
  
df_without_c <- df_without_c %>% 
  select(-(82:98))

write.csv(df_without_c, "with_q9-q11.csv", row.names = FALSE)
