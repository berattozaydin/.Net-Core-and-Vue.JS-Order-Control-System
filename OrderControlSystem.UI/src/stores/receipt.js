import { defineStore } from "pinia";
import api from "@/api";

const myReceipts = [
  { id: '1', processTypeId: '2', furnaceId: '1', name: 'annealing1 ', remark: 'note1' },
  { id: '2', processTypeId: '1', furnaceId: '2', name: 'annealing2 ', remark: 'note2' },
  { id: '3', processTypeId: '3', furnaceId: '3', name: 'annealing3 ', remark: 'note3' },
];
export const useReceiptStore = defineStore({
  id: "receipt",

  state: () => ({
    receipts: [],
    isLoadingReceipts: false,
    isAddingReceipts: false
  }),

  getters: {
    getReceipts: (state) => state.receipts,
  },

  //
  actions: {
    async fetchReceipts() {
      // this.isLoadingReceipts = true
      // let res = await api.get("ProcessType.php?get&");
      // if (res && res.data?.success) {
      //   this.processTypes = res.data.value;
      // }
      
      this.isLoadingReceipts = true

      // dummy data fetching
      setTimeout(() => {
        this.receipts = myReceipts
        this.isLoadingReceipts = false
      }, 3000)
    },
    async addReceipt(receipt) {
      // this.isLoadingReceipts = true
      // let res = await api.get("ProcessType.php?get&");
      // if (res && res.data?.success) {
      //   this.processTypes = res.data.value;
      // }
      
      this.isAddingReceipts = true

      // dummy data fetching
      setTimeout(() => {
        this.receipts.push(receipt)
        this.isAddingReceipts = false
      }, 3000)
    },
  },
  persist: false,
});

export default useReceiptStore;
