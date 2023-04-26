import { defineStore } from "pinia";
import api from "@/api";
import qs from "qs";

export const useStockPlaceStore = defineStore({
  id: "stockPlace",

  state: () => ({
    stockPlaces: [],
    stockPlaceLoading: false,
  }),

  getters: {
    getStockPlaces: (state) => state.stockPlaces,
  },

  actions: {
    async fetchStockPlaces() {
      this.stockPlaceLoading = true;
      let res = await api.get("StockPlace.php?get&");
      if (res && res.data?.success) {
        this.stockPlaces = res.data.value;
      }
      this.stockPlaceLoading = false;
    },

    async updateStockPlace(stockPlace) {
      this.stockPlaceLoading = true;
      let stockPlaceQs = qs.stringify({
        stockPlaceId: stockPlace.stockPlaceId,
        name: stockPlace.name,
      });
      await api.post("StockPlace.php?update&", stockPlaceQs);
      this.stockPlaceLoading = false;
    },

    async addStockPlace(stockPlace) {
      this.stockPlaceLoading = true;
      let stockPlaceQs = qs.stringify({ 
        name: stockPlace.name,
      });
      await api.post("StockPlace.php?add&", stockPlaceQs);
      this.stockPlaceLoading = false;
    },

    async deleteStockPlace(stockPlace) {
      this.stockPlaceLoading = true;
      let stockPlaceQs = qs.stringify({
        stockPlaceId: stockPlace.stockPlaceId,
      });
      await api.post("StockPlace.php?delete&", stockPlaceQs);
      this.stockPlaceLoading = false;
    },
  },
  persist: false,
});

export default useStockPlaceStore;
