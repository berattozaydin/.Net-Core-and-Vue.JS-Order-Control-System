<script setup>
import InputText from "primevue/inputtext";
import ProgressSpinner from "primevue/progressspinner";
import Button from "primevue/button";
import useAuthStore from "../stores/auth";
import { version } from '../../package.json';
import useAuthApi from "../api/auth.api";
import { computed, ref } from "vue";
const authStore = useAuthStore();
const user = ref({});
const authApi = useAuthApi();
const authLoading = computed(()=>{
  return authStore.user?.username;
})
 async function login() {

   await authStore.login(user.value);
      //this.authStore.user = {
        //Token: "adsadas",
        //Username: "ADMIN",
        //FullName: "ADMIN",
      //}

      // let authResponse = await this.authStore.login({
      //   username: this.username,
      //   password: this.password,
      // });

      // if (authResponse.data.success) {
      //   let user = authResponse.data.value;
      //   api.defaults.headers.common.Authorization = `bearer ${user.token}`;
      //   this.authStore.user = authResponse.data.value;
      // } else {
      // }
    }
  

</script>

<template>
  <div class="
      px-4
      py-8
      md:px-6
      lg:px-8
      flex
      align-items-center
      justify-content-center
    ">
    <div class="surface-card py-4 px-8 shadow-2 border-round w-full md:w-6 lg:w-4">
      <div class="text-center mb-5">
      </div>

      <div>
        <label for="username" class="block text-900 font-medium mb-2">Çalışan No</label>
        <InputText v-model="user.username" id="username" type="text" class="w-full mb-3" />

        <label for="password" class="block text-900 font-medium mb-2">Şifre</label>
        <InputText v-model="user.password" id="password" type="password" class="w-full mb-3" @keydown.enter="login()" />

        <Button v-if="!authLoading" label="Giriş Yap" icon="pi pi-user" class="w-full mt-3" @click="login()" />
        <div class="flex align-items-center">
          <ProgressSpinner v-if="authLoading" style="width: 50px; height: 50px" />
        </div>
      </div>

      <div class="flex align-items-center justify-content-between mt-6">
        <span class="text-600 font-medium line-height-3">OrderControlSystem © Copyright 2023</span>
        <span class="
            font-medium
            no-underline
            ml-2
            text-blue-500 text-right
            cursor-pointer
          ">v {{ version }}</span>
      </div>
    </div>
  </div>
</template>


 