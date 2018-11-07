global without sharing class Util 
{
    global static List <SelectOption> GetPicklistValues(SObject entity, String field)
    {
        List <SelectOption> options = new List <SelectOption> ();

        Schema.sObjectType objectType = entity.getSObjectType(); 
        Schema.DescribeSObjectResult objectDescription = objectType.getDescribe();       

        Map <String, Schema.SObjectField> fieldMap = objectDescription.fields.getMap(); 

        List <Schema.PicklistEntry> values = fieldMap.get(field).getDescribe().getPickListValues();

        for(Schema.PicklistEntry value : values)
        { 
            options.add(new SelectOption(value.getValue(), value.getLabel())); 
        }

        return options;
    }

    global static PageReference RedirectTo(String url)
    {
        PageReference nextLocation = new PageReference(url);
        nextLocation.setRedirect(true);
        return nextLocation;
    }

    global static PageReference RedirectTo(Id objectId)
    {
        return redirectTo('/' + objectId);
    }
    
    global static String SentenceCase(String text)
    {
        List <String> collection = text.split(' ');
        List <String> newCollection = new List <String> ();
        
        for(String word : collection)
        {
            newCollection.add(word.capitalize());
        }
        
        return String.join(newCollection, ' ');
    }
}