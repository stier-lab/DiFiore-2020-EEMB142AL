swirl_options(swirl_logging = TRUE)


# For compatibility with 2.2.21
.get_course_path <- function(){
  tryCatch(swirl:::swirl_courses_dir(),
           error = function(c) {file.path(find.package("swirl"),"Courses")}
  )
}

# Path to data
.datapath <- file.path(.get_course_path(),
                      'DiFiore-2020-EEMB142AL', 'Working_with_data',
                      'Biocom_pred_prey_diet.csv')

#-----------------------------------------------------
## Clean the North Temperate Lakes LTER data 
#-----------------------------------------------------
library(tidyverse)

fish <- read.csv(.datapath, na.strings ="na") %>% 
  as_tibble() %>%
  rename_all(tolower) %>% 
  select(year, sampledate, species, gutlabel, length, weight, starts_with("net_wt_")) %>%
  mutate_at(vars(starts_with("net_wt_"), "length", "weight"), as.numeric) %>%
  rowwise() %>%
  mutate(total = sum(c_across(net_wt_odonata:net_wt_terrestrial_inverts), na.rm = T), 
         net_wt_fish = sum(c_across(c(net_wt_fish,net_wt_smelt, net_wt_bluntnose, net_wt_mimicshiner, net_wt_other_fish)), na.rm = T), 
         net_wt_other = net_wt_odonata + net_wt_ephemeroptera + net_wt_diptera + net_wt_trichoptera  + net_wt_hemiptera + net_wt_cladocera + net_wt_hydrocarina + net_wt_coleopterans + net_wt_amphipod + net_wt_emergent_aquatics + net_wt_terrestrial_inverts) %>%
  select(year, sampledate, species, gutlabel, length, weight, total, net_wt_fish, net_wt_crayfish, net_wt_other) %>%
  ungroup()

fish <- as.data.frame(fish)


