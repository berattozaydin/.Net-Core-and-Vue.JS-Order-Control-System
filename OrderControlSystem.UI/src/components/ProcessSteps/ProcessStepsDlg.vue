<template>
  <Dialog
    header="İşlemler"
    position="top"
    v-model:visible="showDialog"
    :breakpoints="{ '960px': '75vw', '640px': '90vw' }"
    :style="{ width: '50vw' }"
    maximizable
    @hide="closeDialog()"
  >
    <AppForm>
      <template #body>
        <div class="grid p-fluid">
          <div class="field col-12 md:col-3">
            <label for="name">İşlem İsmi</label>
            <InputText v-model="processStepsModel.name"></InputText>
            <small class="p-error" v-if="submited&&!processStepsModel.name">Lütfen Değer Giriniz</small> 
          </div>
          <div class="field col-12 md:col-3">
            <label for="treatmentTypeId">İşlem Tipi</label>
            <TreatmentType
              v-model="processStepsModel.treatmentTypeId"
            ></TreatmentType>
            <small class="p-error" v-if="submited&&!processStepsModel.treatmentTypeId">Lütfen Değer Giriniz</small> 
          </div>
          <div class="field col-12 md:col-3">
            <label for="remark">Açıklama</label>
            <AppTextarea v-model="processStepsModel.remark"></AppTextarea>
            <small class="p-error" v-if="submited&&!processStepsModel.remark">Lütfen Değer Giriniz</small> 
          </div>
        </div>
      </template>
    </AppForm>
    <template #footer>
      <Button
        label="Vazgeç"
        icon="pi pi-times"
        @click="closeDialog()"
        class="p-button-text"
      />
      <Button label="Kaydet" icon="pi pi-save" @click="addReceiptTable()" />
    </template>
  </Dialog>

</template>
<script setup>
import Dialog from "primevue/dialog";
import Button from "primevue/button";
import InputText from "primevue/inputtext";

import { watch, ref } from "vue";
import AppTextarea from "../app/AppTextarea.vue";
import AppForm from "../app/AppForm.vue";
import TreatmentType from "../TreatmentType/TreatmentTypeDropdown.vue";
import { DIALOG_TYPE } from "../../stores/appConst";
import ProcessStepsApi from "../../api/processSteps.api";
const processStepsApi = ProcessStepsApi();
const processStepsModel = ref({receiptDetails: []});
const props = defineProps(["modelValue", "dialogType", "processStepsId"]);
const showDialog = ref(false);
const emits = defineEmits(["update:modelValue","refreshProcessSteps"]);
const submited = ref(false);

async function addReceiptTable() {
  if(!processStepsModel.value.name||
    !processStepsModel.value.remark||
    !processStepsModel.value.treatmentTypeId){
      submited.value=true;
      return;
    }
  if (props.dialogType == DIALOG_TYPE.ADD) {
    await processStepsApi.addProcessSteps(processStepsModel.value);
  }
  if (props.dialogType == DIALOG_TYPE.UPD) {
    await processStepsApi.updateProcessSteps(processStepsModel.value);
  }
  showDialog.value=false;
  emits("refreshReceipt",true);
}

watch(showDialog, async () => {
  if (props.dialogType == DIALOG_TYPE.ADD) {
    processStepsModel.value = { };
  }
  if (props.dialogType == DIALOG_TYPE.UPD) {
    if(showDialog.value==true){
      processStepsModel.value = (await processStepsApi.getProcessSteps(props.processStepsId))[0];
    }

  } 
  emits("update:modelValue", showDialog.value);
});
watch(
  () => props.modelValue,
  async () => {
    showDialog.value = props.modelValue;
    emits("update:modelValue", showDialog.value);

  }
);
function closeDialog() {
  showDialog.value=false;
  emits("update:modelValue", false);
}
</script>
