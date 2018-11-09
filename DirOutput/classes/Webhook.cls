public without sharing class Webhook
{
    public static String AsJson(List<Object> TriggerNew, List<Object> TriggerOld)
    {
        String NewObjects = '[]';
        if (TriggerNew != null)
        {
            NewObjects = JSON.serialize(TriggerNew);
        }

        String OldObjects = '[]';
        if (TriggerOld != null)
        {
            OldObjects = JSON.serialize(TriggerOld);
        }

        String UserId = JSON.serialize(UserInfo.getUserId());

        String Content = '{"new": ' + NewObjects + ', "old": ' + OldObjects + ', "userId": ' + userId + '}';
        return Content;
    }

    public static void TriggerSlackAlert(String payload)
    {
        SendRequest(Slack.WebhookDestination, Slack.PayloadAsString(payload));
    }
    
    public static void TriggerSlackAlert(Map <String, Object> payload)
    {
        
            SendRequest(Slack.WebhookDestination, JSON.serialize(payload));
        
    }
    
    @future(callout = true)
    public static void SendRequest(String Url, String Content)
    {
        Http WebDriver = new Http();

        HttpRequest request = new HttpRequest();
        request.setEndpoint(Url);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(Content);
        request.setTimeout(120000);
        HttpResponse response = WebDriver.send(request);
        
        if(response.getStatusCode() != 200){throw new RuntimeException('Webhook callout request was not handled properly by ' + url + ' - Error (' + response.getBody() + ') - Tried to send payload (' + Content + ')');}
    }
}