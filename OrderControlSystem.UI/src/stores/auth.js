import { defineStore } from "pinia";
import api from "@/api";
import { useRoute } from "vue-router";
import { computed } from "vue";
import useAuthApi from "../api/auth.api";
export const useAuthStore = defineStore({
  id: "auth",
  
  state: () => ({
    user: null, 
   
  }),
  
  getters: {
    getAuths: (state) => state.auths,
  },

  actions: {
    async login(credential) {  
      let loginResponse = await api.post("login/LoginUser",credential);  
      this.user=loginResponse.data?.value; 
      
    },
  },
  persist: true,
});

export default useAuthStore;
