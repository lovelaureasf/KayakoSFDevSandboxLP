public with sharing class LeadStage 
{
    public static final String MQL = 'MQL';
    public static final String SAL = 'SAL';
    public static final String SRL = 'SRL';
    public static final String SQL = 'SQL';
    public static final String SDL = 'SDL';

    public static Set <String> getAll()
    {
        return new Set <String> { MQL, SAL, SRL, SQL, SDL };
    }
}