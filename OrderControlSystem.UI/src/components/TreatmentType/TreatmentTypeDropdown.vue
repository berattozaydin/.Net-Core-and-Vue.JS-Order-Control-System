<script setup>
import { watch,ref, onMounted} from 'vue';
import Dropdown from 'primevue/dropdown';
import useTreatmentTypeApi from '../../api/tretmentType.api';
const treatmentTypeApi = useTreatmentTypeApi();
const arr = ref(
     [
    ])
const treatmentTypeId = ref();
const emits = defineEmits(["update:modelValue"]);
const props = defineProps(["modelValue"]);
onMounted(()=>{
    fetchTreatmentType();
})
async function fetchTreatmentType(){
    arr.value=await treatmentTypeApi.GetTreatmentTypeList();
}
watch(treatmentTypeId ,()=>emits("update:modelValue",treatmentTypeId.value));
watch(()=>props.modelValue,()=>treatmentTypeId.value=props.modelValue,{immediate:true});

</script>

<template>
    <div>
           <Dropdown v-model="treatmentTypeId" :options="arr" optionLabel="name" optionValue="treatmentTypeId" placeholder="İşlem Tipi Seçiniz" />    
    </div>
</template>