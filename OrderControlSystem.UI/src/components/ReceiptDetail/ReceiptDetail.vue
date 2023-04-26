<script setup>
import Dialog from "primevue/dialog";
import InputText from "primevue/inputtext";
import Button from "primevue/button";

import {watch, ref} from "vue";
import { DIALOG_TYPE } from "../../stores/appConst";
import useReceiptDetailApi from "../../api/receiptDetail.api";

const receiptDetailApi = useReceiptDetailApi();
const showDetailDialog = ref(false);
const submited = ref(false);
const receiptDetailModel = ref({});
const props = defineProps(["receiptDetailModel","receiptItem", "modelValue", "dialogType"]);
const emits = defineEmits(["update:modelValue", "addReceiptDetail"]);

watch(showDetailDialog, () => {
  if(props.dialogType==DIALOG_TYPE.ADD){
    receiptDetailModel.value={};
  }
  if(props.dialogType==DIALOG_TYPE.UPD){

    receiptDetailModel.value=props.receiptItem;
  }
  emits("update:modelValue", showDetailDialog.value);
});
watch(() => props.modelValue,() => {
    showDetailDialog.value = props.modelValue;
    emits("update:modelValue", showDetailDialog.value);
  }
);
async function submit() {
  let result = checkRequiredArea();
  if(result==true){
    return;
  }else{
  if (props.dialogType == DIALOG_TYPE.ADD) {
  emits("addReceiptDetail",receiptDetailModel.value);
  receiptDetailModel.value={};
  } else if(props.dialogType==DIALOG_TYPE.UPD){
   await receiptDetailApi.updateReceiptDetail(receiptDetailModel.value);
  }
  showDetailDialog.value = false;
  }
}
 

 const handleSubmit = () => {
  submit();
}
function checkRequiredArea(){
  if(!receiptDetailModel.value.stepNo||
    !receiptDetailModel.value.heatingTime||
    !receiptDetailModel.value.temperature){
      submited.value=true;
      return true;
    }else{
      return false;
    }
}

</script>
<template>
  <div>
    <Dialog
      header="Reçete Detayları"
      v-model:visible="showDetailDialog"
      :style="{ width: '15vw' }" class="col-12 md:col-6 p-0 "
    >
      <div class="grid p-fluid" style="align-items: center !important;" >
        <div class="field col md:col-7 lg:col-10">
          <label for="stepNo">Adım Sayısı</label>
          <InputText
            id="stepNo"
            v-model="receiptDetailModel.stepNo" 
          >
        </InputText>
        <small class="p-error" v-if="submited&&!receiptDetailModel.stepNo">Lütfen Değer Giriniz</small> 
        </div>
        <div class="field col md:col-7 lg:col-10">
          <label for="temperature">Sıcaklık (°C)</label>
          <InputText
            id="temperature"
            v-model="receiptDetailModel.temperature"
          >
        </InputText>
        <small class="p-error" v-if="submited&&!receiptDetailModel.temperature">Lütfen Değer Giriniz</small> 
        </div>
        <div class="field col md:col-7 lg:col-10">
          <label for="HeatingTime">Süre (Dk)</label>
          <InputText
            id="HeatingTime"
            v-model="receiptDetailModel.heatingTime"
          >
        </InputText>
        <small class="p-error" v-if="submited&&!receiptDetailModel.heatingTime">Lütfen Değer Giriniz</small> 
        </div>
        </div>
        <template #footer>
        <form @submit.prevent="handleSubmit()">
            <Button id="save" icon="pi pi-save" type="submit" label="Kaydet"></Button>
            </form>
        </template>
      
    </Dialog>
  </div>
</template>
