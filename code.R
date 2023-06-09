
# Load libraries
library("papaja")
library("tidyverse")
library("ds4ling")
library(here)


# Load data
attitude_raw <- read.csv(here("data_raw","attitude_data.csv"))


# Visualize data
head(attitude_raw)
glimpse(attitude_raw)
summary(attitude_raw)


# Tidy data
attitude_tidy <- attitude_raw %>%
  separate(
    col = id,
    into = c("id", "group", "gender"),
    sep = "_"
  ) %>%
  write_csv(here("data_tidy", "attitude_tidy.csv"))



# Create variables
attitude_final <- attitude_tidy %>%
  rowwise() %>% 
  mutate(warmth_total = mean(c(warmth_friendly, warmth_likeable, warmth_helpful))) %>%
  mutate(competence_total = mean(c(competence_intelligent, competence_successful, competence_ambitious))) %>%
  relocate(warmth_total, .after = competence_ambitious) %>%
  relocate(competence_total, .after = warmth_total) %>%
  write_csv(here("data_tidy", "attitude_final.csv"))

str(attitude_final)



# Descriptive Stats
attitude_final %>%
  group_by(group) %>% 
  summarize(
    mean_proficiency = mean(proficiency),
    median_proficiency = median(proficiency),
    sd_proficiency = sd(proficiency),
    min_proficiency = min(proficiency),
    max_proficiency = max(proficiency),
  ) %>%
  knitr::kable(
    caption = "Descriptive Stats for Proficiency by Group.",
    col.names = c("Group", "Mean", "Median", "Sd", "Min", "Max")
  )


attitude_final %>%
  group_by(group, edu) %>% 
  summarize(
    mean_proficiency = mean(proficiency),
    median_proficiency = median(proficiency),
    sd_proficiency = sd(proficiency),
    min_proficiency = min(proficiency),
    max_proficiency = max(proficiency),
  ) %>%
  knitr::kable(
    caption = "Descriptive Stats for Proficiency by Group and Education.",
    col.names = c("Group", "Education", "Mean", "Median", "Sd", "Min", "Max")
  )


attitude_final %>%
  group_by(group) %>% 
  summarize(
    mean_warmth_total = mean(warmth_total),
    median_warmth_total = median(warmth_total),
    sd_warmth_total = sd(warmth_total),
    min_warmth_total = min(warmth_total),
    max_warmth_total = max(warmth_total),
  ) %>%
  knitr::kable(
    caption = "Descriptive Stats for Warmth by Group.",
    col.names = c("Group", "Mean", "Median", "Sd", "Min", "Max")
  )


attitude_final %>%
  group_by(group, edu) %>% 
  summarize(
    mean_warmth_total = mean(warmth_total),
    median_warmth_total = median(warmth_total),
    sd_warmth_total = sd(warmth_total),
    min_warmth_total = min(warmth_total),
    max_warmth_total = max(warmth_total),
  ) %>%
  knitr::kable(
    caption = "Descriptive Stats for Warmth by Group and Education.",
    col.names = c("Group", "Education", "Mean", "Median", "Sd", "Min", "Max")
  )


attitude_final %>%
  group_by(group) %>% 
  summarize(
    mean_competence_total = mean(competence_total),
    median_competence_total = median(competence_total),
    sd_competence_total = sd(competence_total),
    min_competence_total = min(competence_total),
    max_competence_total = max(competence_total),
  ) %>%
  knitr::kable(
    caption = "Descriptive Stats for Competence by Group.",
    col.names = c("Group", "Mean", "Median", "Sd", "Min", "Max")
  )


attitude_final %>%
  group_by(group, edu) %>% 
  summarize(
    mean_competence_total = mean(competence_total),
    median_competence_total = median(competence_total),
    sd_competence_total = sd(competence_total),
    min_competence_total = min(competence_total),
    max_competence_total = max(competence_total),
  ) %>%
  knitr::kable(
    caption = "Descriptive Stats for Competence by Group and Education.",
    col.names = c("Group", "Education", "Mean", "Median", "Sd", "Min", "Max")
  )


