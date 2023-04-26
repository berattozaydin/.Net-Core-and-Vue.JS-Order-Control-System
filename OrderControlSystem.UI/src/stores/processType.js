import { defineStore } from "pinia";
import api from "@/api";

export const useProcessTypeStore = defineStore({
  id: "processType",

  state: () => ({
    processTypes: [],
  }),

  getters: {
    getProcessTypes: (state) => state.processTypes,
  },

  actions: {
    async fetchProcessTypes() {
      let res = await api.get("ProcessType.php?get&");
      if (res && res.data?.success) {
        this.processTypes = res.data.value;
      }
    },
  },
  persist: false,
});

export default useProcessTypeStore;
