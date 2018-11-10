public class FutureBatchClass {

    @future(callout=true)
    public static void insertLead() {
         List<lead> lList = new List<lead>();
       
           lead l = new lead();
            l.lastname='Lead testing ' + string.valueOf(Datetime.now());
            l.email= string.valueOf(Datetime.now().getTime()) +'test@test.com';
            l.country='Afghanistan';
            l.company='abc';
            l.leadsource = 'Webinar';
            lList.add(l);
       lead l2 = new lead();
             l2.lastname='Lead testing 1' + string.valueOf(Datetime.now());
            l2.email= string.valueOf(Datetime.now().getTime()) +'1test@test.com';
            l2.country='Afghanistan';
            l2.company='abc';
            l2.leadsource = 'Demo Request';
       lList.add(l2);
       insert lList;
     }
    
     @future(callout=true)
    public static void insertLead2() {
         List<lead> lList = new List<lead>();
       
           lead l = new lead();
            l.lastname='Lead ' + string.valueOf(Datetime.now().getTime());
            l.email= string.valueOf(Datetime.now().getTime()) +'test30mins@test.com';
            l.country='Canada';
            l.company='abc';
            l.leadsource = 'Webinar';
            lList.add(l);
            lead l2 = new lead();
             l2.lastname='Lead testing 1' + string.valueOf(Datetime.now().getTime());
            l2.email= string.valueOf(Datetime.now().getTime()) +'1test@test.com';
            l2.country='Canada';
            l2.company='abc';
            l2.leadsource = 'Demo Request';
       lList.add(l2);    
       insert lList;
     }

}