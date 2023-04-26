<script>
import Menubar from "primevue/menubar";
import SplitButton from "primevue/splitbutton";
import { PrimeIcons } from "primevue/api";
import useAuthStore from "../../stores/auth";

export default {
  components: {
    Menubar,
    SplitButton,
  },

  setup() {
    const authStore = useAuthStore();
    return { authStore };
  },

  data() {
    return {
      PrimeIcons,
      menubarItems: [],
      userMenuItems: [],
    };
  },
  
  created() {
    this.menubarItems = [
      {
        label: "Siparişler",
        icon: PrimeIcons.QRCODE, 
        to: "/Orders",
      }, 
      {
        label: "Müşteriler",
        icon: PrimeIcons.USERS, 
        to: "/Customers",
      }, 
      {
        label: "Kullanıcılar",
        icon: PrimeIcons.TAGS, 
        to: "/Accounts",
      }, 
      {
        label: "Reçeteler",
        icon: PrimeIcons.LIST, 
        to: "/receipts",
      }, 
      {
        label: "Kaliteler",
        icon: PrimeIcons.CHECK_SQUARE, 
        to: "/materialqualities",
      },
      
    ];
    this.userMenuItems = [
      {
        label:"Profil",
        icon:PrimeIcons.USER_EDIT
      },
      {
        label: "Çıkış Yap",
        icon: PrimeIcons.SIGN_OUT,
        command: () => {
          this.authStore.user = null;
        },
      },
    ];
    if(this.authStore.user.role==1){
      this.menubarItems.push( {
        label:"Log Kayıtları",
        icon:PrimeIcons.LOCK,
        to:"/logs",
      } );
    }
  },
  
};
</script>

<template>
  <Menubar :model="menubarItems" class="app-menu my-0">
    <template #start>
      
    </template>
    <template #end>
      <SplitButton
        :icon="PrimeIcons.USER"
        :label="(authStore.user?.name+' '+authStore.user?.lastName)"
        :model="userMenuItems"
        class="p-button-rounded p-button-warning"
      ></SplitButton>
    </template>
  </Menubar>
</template>

<style scoped>
.app-menu {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  background-color: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(8px);
  z-index: 1000;
  border: 0;
  border-radius: 0;
}
</style>
