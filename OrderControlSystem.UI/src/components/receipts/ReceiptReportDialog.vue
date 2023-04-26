<template>
<Dialog header="Reçete Raporu" v-model:visible="dialogShow" :breakpoints="{'960px': '75vw', '640px': '90vw'}" :style="{width: '80vw'}">
      
</Dialog>

</template>
<script setup>
import Dialog from 'primevue/dialog';
import { ref, watch} from 'vue';
const props = defineProps(["modelValue","receiptId"]);
const emits = defineEmits(["update:modelValue"]);
const dialogShow = ref(false);
watch(()=>dialogShow.value,()=>{
    emits("update:modelValue",dialogShow.value);
})
watch(()=>props.modelValue,()=>{
    dialogShow.value=props.modelValue;
    emits("update:modelValue",dialogShow.value);
})
</script>