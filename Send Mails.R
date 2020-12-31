mm = read_csv("~/Downloads/Mail Merge - Sheet1.csv")

library(gmailr)
gm_auth_configure(path = "CLab.json")

makemail = function(recipient,msg){
    mail = gm_mime() %>%
    gm_to(recipient) %>%
    gm_from("blira@characterlab.org") %>%
    gm_subject("Your personalized Grit Lab Report") %>%
    gm_text_body(msg)
    return(mail)
}
  
mm %>% 
  filter(!is.na(`Email Address`)) %>% 
  mutate(msg = glue::glue("Hi {First},

                          Below is a link to a personalized feedback report we built using all the data you gave us on Poll Everywhere, during class. To ensure privacy the file is password protected: your password is {Pass}.
                          Here is the link:

                          {Url}

                          We hope this will help you reflect on the class!

                          Best wishes for 2021,
                          The Grit Lab Team")) %>% 
  mutate(mail = map2(`Email Address`,msg,makemail),
         sent = map(mail,gm_send_message))
