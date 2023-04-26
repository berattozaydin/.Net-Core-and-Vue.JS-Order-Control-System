<script setup>
import Dialog from "primevue/dialog";
import TabView from "primevue/tabview";
import TabPanel from "primevue/tabpanel";
import { watch, ref } from "vue";

import OrderForm from "./OrderForm.vue";
import OrderDetailTable from "../orderDetail/OrderDetailTable.vue";
import { DIALOG_TYPE } from "../../stores/appConst";


const customer = ref(null);
const customerOrderItemModel = ref([]);
const showDialog = ref(false);
const props = defineProps([
  "modelValue",
  "customerOrder",
  "dialogType",
]);
const emits = defineEmits(["update:modelValue", "onSuccess","refresh","customerId"]);

watch(showDialog, async () => {
  customerOrderItemModel.value=[];
  emits("update:modelValue", showDialog.value);
});
watch(
  () => props.modelValue,
  () => {
    showDialog.value = props.modelValue;
    customer.value=0;
    emits("update:modelValue", showDialog.value);
  }
);
function closeDialog(item) {
  emits("refresh", item);
  emits("update:modelValue",item);
}
function customerOrderItem(item) {
  customerOrderItemModel.value = item
}
function customerAssing(item){
  customer.value = item;
}

</script>

<template>
  <Dialog
    v-model:visible="showDialog"
    class="col-12 md:col-10 p-0" 
    position="top"
    :header="props.dialogType == DIALOG_TYPE.ADD ? 'Yeni Bir Sipariş Ekle':(props.customerOrder + ' Numaralı Siparişi Düzenle')"
    maximizable
    modal
  >
    <TabView>
      <TabPanel header="Sipariş">
        <OrderForm
          :corderId="props.customerOrder"
          :dialogType="props.dialogType"
          :customerOrderItem="customerOrderItemModel"
          @refresh="closeDialog"
          @customerId="customerAssing"
        ></OrderForm>
      </TabPanel>

      <TabPanel header="Sipariş Detayları">
        <OrderDetailTable 
          :customerOrderId="props.customerOrder"
          :dialogType="props.dialogType"
          :customerId="customer"
          @addOrderDetail="customerOrderItem"
        ></OrderDetailTable>
      </TabPanel>
    </TabView>
    
  </Dialog>
</template>
