public with sharing class LeadStatus 
{
    public static final String OPEN = 'Open';
    public static final String QUALIFIED = 'Qualified';
    public static final String INTERESTED = 'Interested';
    public static final String NURTURE = 'Nurture';
    public static final String UNRESPONSIVE = 'Unresponsive';
    public static final String CONVERTED = 'Converted';
    public static final String CONTACTED = 'Contacted';
    public static final String UNQUALIFIED = 'Unqulified';
    public static final String DEAD = 'Dead';

    public static Set <String> getAll()
    {
        return new Set <String> { OPEN, DEAD, QUALIFIED, INTERESTED, NURTURE, UNRESPONSIVE, CONVERTED, CONTACTED, UNQUALIFIED };
    }
}