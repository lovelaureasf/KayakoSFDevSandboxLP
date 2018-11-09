public class RoleName
{
    public static final String ADM = 'SDR';
    public static final String ISM = 'AE';
    public static final String RL = 'RL';
    public static final String MNGR = 'MNGR';

    public static Set <String> GetAll()
    {
        return new Set <String> { ADM, ISM, RL, MNGR };
    }

    public static Set <String> SeniorRoles()
    {
        return new Set <String> { ISM, RL, MNGR,ADM };
    }
}