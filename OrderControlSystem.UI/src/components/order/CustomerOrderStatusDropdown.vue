<template>

<Dropdown v-model="customerOrderStatusValue" :options="customerOrderStatus" optionLabel="name" optionValue="customerOrderStatusId" placeholder="Sipariş Durumu Seçiniz" />
    
</template>

<script setup>
import Dropdown from "primevue/dropdown";
import { ref,watch,onMounted } from "vue";
import useCustomerOrderApi from "../../api/custormerOrder.api";
const customerOrderApi = useCustomerOrderApi();
const props = defineProps(["modelValue"]);
const emits=defineEmits(["update:modelValue", "onValueChange"]);
const customerOrderStatus =ref([]); 
const customerOrderStatusValue =ref(); 

async function fetchCustomerOrderStatus(){
    customerOrderStatus.value= await customerOrderApi.getCustomerOrderStatus();
}
onMounted(() => {
    fetchCustomerOrderStatus();
})

watch(() => props.modelValue, () => {
    customerOrderStatusValue.value = props.modelValue;
})

watch(customerOrderStatusValue, () => {
  emits("update:modelValue", customerOrderStatusValue.value);
  emits("onValueChange", customerOrderStatusValue.value);
})

</script>