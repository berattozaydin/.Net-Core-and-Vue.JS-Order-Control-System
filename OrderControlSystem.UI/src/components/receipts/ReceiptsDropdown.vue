<template>
  <Dropdown
    v-model="selectedReceipt"
    :options="receiptFilter"
    optionLabel="name"
    optionValue="receiptId"
    placeholder="Reçete Seçiniz"
    :showClear="dropdownShowClear"
  />
</template>

<script setup>
import { ref, watch,onMounted } from "vue";
import Dropdown from "primevue/dropdown";
import useReceiptApi from "../../api/receipts.api";

const receiptApi = useReceiptApi();

const props = defineProps(["furnanceId"]);
const emits = defineEmits(["update:modelValue"]);
const selectedReceipt = ref();
const dropdownShowClear = ref(false);
const receipts = ref([]);
const receiptFilter = ref([]);

watch(
  () => props.furnanceId,
  async () => {
      dropdownShowClear.value=true;
        receiptListfilter();
  }
);
watch(selectedReceipt, () => {
  emits("update:modelValue", selectedReceipt.value);
});
function receiptListfilter(){
  receiptFilter.value=[];
    for(var i = 0 ; i<receipts.value.length;i++){
        if(receipts.value[i].furnance.furnanceId == props.furnanceId){
          receiptFilter.value.push(receipts.value[i]);
        }
    }
}
onMounted(async ()=>{
  await getReceiptList()
  receiptListfilter()
})
async function getReceiptList(){
  receipts.value = await receiptApi.getReceiptsList();
}
</script>
