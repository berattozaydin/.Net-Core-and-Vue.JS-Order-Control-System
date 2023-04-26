import { defineStore } from "pinia";
import api from "@/api";
import qs from "qs";

export const useStockOperationStore = defineStore({
  id: "stockOperation",

  state: () => ({
    stockOperations: [],
    selectedStockOperation: {},
    stockOperationTotalRecords: 0,
    stockOperationLoading: false,
  }),

  getters: {
    getStockOperations: (state) => state.stockOperations,
  },

  actions: {
    async fetchStockOperations(params) {
      this.stockOperationLoading = true;
      let stockOperationParamsQs = qs.stringify(params);
      let res = await api.get(
        "StockOperation.php?get&" + stockOperationParamsQs
      );
      if (res && res.data?.success) {
        this.stockOperations = res.data.value;
        this.stockOperationTotalRecords = res.data.totalRecords;
      }
      this.stockOperationLoading = false;
    },

    async updateStockOperation(stockOperation) {
      this.stockOperationLoading = true;
      let stockOperationQs = qs.stringify({
        stockOperationId: stockOperation.stockOperationId,
        name: stockOperation.name,
      });
      await api.post("StockOperation.php?update&", stockOperationQs);
      this.stockOperationLoading = false;
    },

    async deleteStockOperation(stockOperation) {
      this.stockOperationLoading = true;
      let stockOperationQs = qs.stringify({
        stockOperationId: stockOperation.stockOperationId,
      });
      await api.post("StockOperation.php?delete&", stockOperationQs);
      this.stockOperationLoading = false;
    },

    initStockOperation() {
      return {
        stockOperationQtyTypeId: null,
        stockOperationSubplaceId: null,
        stockOperationTypeId: null,
        workId: null,
        stockOperationCardId: null,
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

    initEnterStockOperation() {
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

export default useStockOperationStore;
