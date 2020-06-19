library(dplyr)
library(rvest)
library(lubridate)

url_yoga = "https://palaissommer.de/programm/kategorie/yoga-im-park/"
url_vector = c(url_yoga, paste0(url_yoga, c("?pno=2", "?pno=3", "?pno=4")))

extract_events = function(url){
  x = url %>% read_html()

  time_field = x %>% html_node(".css-events-list") %>% html_nodes(".em-date") %>% html_text(trim=TRUE) %>% as.POSIXct(format="%d.%m.%y %H:%M", tz="CEST")
  event_field = x %>% html_node(".css-events-list") %>% html_nodes(".em-info") %>% html_node("span a") %>% html_text(trim=TRUE)

  events = data.frame(date_start = time_field, event_summary = event_field, stringsAsFactors=FALSE) %>% filter(year(date_start)==2020)
  events = events %>% mutate(date_end = date_start + 60^2) %>% select(starts_with("date"), everything())

  return(events)
}

events = lapply(X=url_vector, FUN=extract_events) %>% bind_rows()
#events %>% typeof()
#as.list(as.data.frame(t(events)))