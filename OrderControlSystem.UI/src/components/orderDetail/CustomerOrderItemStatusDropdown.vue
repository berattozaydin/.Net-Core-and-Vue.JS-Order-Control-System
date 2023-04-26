<template>
<Dropdown v-model="customerOrderItemStatusValue" :options="customerOrderItemStatus" optionLabel="name" optionValue="customerOrderItemStatusId" placeholder="Alt Kalem durumu Seçiniz" />
</template>

<script setup>
import Dropdown from "primevue/dropdown";
import { ref, watch,onMounted } from "vue";
import useCustomerOrderDetailApi from "../../api/customerOrderDetail.api";
const props = defineProps(["modelValue"]);
const emits = defineEmits(["update:modelValue", "onValueChange"]);
const customerOrderItemStatusValue = ref();
const customerOrderItemStatus = ref([]);
const customerOrderDetailApi =useCustomerOrderDetailApi();
async function fetchCustomerOrderItemStatus(){
    customerOrderItemStatus.value= await customerOrderDetailApi.getCustomerOrderItemStatus();
}

onMounted(()=>{
    fetchCustomerOrderItemStatus();
})

watch(() => props.modelValue, () => {
    customerOrderItemStatusValue.value = props.modelValue;
})

watch(customerOrderItemStatusValue, () => {
  emits("update:modelValue", customerOrderItemStatusValue.value);
  emits("onValueChange", customerOrderItemStatusValue.value);
})
</script>