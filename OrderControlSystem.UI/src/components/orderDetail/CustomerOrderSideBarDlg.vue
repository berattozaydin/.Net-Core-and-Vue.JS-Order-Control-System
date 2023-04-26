<template>
<Dialog header="Header" v-model:visible="displayModal" :breakpoints="{'960px': '75vw', '640px': '90vw'}" :style="{width: '100vw'}" :modal="true">
    <OrderDetailTable :dialogType="'sideBarDlg'" :customerOrderId="props.customerOrderItem">
    </OrderDetailTable>
</Dialog>

</template>
<script setup>
import Dialog from 'primevue/dialog';
import { ref ,watch} from 'vue';
import OrderDetailTable from './OrderDetailTable.vue';
const props = defineProps(["customerOrderItem","modelValue"]);
const emits = defineEmits(["update:modelValue"]);
const displayModal = ref(false);
watch(
     ()=> props.modelValue,
        () => {
            displayModal.value = props.modelValue;
          emits("update:modelValue", showDialog.value);
             }
        );
</script>