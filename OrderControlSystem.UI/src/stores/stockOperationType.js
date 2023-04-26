import { defineStore } from "pinia";
import api from "@/api";

export const useStockOperationTypeStore = defineStore({
  id: "stockOperationType",

  state: () => ({
    stockOperationTypes: [],
  }),

  getters: {
    getStockOperationTypes: (state) => state.stockOperationTypes,
  },

  actions: {
    async fetchStockOperationTypes() {
      let res = await api.get("StockOperationType.php?get&");
      if (res && res.data?.success) {
        this.stockOperationTypes = res.data.value;
      }
    },
  },
  persist: false,
});

export default useStockOperationTypeStore;
