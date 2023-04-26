import { defineStore } from "pinia";
import api from "@/api";
import qs from "qs";
const myCustomers = [
  ]

export const useCustomerStore = defineStore({
  id: "customer",

  state: () => ({
    customers: [],
    customerLoading: false,
  }),

  getters: {
    getCustomers: (state) => state.customers,
  },

  actions: {
    async fetchCustomers() {
      this.customerLoading = true;
      setTimeout(() => { 
        this.customers = myCustomers
        this.customerLoading = false;
      }, 3000);
    },

    async updateCustomer(customer) {
      this.customerLoading = true;
      let customerQs = qs.stringify({
        Id: customer.Id,
        CompanyName: customer.CompanyName,
        ContactName: customer.ContactName,
        ContactTitle: customer.ContactTitle,
        Address: customer.Address,
        Town: customer.Town,
        City: customer.City,
        Country: customer.Country,
        Phone1: customer.Phone1,
        Phone2: customer.Phone2,
        Fax: customer.Fax,
        Email: customer.Email, 
        PostalCode: customer.PostalCode
      });
      await api.post("Customer.php?update&", customerQs);
      this.customerLoading = false;
    },

    async addCustomer(customer) {
      this.customerLoading = true;
      let customerQs = qs.stringify({  
        CompanyName: customer.CompanyName,
        ContactName: customer.ContactName,
        ContactTitle: customer.ContactTitle,
        Address: customer.Address,
        Town: customer.Town,
        City: customer.City,
        Country: customer.Country,
        Phone1: customer.Phone1,
        Phone2: customer.Phone2,
        Fax: customer.Fax,
        Email: customer.Email, 
        PostalCode: customer.PostalCode
      });
      await api.post("Customer.php?add&", customerQs);
      this.customerLoading = false;
    },

    async deleteCustomer(customer) {
      this.customerLoading = true;
      let customerQs = qs.stringify({
        customerId: customer.customerId,
      });
      await api.post("Customer.php?delete&", customerQs);
      this.customerLoading = false;
    },
  },
  persist: false,
});

export default useCustomerStore;
