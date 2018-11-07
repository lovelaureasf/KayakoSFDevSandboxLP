public class MetricsData {

    public class Metrics {
        public Integer total;
        public Integer daily_active;
        public Integer weekly_active;
        public Integer monthly_active;
        public L28 l28;
        public String resource_type;
        
    }

    public Integer status;
    public Data data;
    public String resource;

    public class Data {
        public Metrics administrator;
        public Metrics agent;
        public Metrics collaborator;
        public Metrics customer;
        public Metrics owner;
        public String resource_type;
    }

    public class L28 {
        public Integer user_count;
        public Integer average_no_of_days;
        public String resource_type;
    }
    
    public static MetricsData parse(String json) {
        return (MetricsData) System.JSON.deserialize(json, MetricsData.class);
    }
}