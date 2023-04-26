import { createApp } from "vue";
import { createPinia } from "pinia";
import piniaPluginPersistedstate from "pinia-plugin-persistedstate"; 
import PrimeVue from "primevue/config";
import PrimeToastService from "primevue/toastservice"; 
import PrimeConfirmationService from "primevue/confirmationservice"; 
import App from "./App.vue";
import AppBaseLayout from "./components/app/AppBaseLayout.vue";
import Router from "./router"; 
import {install} from "./api/config"; 
const app = createApp(App);
const pinia = createPinia();

pinia.use(piniaPluginPersistedstate);

app.use(pinia);
app.use(Router);
app.use(PrimeVue);
app.use(PrimeToastService);
app.use(PrimeConfirmationService); 
install();

app.component("AppBaseLayout", AppBaseLayout);

app.mount("#app");
