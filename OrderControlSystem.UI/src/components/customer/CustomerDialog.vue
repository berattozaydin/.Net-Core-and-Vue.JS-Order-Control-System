

<script>
import Dialog from "primevue/dialog";
import Button from "primevue/button";
import InputText from "primevue/inputtext";
import useCustomerStore from "../../stores/Customer";
import { DIALOG_TYPE } from "../../stores/appConst";
import AppTextarea from "../app/AppTextarea.vue";

export default {
  components: { Dialog, Button, InputText, AppTextarea },

  props: ["modelValue", "customer", "dialogType"],

  emits: ["update:modelValue", "onSuccess", "onError"],

  setup() {
    const customerStore = useCustomerStore();
    return { customerStore };
  },

  data() {
    return {
      customerModel: {},
      dialog: {},
    };
  },

  watch: {
    modelValue() { 
      this.dialog = this.modelValue;
    },
    dialog() {
      if (this.modelValue) {
        this.customerModel = { ...this.customer };
      }
      this.$emit("update:modelValue", this.modelValue);
    },
  },

  computed: {
    modalName() {
      return this.dialogType == DIALOG_TYPE.ADD ? "Müşteri Ekle" : "Müşteri Düzenle";
    }
  },

  methods: {
    async saveCustomer() {
      if (this.dialogType == DIALOG_TYPE.ADD) {
        await this.customerStore.addCustomer(this.customerModel);
      } else if (this.dialogType == DIALOG_TYPE.UPD) {
        await this.customerStore.updateCustomer(this.customerModel);
      }
      this.onSuccess();
    },

    onSuccess() {
      this.$emit("onSuccess");
    },

    onError() {
      this.$emit("onError");
    },
  },
};
</script>

<template>
  <Dialog v-model:visible="dialog" maximizable modal position="top" class="col-12 md:col-8 p-0">
    <template #header>
      <h3>{{ modalName }}</h3>
    </template>

    <div class="grid p-fluid">
      <div class="field col-6 md:col-3">
        <label for="CompanyName">CompanyName</label>
        <InputText id="CompanyName" v-model="customerModel.CompanyName"  />
      </div>
      
      <div class="field col-6 md:col-3">
        <label for="ContactName">ContactName</label>
        <InputText id="ContactName" v-model="customerModel.ContactName"  />
      </div>
      
      <div class="field col-6 md:col-3">
        <label for="ContactTitle">ContactTitle</label>
        <InputText id="ContactTitle" v-model="customerModel.ContactTitle"  />
      </div>
      
      <div class="field col-6 md:col-4">
        <label for="Address">Address</label>
        <AppTextarea id="Address" v-model="customerModel.Address"  />
      </div> 
      
      <div class="field col-6 md:col-2">
        <label for="PostalCode">PostalCode</label>
        <InputText id="PostalCode" v-model="customerModel.PostalCode"  />
      </div>
      
      <div class="field col-6 md:col-2">
        <label for="Town">Town</label>
        <InputText id="Town" v-model="customerModel.Town"  />
      </div>
      
      <div class="field col-6 md:col-2">
        <label for="City">City</label>
        <InputText id="City" v-model="customerModel.City"  />
      </div>
      
      <div class="field col-6 md:col-2">
        <label for="Country">Country</label>
        <InputText id="Country" v-model="customerModel.Country"  />
      </div>
      
      <div class="field col-6 md:col-3">
        <label for="Phone1">Phone1</label>
        <InputText id="Phone1" v-model="customerModel.Phone1"  />
      </div>
      
      <div class="field col-6 md:col-3">
        <label for="Phone2">Phone2</label>
        <InputText id="Phone2" v-model="customerModel.Phone2"  />
      </div>
      
      <div class="field col-6 md:col-3">
        <label for="Fax">Fax</label>
        <InputText id="Fax" v-model="customerModel.Fax"  />
      </div>
      
      <div class="field col-6 md:col-3">
        <label for="Email">Email</label>
        <InputText id="Email" v-model="customerModel.Email"  />
      </div>

    </div>

    <template #footer>
      <Button label="Kapat" icon="pi pi-times" @click="modelValue = false" />
      <Button label="Kaydet" icon="pi pi-check" @click="saveCustomer()" />
    </template>
  </Dialog>
</template>