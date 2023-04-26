namespace OrderControlSystem.Core.Types
{
    public enum CustomerOrderStatusId : int
    {
        Taslak = 10,
        SiparisOlusturuldu = 11,
        Onaylanmis = 20,
        IsılIslemde = 21,
        IptalEdildi = 30,
        Tamamlandi = 40,
        Sevkediliyor = 50,
        Kapandi = 60

    }
    public enum CustomerOrderItemStatusId : int
    {
        Taslak = 10,
        Onaylanmis = 20,
        IsılIslemde = 21,
        IptalEdildi = 30,
        Tamamlandi = 40,
        Sevkediliyor = 50,
        Kapandi = 60

    }

    public enum WorkOrderStatusId : int
    {
        Taslak = 10,
        Onaylandi = 20,
        IsılIslemde = 30,
        IptalEdildi = 40,
        Tamamlandi = 50,
        Kapandi = 60

    }

    public enum WorkOrderItemStatusId : int
    {
        Taslak = 10,
        Baslamadi = 20,
        DevamEdiyor = 30,
        Durduruldu = 40,
        Tamamlandi = 50,
        Kapandi = 60

    }
}
