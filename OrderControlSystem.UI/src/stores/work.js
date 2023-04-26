import { defineStore } from "pinia";
import api from "@/api";

export const useWorkStore = defineStore({
  id: "work",

  state: () => ({
    works: [],
  }),

  getters: {
    getWorks: (state) => state.works,
  },

  actions: {
    async fetchWorks(options) {
      if (options?.fetchForce || !this.works?.length) {
        let res = await api.get("Work.php?get&");
        if (res && res.data?.success) {
          this.works = res.data.value;
        }
      }
    },
  },
  persist: false,
});

export default useWorkStore;