attitude_final %>%
  group_by(group) %>% 
  summarize(
    mean_age = mean(age),
    sd_age = sd(age))


# Plots
# plot1
attitude_final %>% 
  ggplot() + 
  aes(x = group, y = warmth_total) + 
  geom_boxplot() +
  labs(x = "Group", y = "Warmth",
       title = "Warmth by Group")

# No hay diferencias entre grupos en cuanto a la percepción del castellano en
# términos de warmth.

# plot2
attitude_final %>% 
  ggplot() + 
  aes(x = group, y = competence_total) + 
  geom_boxplot() +
  labs(x = "Group", y = "Competence",
       title = "Competence by Group")

# Hay diferencias entre grupos en cuanto a la percepción del castellano en
# términos de competence. Los monolingües valoran más positivamente esta 
# variedad que los hablantes de herencia en cuanto a inteligencia, éxito y 
# ambición.

# plot3
attitude_final %>% 
  ggplot() + 
  aes(x = group, y = warmth_total) + 
  facet_grid(. ~ edu) +
  geom_boxplot() +
  labs(x = "Education", y = "Warmth",
       title = "Warmth by Education and Group")

# El descriptive stats ya nos aporta esta info, pero el plot es más visual.
# No hay diferencias entre grupos en cuanto a la percepción del castellano
# en términos de warmth. Sin embargo, vemos que hay bastante variabilidad de
# opiniones en los participantes que han hecho una carrera en comparación con
# los que solo han estudiado en el instituto. 


# plot4
attitude_final %>% 
  ggplot() + 
  aes(x = proficiency, y = warmth_total, color = group) + 
  geom_point() +
  geom_smooth(method = lm) +
  labs(x = "Proficiency", y = "Warmth",
       title = "Warmth by Proficiency and Group")

# Otra vez, la tendencia entre grupos es parecida, aunque aquí vemos que los
# monolingües tienen, en general, más proficiencia en español. No obstante, los
# puntos de datos están muy dispersos y no siguen la línea, por lo que podríamos
# pensar (es probable) que no hay una correlación entre proficiency y percepción # en términos de warmth. Esto se deberá 
# analizar en el modelo. 

# plot5
attitude_final %>% 
  ggplot() + 
  aes(x = group, y = competence_total) + 
  facet_grid(. ~ edu) +
  geom_boxplot() +
  labs(x = "Education", y = "Competence",
       title = "Competence by Education and Group")

# Los monolingües valoran más positivamente el castellano en términos de 
# competence comparado con los hablantes de herencia, por lo que hay una 
# diferencia entre grupos. El modelo nos va a decir si esta diferencia es 
# significativa o no. Asimismo, y como ha pasado con warmth pero en niveles 
# opuestos, vemos que hay bastante variabilidad de opiniones en los 
# participantes que solo han estudiado en el instituto comparado con los que 
# han hecho un máster o un doctorado, que tienen opiniones más parecidas. 

# plot 6
attitude_final %>% 
  ggplot() + 
  aes(x = proficiency, y = competence_total, color = group) + 
  geom_point() +
  geom_smooth(method = lm) +
  labs(x = "Proficiency", y = "Competence",
       title = "Competence by Proficiency and Group")

# Parece que hay una tendencia opuesta entre grupos. En los monolingües, cuanto
# más proficiencia en español, se valora más positivamente la propia variedad 
# en términos de competence (correlación positiva). En el caso de los hablantes
# de herencia, esta tendencia es contraria (correlación negativa). Es posible 
# que proficiency no tenga ningún efecto sobre competence. Esto se tiene que 
# mirar en nuestro modelo. 

