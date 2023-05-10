<script setup>
import "primevue/resources/themes/mdc-light-indigo/theme.css";
import "primevue/resources/primevue.min.css";
import "primeicons/primeicons.css";
import "primeflex/primeflex.css";

import "./assets/css/app.css";
import "./assets/css/primeCustom.css";

import AppMenubar from "@/components/app/AppMenubar.vue";
import LoginView from "./pages/LoginPage.vue";
import Toast from "primevue/toast";
import ConfirmDialog from "primevue/confirmdialog";
import useAuthStore from "./stores/auth";
import { ref, watch } from 'vue';
import { useRoute } from "vue-router";
/*export default {
  components: {
    AppMenubar,
    Toast,
    ConfirmDialog,
    LoginView,
    TabView,
    TabPanel
  },
  setup() {
    const authStore = useAuthStore();
    return { authStore };
  },
};*/
const authStore = useAuthStore();
const isMenuVisible = ref(true);
const route = useRoute();
watch(() => route.path, () => {
  if (route.path.toLowerCase().search("orderitemreport") > -1 || route.path.toLowerCase().search("receiptchart") > -1) {
    isMenuVisible.value = false;
  } else {
    isMenuVisible.value = true;
  }

})
</script>

<template>
  <div v-if="authStore.user?.username || isMenuVisible == false" class="grid">
    <div class="col-12">

      <AppMenubar v-if="isMenuVisible == true"></AppMenubar>

    </div>
    <div class="col-12 mt-6">
      <router-view></router-view>
    </div>
  </div>
  <LoginView v-else />

  <Toast position="top-center" group="main" />
  <ConfirmDialog group="mbox" />
  <ConfirmDialog group="cbox" />
  <ConfirmDialog group="sbox" />

</template> 
<style>
body {
  background: url(assets/ordersystem.jpg) no-repeat center center fixed;
  background-size: cover;
  margin-top: 0;
  padding: 0;
  height: 100%;
}
</style>
