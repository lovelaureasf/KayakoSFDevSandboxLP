/*
   Temporary batch that updates the existing customer field on leads
*/   

global class BatchExistingCustomerUpdater implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        //main query that defines the scope of the batch
        String query = 'select id,name,existingcustomer__c,email from lead where existingcustomer__c=null and isconverted=false and stage__c=\'SRL\'';
        
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<lead> scope) {
             
                List<lead>leadList = new List<Lead>();
                Set<String>lEmails = new Set<String>();
                Set<String>iEmails = new Set<String>();
                Map<String,List<Zuora__Subscription__c>>mapOfEmailAndSubs = new Map<String,List<Zuora__Subscription__c>>();
                Map<String,List<Zuora__Subscription__c>>mapOfEmailDomainAndSubs = new Map<String,List<Zuora__Subscription__c>>();
                for(lead l: scope){
                   
                        if(l.email!=null){
                            if(EmailDomain.checkDomain(l.email)){ lEmails.add(l.email);
                            }else{
                                iEmails.add(l.email);  
                            }
                        }    
                    
                }
                System.debug('######'+lEmails);
              System.debug('######'+iEmails);
                for(Zuora__Subscription__c zs: [select id,name,Family__c,Zuora__CustomerAccount__r.Zuora__BillToWorkEmail__c from Zuora__Subscription__c where Zuora__Status__c='Active' OR Zuora__Status__c='Expired']){ if(!mapOfEmailAndSubs.containsKey(zs.Zuora__CustomerAccount__r.Zuora__BillToWorkEmail__c)){mapOfEmailAndSubs.put(zs.Zuora__CustomerAccount__r.Zuora__BillToWorkEmail__c, new List<Zuora__Subscription__c>{zs});}else{mapOfEmailAndSubs.get(zs.Zuora__CustomerAccount__r.Zuora__BillToWorkEmail__c).add(zs);
                    }
                }
              System.debug('map 1'+mapOfEmailAndSubs);
            
               for(Zuora__Subscription__c zs: [select id,name,Family__c,Zuora__CustomerAccount__r.Zuora__BillToWorkEmail__c from Zuora__Subscription__c where Zuora__Status__c='Active' OR Zuora__Status__c='Expired']){if(!mapOfEmailDomainAndSubs.containsKey(String.valueOf(zs.Zuora__CustomerAccount__r.Zuora__BillToWorkEmail__c).split('@')[1])){mapOfEmailDomainAndSubs.put(String.valueOf(zs.Zuora__CustomerAccount__r.Zuora__BillToWorkEmail__c).split('@')[1], new List<Zuora__Subscription__c>{zs});}else{ mapOfEmailDomainAndSubs.get(String.valueOf(zs.Zuora__CustomerAccount__r.Zuora__BillToWorkEmail__c).split('@')[1]).add(zs);
                    }
                }   
                
            System.debug('mapOfEmailDomain'+mapOfEmailDomainAndSubs);
            
              
                
                for(lead l: scope){
                  
                    if(l.email!=null){
                    Set<String>productNames = new Set<String>();
                       System.debug('$$$$$$'+l.email);
                    if(EmailDomain.checkDomain(l.email)){   if(mapOfEmailAndSubs.containsKey(l.email)){for(Zuora__Subscription__c zs: mapOfEmailAndSubs.get(l.email)){  if(zs.Family__c.startsWith('novo')){ productNames.add('Kayako');   }else if(zs.Family__c.startsWith('kayako4')){    productNames.add('Kayako 4');                                   }
                         
                      
                                
                             
                                
                                
                                        
                                 
                                    

                                 
                            }
                            
                            
                        }
                        
                        
                    
                    }else{
                             System.debug('domain not found!!!!!! ok now look for the exact match');
                             if(mapOfEmailAndSubs.containsKey(l.email)){
                               System.debug('exact match map have the value');
                             for(Zuora__Subscription__c zs: mapOfEmailAndSubs.get(l.email)){if(zs.Family__c!=null){if(zs.Family__c.startsWith('novo')){productNames.add('Kayako');   }else if(zs.Family__c.startsWith('kayako4')){    productNames.add('Kayako 4'); 
     
                                        
                                      }
                                 }
                            }
                            
                           
                        }else if(mapOfEmailDomainAndSubs.containsKey(l.email.split('@')[1])){for(Zuora__Subscription__c zs: mapOfEmailDomainAndSubs.get(l.email.split('@')[1])){ if(zs.Family__c!=null){ if(zs.Family__c.startsWith('novo')){ productNames.add('Kayako');   }else if(zs.Family__c.startsWith('kayako4')){productNames.add('Kayako 4'); 
                                      }
                                 }
                            }
            
                        }
                        
                        
                    
                    }
                    
                    for(String s:productNames){ if (l.ExistingCustomer__c!=null  &&  l.ExistingCustomer__c.indexOf(s) < 0){l.ExistingCustomer__c = ';'+s;}else{l.ExistingCustomer__c = s;
                        }        
                               
                        
                      
                    }    
                    
                    leadList.add(l);
                        
                    }  
            
               
               
        
    }




    update leadlist;









    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}