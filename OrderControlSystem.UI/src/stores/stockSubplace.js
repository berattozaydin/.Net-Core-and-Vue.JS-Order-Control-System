import { defineStore } from "pinia";
import api from "@/api";
import qs from "qs";

export const useStockSubplaceStore = defineStore({
  id: "stockSubplace",

  state: () => ({
    stockSubplaces: [],
    stockSubplaceLoading: false,
  }),

  getters: {
    getStockSubplaces: (state) => state.stockSubplaces,
  },

  actions: {
    async fetchStockSubplaces(stockPlaceId) {
      this.stockSubplaceLoading = true;
      let filterQuery = "";
      if (stockPlaceId) {
        filterQuery += `stockPlaceId=${stockPlaceId}&`;
      }
      let res = await api.get("StockSubplace.php?get&" + filterQuery);
      if (res && res.data?.success) {
        this.stockSubplaces = res.data.value;
      }
      this.stockSubplaceLoading = false;  
    },

    async updateStockSubplace(stockSubplace) {
      this.stockSubplaceLoading = true;
      let stockSubplaceQs = qs.stringify({
        stockSubplaceId: stockSubplace.stockSubplaceId,
        stockPlaceId: stockSubplace.stockPlaceId,
        name: stockSubplace.name,
      });
      await api.post("StockSubplace.php?update&", stockSubplaceQs);
      this.stockSubplaceLoading = false;
    },

    async addStockSubplace(stockSubplace) {
      this.stockSubplaceLoading = true;
      let stockSubplaceQs = qs.stringify({
        stockPlaceId: stockSubplace.stockPlaceId,
        name: stockSubplace.name,
      });
      await api.post("StockSubplace.php?add&", stockSubplaceQs);
      this.stockSubplaceLoading = false;
    },

    async deleteStockSubplace(stockSubplace) {
      this.stockSubplaceLoading = true;
      let stockSubplaceQs = qs.stringify({
        stockSubplaceId: stockSubplace.stockSubplaceId,
      });
      await api.post("StockSubplace.php?delete&", stockSubplaceQs);
      this.stockSubplaceLoading = false;
    },
  },
  persist: false,
});

export default useStockSubplaceStore;