# plot7
attitude_final %>% 
  ggplot() + 
  aes(x = edu, y = competence_total) + 
  geom_boxplot() +
  labs(x = "Education", y = "Competence",
       title = "Competence by Education")

# Parece que hay diferencias en la valoración de la propia variedad en términos 
# de competence en función del nivel educativo.

# plot 8
attitude_final %>% 
  ggplot() + 
  aes(x = proficiency, y = competence_total) + 
  geom_point() +
  geom_smooth(method = lm) +
  labs(x = "Proficiency", y = "Competence",
       title = "Competence by Proficiency")

# Parece que, cuanta más proficiencia, hay cierta tendencia a valorar más
# positivamente a la propia variedad en términos de competence. 

# plot9
attitude_final %>% 
  ggplot() + 
  aes(x = edu, y = warmth_total) + 
  geom_boxplot() +
  labs(x = "Education", y = "Warmth",
       title = "Warmth by Education")

# Parece que hay diferencias en la valoración de la propia variedad en términos 
# de warmth en función del nivel educativo, pero es menor que en competence.

# plot10
attitude_final %>% 
  ggplot() + 
  aes(x = proficiency, y = warmth_total) + 
  geom_point() +
  geom_smooth(method = lm) +
  labs(x = "Proficiency", y = "Warmth",
       title = "Warmth by Proficiency")

# Parece que proficiency no afecta a cómo se valora la propia variedad en 
# términos de warmth. 



# ¿Qué hemos observado hasta ahora?
# 1. Parece que no hay diferencias entre grupos en cuanto a la percepción del 
# castellano en términos de warmth, pero sí de competence. El modelo nos va a 
# decir si esta diferencia de percepción del castellano en términos de 
# competence es significativa.
# 2. Es posible que proficiency no afecte a la percepción del castellano, pero 
# se debe mirar en el modelo.
# 3. Puede ser que el nivel educativo afecte a la percepción del castellano. 
# Asimismo, hay bastante variabilidad individual entre niveles educativos. Esto
# se debe mirar en el modelo.
# 4. El modelo nos dirá si la pertenencia de grupo, la proficiencia en español 
# y el nivel educativo tienen algún impacto en la percepción del castellano en 
# términos de warmth y competence.




# Analysis

# Models (warmth)
model_w0 <- lm(warmth_total ~ 1, data = attitude_final)
model_w1 <- lm(warmth_total ~ group, data = attitude_final)
model_w2 <- lm(warmth_total ~ group + proficiency, data = attitude_final)
model_w3 <- lm(warmth_total ~ group + proficiency + edu, data = attitude_final)

# Main effects testing (warmth)
anova(model_w0, model_w1, model_w2, model_w3)

summary(model_w0)
summary(model_w1)
summary(model_w2)
summary(model_w3)


# Models - Prof. (warmth)
model_wn0 <- lm(warmth_total ~ 1, data = attitude_final)
model_wn1 <- lm(warmth_total ~ proficiency, data = attitude_final)
model_wn2 <- lm(warmth_total ~ proficiency + group, data = attitude_final)
model_wn3 <- lm(warmth_total ~ proficiency + group + edu, data = attitude_final)

# Main effects testing - Prof. (warmth)
anova(model_wn0, model_wn1, model_wn2, model_wn3)

summary(model_wn1)


# Summary and assumptions of the best model (warmth)
summary(model_w2)
diagnosis(model_w2)



# Models (competence)
model_c0 <- lm(competence_total ~ 1, data = attitude_final)
model_c1 <- lm(competence_total ~ group, data = attitude_final)
model_c2 <- lm(competence_total ~ group + proficiency, data = attitude_final)
model_c3 <- lm(competence_total ~ group + proficiency + edu, data = attitude_final)

# Main effects testing (competence)
anova(model_c0, model_c1, model_c2, model_c3)

# Summary and assumptions of the best model (competence)
summary(model_c1)
diagnosis(model_c1)







