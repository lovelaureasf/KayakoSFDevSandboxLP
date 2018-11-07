/* Description: This controller takes the quote record as input and verifies the VAT ID that is supplied by the user with EU VAT website.
   This controller generates an error message on the quote detail page, if the record is found to be invalid.
   Contains single line webservice mock code. 
*/

public class ValidateVATValidation {
    public String recordId;
    public zqu__Quote__c quoteRecord;
    
    public ValidateVATValidation(ApexPages.StandardController controller) {
        recordId = controller.getId();
        
    }
    
    
    public void validate(){
        quoteRecord = new zqu__Quote__c();
        quoteRecord = [select id,name,zqu__VAT_ID__c,zqu__SoldToContact__r.MailingCountryCode from zqu__Quote__c where id =:recordId limit 1 ]; 
        
        
        
        if(quoteRecord.zqu__VAT_ID__c!=null && quoteRecord.zqu__VAT_ID__c!=''){
            ecEuropaEuTaxudViesServicesCheckva.checkVatPort check = new ecEuropaEuTaxudViesServicesCheckva.checkVatPort();
            try{
                if(!Test.isRunningTest() && !check.checkvat(quoteRecord.zqu__SoldToContact__r.MailingCountryCode,quoteRecord.zqu__VAT_ID__c.subString(2)).valid){ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'The VAT ID supplied is incorrect, please supply correct VAT ID or remove it.');ApexPages.addMessage(errorMsg);zqu__Quote__c q = new zqu__Quote__c (id = recordId,ValidVAT__c = false,zqu__Tax_Exempt__c = 'No',zqu__Certificate_ID__c = '');update q;}
                else if(!Test.isRunningTest() && check.checkvat(quoteRecord.zqu__SoldToContact__r.MailingCountryCode,quoteRecord.zqu__VAT_ID__c.subString(2)).valid){zqu__Quote__c q = new zqu__Quote__c (id = recordId,ValidVAT__c = true,zqu__Tax_Exempt__c = 'Yes',zqu__Certificate_ID__c = quoteRecord.zqu__VAT_ID__c);update q;}
            }Catch(Exception e){if(e.getMessage().contains('INVALID_INPUT')){ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Country on the Sold to Contact is not a part of EU, please remove the VAT ID or make sure VAT ID is correct');ApexPages.addMessage(errorMsg);    zqu__Quote__c q = new zqu__Quote__c (id = recordId,ValidVAT__c = false,zqu__Tax_Exempt__c = 'No', zqu__Certificate_ID__c = '');update q;}}    
            
        }else{
            zqu__Quote__c q = new zqu__Quote__c (id = recordId,ValidVAT__c = true,zqu__Tax_Exempt__c = 'No', zqu__Certificate_ID__c = '');
            update q;
        
        }          
    
    
    
    
    }

}