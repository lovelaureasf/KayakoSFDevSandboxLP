@isTest
public class OppBlankStageFillerTest{

public static testMethod void positiveScenario(){

 account acc = new account();
 acc.name='test';
 insert acc;
 
 opportunity o = new opportunity();
 o.accountid = acc.id;
 o.closeDate =date.today()+30;
 o.name='test';
 o.stageName='Value Proposition';
 insert o;


}


}