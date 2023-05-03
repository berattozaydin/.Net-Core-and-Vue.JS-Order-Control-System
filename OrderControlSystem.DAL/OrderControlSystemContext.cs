using Microsoft.EntityFrameworkCore;
using OrderControlSystem.DAL.Models;

#nullable disable

namespace OrderControlSystem.DAL
{

    public partial class OrderControlContext : DbContext
    {
        public OrderControlContext()
        {
        }

        public OrderControlContext(DbContextOptions<OrderControlContext> options)
            : base(options)
        {
        }

        public virtual DbSet<Account> Accounts { get; set; }
        public virtual DbSet<Customer> Customers { get; set; }
        public virtual DbSet<CustomerOrder> CustomerOrders { get; set; }
        public virtual DbSet<CustomerOrderItem> CustomerOrderItems { get; set; }
        public virtual DbSet<CustomerOrderItemStatus> CustomerOrderItemStatuses { get; set; }
        public virtual DbSet<CustomerOrderStatus> CustomerOrderStatuses { get; set; }
        public virtual DbSet<Furnance> Furnances { get; set; }
        public virtual DbSet<Log> Logs { get; set; }
        public virtual DbSet<ProcessSteps> ProcessStepss { get; set; }
        public virtual DbSet<ReceiptDetail> ReceiptDetails { get; set; }
        public virtual DbSet<Role> Roles { get; set; }
        public virtual DbSet<TreatmentType> TreatmentTypes { get; set; }
        public virtual DbSet<CustomerOrderNumber> CustomerOrderNumberDto { get; set; }


        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
                optionsBuilder.UseMySQL("server=localhost;user=root;password=;database=order_control");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Account>(entity =>
            {
                entity.ToTable("Account");

                entity.HasIndex(e => e.CustomerId, "CustomerId");

                entity.HasIndex(e => e.Role, "Role");

                entity.Property(e => e.CreateDati).HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.Email)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.IsActive)
                    .IsRequired()
                    .HasDefaultValueSql("'1'");

                entity.Property(e => e.LastName)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.Password)
                    .IsRequired()
                    .HasMaxLength(256);

                entity.Property(e => e.PhoneNumber)
                    .IsRequired()
                    .HasMaxLength(15);

                entity.Property(e => e.Role).HasDefaultValueSql("'4'");

                entity.Property(e => e.Username)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.HasOne(d => d.Customer)
                    .WithMany(p => p.Accounts)
                    .HasForeignKey(d => d.CustomerId)
                    .HasConstraintName("Account_ibfk_1");

