import { defineStore } from "pinia";
import api from "@/api";

export const useStockQtyTypeStore = defineStore({
  id: "stockQtyType",

  state: () => ({
    stockQtyTypes: [],
  }),

  getters: {
    getStockQtyTypes: (state) => state.stockQtyTypes,
  },

  actions: {
    async fetchStockQtyTypes() {
      let res = await api.get("StockQtyType.php?get&");
      if (res && res.data?.success) {
        this.stockQtyTypes = res.data.value;
      }
    },
  },
  persist: false,
});

export default useStockQtyTypeStore;
