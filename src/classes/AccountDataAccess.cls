public without sharing class AccountDataAccess 
{
    public static Account FirstByNameAndOwner(String name, Id ownerId)
    {
        try
        {
            return [SELECT Id, Name, OwnerId FROM Account WHERE (Name = :name and OwnerId = :ownerId) LIMIT 1];
        }
        catch(QueryException noAccountFound)
        {
            throw new UnderflowException('No account found using name ' + name + ' and Owner ID ' + ownerId);
        }
    }
}