/*
    This class will be used to check if any trigger is not firing more than once.
    There are some situations when a managed package updates a record and we cannot debug it and the call is recursive.
    For example the trigger - CreateTaskOnInstanceLink fires recursively whenever a instance is linked to it. 
    
*/
public Class CheckRecursive{
    private static boolean run = true;
    public static boolean runOnce(){
    if(run){
     run=false;
     return true;
    }else{
        return run;
    }
    }
}