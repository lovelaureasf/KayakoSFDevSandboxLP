/*
*This class is used to schedule the BatchUpdateNetNextChargeAmountOnAccount.
*This is called from Developer console with the cron expression.
*/

global class ScheduleBatchUpdateNetNextChargeAmount implements schedulable
{
    global void execute(SchedulableContext sc)
    {
     BatchNetNextChargeAmountOnAccountUpdater  b = new  BatchNetNextChargeAmountOnAccountUpdater (); 
      database.executebatch(b);
    }
}