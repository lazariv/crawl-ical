library(dplyr)
library(calendar)

class(ical_example)
ic <- ical(ical_example)
ic %>% View()

# example
s = as.POSIXct("2020-07-19 09:00")
e = s + 60^2 * 2
event = ic_event(start_time=s, end_time=e , summary="Some test event", more_properties=TRUE, 
                 event_properties=c(LOCATION="Palais Sommer", DESCRIPTION="some long text blabla blabla"))
event
class(event)
ic_character(event)

# crawl all the events on the webpage
source("crawl_events.R")

create_event = function(x) {
#  temp <<- x
  ic_event(start_time=x["date_start"], end_time=x["date_end"], summary=x["event_summary"])
}

cal = apply(X=events, FUN=create_event, MARGIN=1) %>% bind_rows()
ic_write(ic=ical(cal), file="yoga.ics")

temp = ic_read("yoga.ics")