                entity.HasOne(d => d.RoleNavigation)
                    .WithMany(p => p.Accounts)
                    .HasForeignKey(d => d.Role)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("Account_ibfk_2");
            });

            modelBuilder.Entity<Customer>(entity =>
            {
                entity.ToTable("Customer");

                entity.Property(e => e.CompanyCode)
                    .IsRequired()
                    .HasMaxLength(200);

                entity.Property(e => e.CompanyFullName)
                    .IsRequired()
                    .HasMaxLength(200);

                entity.Property(e => e.CompanyName)
                    .IsRequired()
                    .HasMaxLength(200);

                entity.Property(e => e.Remark)
                    .IsRequired()
                    .HasMaxLength(200);

                entity.Property(e => e.TaxAdministration)
                    .IsRequired()
                    .HasMaxLength(200);

                entity.Property(e => e.TaxNumber)
                    .IsRequired()
                    .HasMaxLength(200);
            });

            modelBuilder.Entity<CustomerOrder>(entity =>
            {
                entity.ToTable("CustomerOrder");

                entity.HasIndex(e => e.CustomerId, "CustomerId");

                entity.HasIndex(e => e.CustomerOrderStatusId, "CustomerOrderStatusId");

                entity.HasIndex(e => e.OrderNumber, "UK_OrderNumber")
                    .IsUnique();

                entity.Property(e => e.CustomerOrderId)
                    .HasMaxLength(36)
                    .IsFixedLength(true);

                entity.Property(e => e.CreatedDate).HasDefaultValueSql("CURRENT_TIMESTAMP");
                entity.Property(e => e.UpdatedDate).HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.OrderNumber)
                    .IsRequired()
                    .HasMaxLength(15);

                entity.Property(e => e.Remark)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.HasOne(d => d.Customer)
                    .WithMany(p => p.CustomerOrders)
                    .HasForeignKey(d => d.CustomerId)
                    .HasConstraintName("CustomerId");

                entity.HasOne(d => d.CustomerOrderStatus)
                    .WithMany(p => p.CustomerOrders)
                    .HasForeignKey(d => d.CustomerOrderStatusId)
                    .HasConstraintName("CustomerOrderStatusId");
            });

            modelBuilder.Entity<CustomerOrderItem>(entity =>
            {
                entity.ToTable("CustomerOrderItem");

                entity.HasIndex(e => e.CustomerId, "CustomerId");

                entity.HasIndex(e => e.CustomerOrderItemStatusId, "CustomerOrderItemStatus");

                entity.HasIndex(e => e.CustomerOrderId, "CustomerOrderItem_ibfk_5");

                entity.HasIndex(e => e.TreatmentTypeId, "TreatmentTypeId");

                entity.Property(e => e.CustomerOrderItemId)
                    .HasMaxLength(36)
                    .IsFixedLength(true);

                entity.Property(e => e.CreateDate).HasColumnType("date");

                entity.Property(e => e.CustomerOrderId)
                    .IsRequired()
                    .HasMaxLength(36)
                    .IsFixedLength(true);


                entity.Property(e => e.FilePath).HasMaxLength(250);

                entity.Property(e => e.FinishDate).HasColumnType("date");

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.RegistrationDate).HasColumnType("date");

                entity.Property(e => e.Remark)
                    .IsRequired()
                    .HasMaxLength(200);

                entity.Property(e => e.RequestDate).HasColumnType("date");

                entity.Property(e => e.ShippingDate).HasColumnType("date");

                entity.HasOne(d => d.Customer)
                    .WithMany(p => p.CustomerOrderItems)
                    .HasForeignKey(d => d.CustomerId)
                    .HasConstraintName("CustomerOrderItem_ibfk_1");

                entity.HasOne(d => d.CustomerOrder)
                    .WithMany(p => p.CustomerOrderItems)
                    .HasForeignKey(d => d.CustomerOrderId)
                    .HasConstraintName("CustomerOrderItem_ibfk_5");

                entity.HasOne(d => d.CustomerOrderItemStatus)
                    .WithMany(p => p.CustomerOrderItems)
                    .HasForeignKey(d => d.CustomerOrderItemStatusId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("CustomerOrderItemStatus");

                entity.HasOne(d => d.TreatmentType)
                    .WithMany(p => p.CustomerOrderItems)
                    .HasForeignKey(d => d.TreatmentTypeId)
                    .HasConstraintName("CustomerOrderItem_ibfk_2");
            });

            modelBuilder.Entity<CustomerOrderItemStatus>(entity =>
            {
                entity.ToTable("CustomerOrderItemStatus");

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(30);
            });

            modelBuilder.Entity<CustomerOrderStatus>(entity =>
            {
                entity.ToTable("CustomerOrderStatus");

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(25);
            });

            modelBuilder.Entity<Furnance>(entity =>
            {
                entity.ToTable("Furnance");

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(25);
            });

            modelBuilder.Entity<Log>(entity =>
            {
                entity.ToTable("Log");

                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.CreatedDate).HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.LogDescription).HasMaxLength(1000);

                entity.Property(e => e.LogMethod).HasMaxLength(250);

                entity.Property(e => e.LogPath).HasMaxLength(250);

                entity.Property(e => e.MachineName).HasMaxLength(100);
            });
           
            modelBuilder.Entity<CustomerOrderNumber>(entity =>
            {
                entity.ToTable("CustomerOrderNumber");
                entity.Property(e => e.CustomerOrderNumberId).HasColumnName("CustomerOrderNumberId");
                entity.Property(e => e.CustomerOrderNumberCounter).HasColumnName("CustomerOrderNumberCounter");
                entity.Property(e => e.CustomerOrderNumberCreated).HasColumnName("CustomerOrderNumberCreated");

            });


            modelBuilder.Entity<ProcessSteps>(entity =>
            {
                entity.ToTable("ProcessSteps");


                entity.HasIndex(e => e.TreatmentTypeId, "TreatmentTypeId");

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(30);

                entity.Property(e => e.Remark)
                    .IsRequired()
                    .HasMaxLength(30);
            });

            modelBuilder.Entity<ReceiptDetail>(entity =>
            {
                entity.ToTable("ReceiptDetail");

                entity.HasIndex(e => e.ReceiptId, "ReceiptDetail_ibfk_1");

                entity.HasOne(d => d.Receipt)
                    .WithMany(p => p.ProcessStepsDetails)
                    .HasForeignKey(d => d.ReceiptId)
                    .HasConstraintName("ReceiptDetail_ibfk_1");
            });

            modelBuilder.Entity<Role>(entity =>
            {
                entity.ToTable("Role");

                entity.Property(e => e.RoleName)
                    .IsRequired()
                    .HasMaxLength(20);
            });

            modelBuilder.Entity<TreatmentType>(entity =>
            {
                entity.ToTable("TreatmentType");

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(35);
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
