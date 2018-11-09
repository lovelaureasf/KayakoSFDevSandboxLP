/**
  * ───────────────────────────────────────────────────────────────────────────────────────────────┐
  * Type - Apex Class
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  * @Object      SF Error Log  
  * @Description This class will be used by all the error handling logic to created
  *              Error Log Object in salesforce
  * @Author      Manoj Sankaran
  * ───────────────────────────────────────────────────────────────────────────────────────────────┘
  * Modification Log
  * 09-20-2018 - Created by Manoj Sankaran
  * 
  */
public class SF_LogError{
    public static void logError(Exception e){
            SF_Error_Log__c errorLog = new SF_Error_Log__c();
            //split the trac string to get class name
            string[] trace = e.getStackTraceString().split('\\.');
            errorLog.Class_Name__c = trace[1];
            
            //find the index of the first ':' and then get substring of string to get just the method name and remove unwanted data
            integer indexOfValue = trace[2].indexOf(':');
            errorLog.Method_Name__c = trace[2].substring(0, indexOfValue);
            
            errorLog.Error_Trace__c = e.getMessage();
            errorLog.Line_Number__c = string.valueOf(e.getLineNumber());
            errorLog.Error_Type__c = e.getTypeName();
            errorLog.User__c = userinfo.getFirstname() +' '+userinfo.getLastName();
            insert errorLog; 
    }
}