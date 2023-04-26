import { defineStore } from "pinia";
import api from "@/api";
import qs from "qs";

export const useStockStore = defineStore({
  id: "stock",

  state: () => ({
    stocks: [],
    stockTotalRecords: 0,
    selectedStock: {},
    stockLoading: false,
  }),

  getters: {
    getStocks: (state) => state.stocks,
  },

  actions: {
    async fetchStocks(params) {
      this.stockLoading = true;
      let queryParams = qs.stringify(params);
      let res = await api.get("Stock.php?get&" + queryParams);
      if (res && res.data?.success) {
        this.stocks = res.data.value;
        this.stockTotalRecords = res.data.totalRecords;
      }
      this.stockLoading = false;
    },

    async updateStock(stock) {
      this.stockLoading = true;
      let stockQs = qs.stringify({
        stockId: stock.stockId,
        stockQtyTypeId: stock.stockQtyTypeId,
        stockSubplaceId: stock.stockSubplaceId,
        stockTypeId: stock.stockTypeId,
        workId: stock.workId,
        stockCardId: stock.stockCardId,
        lockQty: stock.lockQty,
        curQty: stock.curQty,
        ordQty: stock.ordQty,
        minQty: stock.minQty,
        shelf: stock.shelf,
        remark: stock.remark,
        lockReason: stock.lockReason,
        deliveryDate: stock.deliveryDate,
      });
      await api.post("Stock.php?update&", stockQs);
      this.stockLoading = false;
    },

    async insertStock(stock) {
      this.stockLoading = true;
      let stockQs = qs.stringify({
        stockId: stock.stockId,
        isDetuctedOrd: stock.isDetuctedOrd,
        addedCurQty: stock.addedCurQty, 
        operationWorkId: stock.operationWorkId,
        operationRemark: stock.operationRemark,
      });
      await api.post("Stock.php?insertStock&", stockQs);
      this.stockLoading = false;
    },

    async detuctStock(stock) {
      this.stockLoading = true;
      let stockQs = qs.stringify({
        stockId: stock.stockId,
        detuctedCurQty: stock.detuctedCurQty,
        operationWorkId: stock.operationWorkId,
        operationRemark: stock.operationRemark,
      });
      await api.post("Stock.php?detuctStock&", stockQs);
      this.stockLoading = false;
    },

    async setProjectStock(stock) {
      this.stockLoading = true;
      let stockQs = qs.stringify({
        stockId: stock.stockId,
        workId: stock.workId,
        operationRemark: stock.operationRemark,
      });
      await api.post("Stock.php?setProjectStock&", stockQs);
      this.stockLoading = false;
    },

    async insertOrderStock(stock) {
      this.stockLoading = true;
      let stockQs = qs.stringify({
        stockId: stock.stockId,
        addedOrdQty: stock.addedOrdQty,
        deliveryDate: stock.deliveryDate,
        operationWorkId: stock.operationWorkId,
        operationRemark: stock.operationRemark,
      });
      await api.post("Stock.php?insertOrderStock&", stockQs);
      this.stockLoading = false;
    },

    async detuctOrderStock(stock) {
      this.stockLoading = true;
      let stockQs = qs.stringify({
        stockId: stock.stockId,
        detuctedOrdQty: stock.detuctedOrdQty,
        deliveryDate: stock.deliveryDate,
        operationWorkId: stock.operationWorkId,
        operationRemark: stock.operationRemark,
      });
      await api.post("Stock.php?detuctOrderStock&", stockQs);
      this.stockLoading = false;
    },

    async addStock(stock) {
      this.stockLoading = true;
      let stockQs = qs.stringify({
        stockQtyTypeId: stock.stockQtyTypeId,
        stockSubplaceId: stock.stockSubplaceId,
        stockTypeId: stock.stockTypeId,
        workId: stock.workId,
        stockCardId: stock.stockCardId,
        lockQty: stock.lockQty,
        curQty: stock.curQty,
        ordQty: stock.ordQty,
        minQty: stock.minQty,
        shelf: stock.shelf,
        remark: stock.remark,
        lockReason: stock.lockReason,
        deliveryDate: stock.deliveryDate,
      });
      await api.post("Stock.php?add&", stockQs);
      this.stockLoading = false;
    },

    async deleteStock(stock) {
      this.stockLoading = true;
      let stockQs = qs.stringify({
        stockId: stock.stockId,
      });
      await api.post("Stock.php?delete&", stockQs);
      this.stockLoading = false;
    },

    initStock() {
      return {
        stockQtyTypeId: null,
        stockSubplaceId: null,
        stockTypeId: null,
        workId: null,
        stockCardId: null,
        lockQty: 0,
        curQty: 0,
        ordQty: 0,
        minQty: 0,
        shelf: null,
        remark: null,
        lockReason: null,
        deliveryDate: null,
      };
    },

    initEnterStock() {
      return {
        isDetuctedOrd: false,
        operationRemark: null,
        deliveryDate: null,
        addedCurQty: 0,
      };
    },
  },
  persist: false,
});

export default useStockStore;
