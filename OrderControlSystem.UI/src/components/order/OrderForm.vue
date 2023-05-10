<script setup>
import Button from "primevue/button";
import InputText from "primevue/inputtext";
import AppTextarea from "../app/AppTextarea.vue";

import { DIALOG_TYPE } from "../../stores/appConst";
import AppForm from "../app/AppForm.vue";
import CustomerDropdown from "../customer/CustomerDropdown.vue";
import {ref, watch} from 'vue';
import {dateToIso} from "../../helper";
import useCustomerOrderApi from "../../api/custormerOrder.api";
import CustomerOrderStatusDropdown from "./CustomerOrderStatusDropdown.vue";
import { mbox } from "../../plugins/dialogService";

const customerOrderApi = useCustomerOrderApi();
const props = defineProps(["corderId","customerOrderItem","dialogType"]);
const emits = defineEmits(["update:modelValue","customerOrder","refresh","customerId"]);
const customerOrderModel = ref({customerOrderItems:[]});
const submited = ref(false);

async function setDefaultCustomerOrder(){
    customerOrderModel.value.orderNumber = await customerOrderApi.getCustomerOrderNumber();
}
async function saveCustomerOrder(){
  if(!customerOrderModel.value.orderNumber||
    !customerOrderModel.value.customerId||
    !customerOrderModel.value.customerOrderStatusId||
    !customerOrderModel.value.name||
    !customerOrderModel.value.remark){
      submited.value=true;
      return;
    }
 
    if(customerOrderModel.value.orderNumber.length >15){
      mbox("Sipariş Numarası 15 Karakterden Büyük Olamaz")
      return;
    }
  customerOrderModel.value.customerOrderItems = props.customerOrderItem;
  if(props.dialogType==DIALOG_TYPE.ADD){
    customerOrderModel.value.createdDate = dateToIso(Date.now());
   await customerOrderApi.addCustomerOrder(customerOrderModel.value);
}
if(props.dialogType==DIALOG_TYPE.UPD){
  await customerOrderApi.updateCustomerOrder(customerOrderModel.value);
}
emits("refresh",false);
}
watch(()=>customerOrderModel.value.customerId,()=>{
  emits("customerId",customerOrderModel.value.customerId);
});
</script>

<template>
  <AppForm> 
    <template #body>
      <div class="grid p-fluid"> 
        <div class="field col-12 md:col-4" style="display:none;" v-if="(props.dialogType==DIALOG_TYPE.UPD)">
          <label for="customerOrderId">Üretilen Sipariş Id</label>
          <InputText id="customerOrderId" v-model="customerOrderModel.customerOrderId" disabled></InputText>
        </div>
        <div class="field col-12 md:col-4">
          <label for="CustomerOrderId">Sipariş Numarası</label>
          <InputText id="customerOrderId" v-model="customerOrderModel.orderNumber" disabled></InputText>
          <small class="p-error" v-if="(submited&&!customerOrderModel.orderNumber)">Lütfen Değer Giriniz</small> 
        </div> 
        <div class="field col-12 md:col-4">
          <label for="CustomerOrderId">Barkod Numarası</label>
          <InputText id="customerOrderId" v-model="customerOrderModel.barcodeNumber" disabled></InputText>
          <small class="p-error" v-if="(submited&&!customerOrderModel.barcodeNumber)">Lütfen Değer Giriniz</small> 
        </div> 
        <div class="field col-12 md:col-4">
          <label for="customerId">Müşteri Adı</label>
          <CustomerDropdown id="customerId" v-model="customerOrderModel.customerId"></CustomerDropdown>
          <small class="p-error" v-if="submited&&!customerOrderModel.customerId">Lütfen Değer Giriniz</small> 
        </div> 
        <div class="field col-12 md:col-4">
          <label for="customerOrderStatusId">Sipariş Durumu</label>
          <CustomerOrderStatusDropdown id="customerOrderStatusId" v-model="customerOrderModel.customerOrderStatusId"/>
          <small class="p-error" v-if="submited&&!customerOrderModel.customerOrderStatusId">Lütfen Değer Giriniz</small> 
        </div> 
        <div class="field col-12 md:col-4">
          <label for="Name">Sipariş Adı</label>
          <InputText id="Name" v-model="customerOrderModel.name"/>
          <small class="p-error" v-if="submited&&!customerOrderModel.name">Lütfen Değer Giriniz</small> 
        </div> 
         <div class="field col-12 md:col-4">
          <label for="remark">Açıklama</label>
          <AppTextarea id="remark" v-model="customerOrderModel.remark" :maxlength="255"/>
          <small class="p-error" v-if="submited&&!customerOrderModel.remark">Lütfen Değer Giriniz</small> 
        </div>
      </div>
    </template>
    <template #footer>
    <Button label="kaydet" @click="saveCustomerOrder()"></Button>
    </template>
  </AppForm>
</template>