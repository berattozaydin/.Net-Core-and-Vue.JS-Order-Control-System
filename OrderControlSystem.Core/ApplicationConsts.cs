namespace OrderControlSystem.Core
{
    public static class AppWorkOrderStatus
    {
        public const int DRAFT = 10;
        public const int NOT_STARTED = 20;
        public const int RUNNING = 30;
        public const int STOPPED = 40;
        public const int COMPLETED = 50;
        public const int CLOSED = 60;
    }

    public static class AppWorkOrderItemStatus
    {
        public const int DRAFT = 10;
        public const int NOT_STARTED = 20;
        public const int RUNNING = 30;
        public const int STOPPED = 40;
        public const int COMPLETED = 50;
        public const int CLOSED = 60;
    }

    public static class AppFurnace
    {
        public const int NATURAL_GAS = 1;
        public const int ELECTRIC = 2;
        public const int INDUCTION = 3;
    }

}
