<template>
  <Dropdown
    v-model="selectedProcessSteps"
    :options="processSteps"
    optionLabel="name"
    optionValue="processStepsId"
    placeholder="İşlem Seçiniz"
    :showClear="dropdownShowClear"
  />
</template>

<script setup>
import { ref, watch,onMounted } from "vue";
import Dropdown from "primevue/dropdown";
import useProcessStepsApi from "../../api/processSteps.api";

const processStepsApi = useProcessStepsApi();
const emits = defineEmits(["update:modelValue"]);
const selectedProcessSteps = ref();
const dropdownShowClear = ref(false);
const processSteps = ref([]);

watch(
  () => props.furnanceId,
  async () => {
      dropdownShowClear.value=true;
  }
);
watch(selectedProcessSteps, () => {
  emits("update:modelValue", selectedProcessSteps.value);
});

onMounted(async ()=>{
  await getReceiptList()
})
async function getReceiptList(){
  processSteps.value = await processStepsApi.getProcessStepssList();
}
</script>
