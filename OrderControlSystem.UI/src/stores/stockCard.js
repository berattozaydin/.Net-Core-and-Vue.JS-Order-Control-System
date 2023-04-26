import { defineStore } from "pinia";
import api from "@/api";
import qs from "qs";

export const useStockCardStore = defineStore({
  id: "stockCard",

  state: () => ({
    stockCards: [],
    selectedStockCard: null,
    selectedStockCardDetail: null,
    stockCardTotalRecords: 0,
    stockCardLoading: false,
  }),

  getters: {
    getStockCards: (state) => state.stockCards,
  },

  actions: {
    async fetchStockCardDetail(params = null) {
      this.stockCardLoading = true;
      let queryParams = qs.stringify(params);
      let res = await api.get("StockCard.php?getDetail&" + queryParams);
      if (res && res.data?.success) {
        this.selectedStockCardDetail = res.data.value;
      }
      this.stockCardLoading = false;
    },

    async fetchStockCards(params = null) {
      this.stockCardLoading = true;

      let queryParams = qs.stringify(params);

      let res = await api.get("StockCard.php?getAll&" + queryParams);
      if (res && res.data?.success) {
        this.stockCards = res.data.value;
        this.stockCardTotalRecords = res.data.totalRecords;
      }
      this.stockCardLoading = false;
    },

    async fetchStockCardsDetail(params = null) {
      this.stockCardLoading = true;

      let queryParams = qs.stringify(params);

      let res = await api.get("StockCard.php?getAllDetail&" + queryParams);
      if (res && res.data?.success) {
        this.stockCards = res.data.value;
        this.stockCardTotalRecords = res.data.totalRecords;
      }
      this.stockCardLoading = false;
    },

    async updateStockCard(stockCard) {
      let stockCardQs = qs.stringify({
        stockCardId: stockCard.stockCardId,
        barcode: stockCard.barcode,
      });
      await api.post("StockCard.php?update", stockCardQs);
    },
  },
  persist: false,
});

export default useStockCardStore;
