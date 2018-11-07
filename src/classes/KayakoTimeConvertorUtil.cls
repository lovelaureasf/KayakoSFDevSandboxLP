/*
This class converts the time given by Kayako API into salesforce user specific locale/timezone.
Author : Sagar Pareek
Date : 8 Jul 2016
*/
public class KayakoTimeConvertorUtil {
    
    public Static String Convert(String dateTimeFromApi){
        
        //remove T and Z from GMT time. 
        String dt = dateTimeFromApi.replace('Z',' ').replace('T',' ');
        dt = dt.replace('+',':');

        //split date and time into two string.
        String responseDate = String.valueOf(dt.split(' ')[0]);
        String responseTime = String.valueOf(dt.split(' ')[1]);
        
        //split year,month and day from date
        Integer responseYear = Integer.valueOf(responseDate.split('-')[0]);
        Integer responseMonth = Integer.valueOf(responseDate.split('-')[1]);
        Integer responseDay = Integer.valueOf(responseDate.split('-')[2]);
        
        //split hour,minute and second from time
        Integer responseHour = Integer.valueOf(String.valueOf(responseTime).split(':')[0]);
        Integer responseMinute = Integer.valueOf(String.valueOf(responseTime).split(':')[1]);
        Integer responseSecond = Integer.valueOf(String.valueOf(responseTime).split(':')[2].split(':')[0]);
        
        //now create salesforce specific GMT time instance
        Datetime GMTDate = Datetime.newInstanceGMT(responseYear,responseMonth,responseDay,responseHour,responseMinute,responseSecond);
                              
        //.format() will convert the GMT instance into current user's specific date and time (locale specific)
        String convertedDatetime = String.valueOf(GMTDate);
        
        //go return it back!
        return convertedDatetime;
    }

}