namespace OrderControlSystem.Core
{
    public static class Extensions
    {
        public static string SubstringSafe(this string value, int size)
        {
            if (value == null)
                return null;

            if (value.Length > size)
            {
                return value.Substring(size);
            }
            else
            {
                return value;
            }

        }
    }
}
