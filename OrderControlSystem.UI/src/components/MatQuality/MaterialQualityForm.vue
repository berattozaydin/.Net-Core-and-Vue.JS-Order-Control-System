<template>
     <div class="p-grid p-fluid">
    <div class="p-field p-col-12">
      <label for="code">Kalite Kodu</label>
      <InputText  v-model="materialQualityModel.code" />
       <small class="p-error" v-if="submited &&!materialQualityModel.code">Lütfen Değer Giriniz</small> 
    </div>
    <div class="p-field p-col-12">
      <label for="Name">Kalite Adı</label>
      <InputText v-model="materialQualityModel.name" />
       <small class="p-error" v-if="submited&&!materialQualityModel.name">Lütfen Değer Giriniz</small>
 </div>
    <div class="p-field p-col-12">
      <label for="remark">Kalite Açıklaması</label>
      <AppTextarea v-model="materialQualityModel.remark" />
       <small class="p-error" v-if="submited&&!materialQualityModel.remark">Lütfen Değer Giriniz</small> 
    </div>
  </div>

        
    
</template>
<script setup>
import { ref,onMounted } from 'vue';
import AppTextarea from '../app/AppTextarea.vue';
import InputText from 'primevue/inputtext';
import useMaterialQualityApi from '../../api/materialQuality.api';
import { DIALOG_TYPE } from '../../stores/appConst';
import {dateToIso} from "../../helper.js";
const materialQualityApi = useMaterialQualityApi();
const props = defineProps(["dialogType","matQId"]);
const emits = defineEmits(["closeDialog"]);
const submited = ref(false);
const materialQualityModel = ref({});

onMounted(async()=>{
    if(props.dialogType == DIALOG_TYPE.ADD){
        materialQualityModel.value={};
    }
    if(props.dialogType==DIALOG_TYPE.UPD){
        materialQualityModel.value= (await materialQualityApi.getMaterialQuality(props.matQId))[0];
    }
});
defineExpose({
    saveMatQ,
});
async function saveMatQ(){
    let result = submits();
    if(result == true){
        return;
    }else{
        materialQualityModel.value.updatedDatetime = dateToIso(Date.now());
        if(props.dialogType == DIALOG_TYPE.ADD){
        await materialQualityApi.AddMaterialQuality(materialQualityModel.value);
    }
    if(props.dialogType==DIALOG_TYPE.UPD){
        await materialQualityApi.updateMaterialQuality(materialQualityModel.value);
    }
    emits("closeDialog",false);
    }
   
}

function submits(){
    if(!materialQualityModel.value.name||
    !materialQualityModel.value.remark||
    !materialQualityModel.value.code){
        submited.value=true;
        return true;

    }else{
        return false;
    }
  }

</script>