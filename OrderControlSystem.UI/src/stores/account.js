import { defineStore } from "pinia";
import api from "@/api";
import qs from "qs";

export const useAccountStore = defineStore({
  id: "account",

  state: () => ({
    accounts: [],
    accountLoading: false,
  }),

  getters: {
    getAccounts: (state) => state.accounts,
  },

  actions: {
    async fetchAccounts() {
      this.accountLoading = true;
      let res = await api.get("Account/GetAllAccount");
     this.accounts=res.data?.value;
      this.accountLoading = false;
    },

    async updateAccount(accountDto) {
      this.accountLoading = true;
      await api.post("Account/UpdateAccount", accountDto);
      this.accountLoading = false;
    },

    async addAccount(account) {
      this.accountLoading = true;
      let accountQs = {
        customerId: account.customerId,
        username: account.username,
        password: account.password,
        role: account.role,
        name: account.name,
        lastName: account.lastName,
        email: account.email,
        phoneNumber: account.phoneNumber,
        isActive: account.isActive,
      };
      await api.post("Account/CreateAccount", accountQs);
      this.accountLoading = false;
    },

    async deleteAccount(account) {
      this.accountLoading = true;
      let accountQs = qs.stringify({
        accountId: account.accountId,
      });
      await api.post("Account/DeleteAccount", accountQs);
      this.accountLoading = false;
    },
  },
  persist: false,
});

export default useAccountStore;
