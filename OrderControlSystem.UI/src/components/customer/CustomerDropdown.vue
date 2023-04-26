<script setup>
import Dropdown from "primevue/dropdown";
import useCustomerApi from "../../api/customer.api";
import { watch, onMounted, ref } from 'vue'

const props = defineProps(["modelValue"])
const emits = defineEmits(["update:modelValue", "onValueChange"])
const customerApi = useCustomerApi();
const customerModel = ref([]);
const customerValue = ref([]);

watch(() => props.modelValue, () => {
  customerValue.value = props.modelValue;
},{immediate:true})

watch(customerValue, () => {
  emits("update:modelValue", customerValue.value);
})

async function fetchCustomers() {
  customerModel.value = await customerApi.fetchCustomer();
}

onMounted(() => {
  fetchCustomers();
})

</script>

<template>
  <Dropdown v-model="customerValue" :options="customerModel" optionLabel="companyName" optionValue="customerId"
    placeholder="Müşteri Seçiniz" filter v-bind="$attrs" />
</template>