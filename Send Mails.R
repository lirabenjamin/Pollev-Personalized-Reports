mm = read_csv("~/Downloads/Mail Merge - Sheet1.csv")

library(gmailr)
gm_auth_configure(path = "~/Desktop/CLab.json")

makemail = function(recipient,msg){
    mail = gm_mime() %>%
    gm_to(recipient) %>%
    gm_from("blira@characterlab.org") %>%
    gm_subject("Corrigendum: Your personalized Grit Lab Report") %>%
    gm_html_body(msg)
    return(mail)
}
  
sent = mm %>% 
  filter(!is.na(`Email Address`)) %>% 
  mutate(msg = glue::glue("<html>
                          <p>Hi {First},</p>

                          <p>On Thursday, we sent you a link to your personalized Grit Lab report. There was an issue with the data, and some of the location graphs were inaccurate. We have now fixed that.</p>

                          <p><a href=\"{Url}\" target=\"_blank\">Click here</a> to see your report. Your password is {Pass}.</p>


                          <p>Sorry for the inconvenience,</p>

                          <p>Best wishes for 2021,</p>
                          <p>The Grit Lab Team</p>

<p>Here is the url if the link doesn't work: {Url}</p>
                          </html>")) %>% 
  mutate(mail = map2(`Email Address`,msg,makemail),
         sent = map(mail,gm_send_message))

sent$sent