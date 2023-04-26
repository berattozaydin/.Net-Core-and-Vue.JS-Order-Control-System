<script>
import Dialog from "primevue/dialog";
import Button from "primevue/button";
import CheckBox from "primevue/checkbox";
import InputText from "primevue/inputtext";
import InputNumber from "primevue/inputnumber";
import useAccountStore from "../../stores/Account"; 
import { DIALOG_TYPE } from "../../stores/appConst";
import AppTextarea from "../app/AppTextarea.vue";
import CustomerDropdown from "../customer/CustomerDropdown.vue";

export default {
  components: { Dialog, Button, InputText, AppTextarea, CheckBox, CustomerDropdown,InputNumber },

  props: ["modelValue", "account", "dialogType"],

  emits: ["update:modelValue", "onSuccess", "onError"],

  setup() {
    const accountStore = useAccountStore();
    return { accountStore };
  },

  data() {
    return {
      DIALOG_TYPE,
      accountModel: {},
      checked:false,
      visibleDlg:false
    };
  },

  watch: {
    modelValue() {
      this.visibleDlg = this.modelValue
      if(this.dialogType == this.DIALOG_TYPE.ADD){
        this.accountModel ={};
      }if(this.dialogType == this.DIALOG_TYPE.UPD){
        this.accountModel = {...this.account};
      }
      this.$emit("update:modelValue", this.visibleDlg);
    },
  },

  computed: {
    modalName() {
      return this.dialogType == DIALOG_TYPE.ADD ? "Kullanıcı Hesabı Ekle" : "Kullanıcı Hesabı Düzenle";
    }
  },

  methods: {
    async saveAccount() {
      if (this.dialogType == DIALOG_TYPE.ADD) {
        await this.accountStore.addAccount(this.accountModel);
      } 
      if (this.dialogType == DIALOG_TYPE.UPD) {
        await this.accountStore.updateAccount(this.accountModel);
      }
      this.onSuccess();
    },

    onSuccess() {
      this.visibleDlg=false;
      this.$emit("update:modelValue",false);
      this.$emit("onSuccess");
    },

    onError() {
      this.$emit("onError");
    },
  },
};
</script>

<template>
  <Dialog v-model:visible="visibleDlg" maximizable modal position="top" class="col-12 md:col-8 p-0">
    <template #header>
      <h3>{{ modalName }}</h3>
    </template>

    <div class="grid">

      <div class="field col-6 md:col-3">
        <label for="CustomerId">CustomerId</label>
        <CustomerDropdown id="CustomerId" v-model="accountModel.customerId" class="w-full" />
 
      </div>

      <div class="field col-6 md:col-3">
        <label for="Username">Username</label>
        <InputText id="Username" v-model="accountModel.username" class="w-full" />
      </div>

      <div class="field col-6 md:col-3" v-if="dialogType == DIALOG_TYPE.ADD">
        <label for="Password">Password</label>
        <InputText id="Password" v-model="accountModel.password" type="password" class="w-full" />
      </div>

      <div class="field col-6 md:col-3">
        <label for="Role">Role</label>
        <InputNumber id="Role" v-model="accountModel.role" class="w-full" />
      </div>

      <div class="field col-6 md:col-3">
        <label for="Name">Name</label>
        <InputText id="Name" v-model="accountModel.name" class="w-full" />
      </div>

      <div class="field col-6 md:col-3">
        <label for="LastName">LastName</label>
        <InputText id="LastName" v-model="accountModel.lastName" class="w-full" />
      </div> 

      <div class="field col-6 md:col-3">
        <label for="Email">Email</label>
        <InputText id="Email" v-model="accountModel.email" class="w-full" />
      </div>

      <div class="field col-6 md:col-3">
        <label for="PhoneNumber">PhoneNumber</label>
        <InputText id="PhoneNumber" v-model="accountModel.phoneNumber" class="w-full" />
      </div> 
      <div class="field col-6 md:col-3">
        <label for="isActive">Is Active</label>
        <CheckBox id="isActive" v-model="accountModel.isActive" binary />
      </div> 

      <!-- <div class="field col-6 md:col-3" v-if="dialogType == DIALOG_TYPE.UPD">
        <CheckBox id="IsActive" v-model="accountModel.IsActive" binary />
        <label for="IsActive" class="m-2">IsActive</label>
      </div> -->

    </div>

    <template #footer>
      <Button label="Kapat" icon="pi pi-times" @click="modelValue = false" />
      <Button label="Kaydet" icon="pi pi-check" @click="saveAccount()" />
    </template>
  </Dialog>
</template>