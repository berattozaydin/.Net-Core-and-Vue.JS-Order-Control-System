<template>
  <Dialog
    header="Reçeteler"
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
            <label for="name">Reçete İsmi</label>
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

    <h2>Detaylar</h2>
    <DataTable
      :value="processStepsModel?.receiptDetails"
      class="dataTable"
      responsiveLayout="scroll"
    >
      <Column header="Adım No" field="stepNo">
      </Column>
      <Column header="Sıcaklık (°C)" field="temperature">
      </Column>
      <Column header="Süre (Dk)" field="heatingTime">
      </Column>
      <Column>
        <template #header>
          <Button
           
            label="Ekle"
            icon="pi pi-plus"
            class="btn btn-success"
            @click="add()"
          ></Button>
        </template>
        <template #body="slotprops">
          <Button
            label="Sil"
            class="btn-btn-danger"
            @click="deleteReceiptDetails(slotprops.data)"
            ></Button
          >
          <br />
          <Button
            label="Düzenle"
            class="btn-btn-warning"
            @click="editReceiptDetails(slotprops.data)"
            ></Button
          >
          <br />
        </template>
      </Column>
    </DataTable>
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
  <!--<ReceiptDetail
    v-model="displayDetailBasic"
    :receiptItem="displayDetailModel"
    :dialogType="receiptDetailDialogType"
    @addReceiptDetail="addReceipDetail"
  />-->
</template>
<script setup>
import Dialog from "primevue/dialog";
import Button from "primevue/button";
import DataTable from "primevue/datatable";
import Column from "primevue/column";
import InputText from "primevue/inputtext";

import { watch, ref } from "vue";
import AppTextarea from "../app/AppTextarea.vue";
import AppForm from "../app/AppForm.vue";
import TreatmentType from "../TreatmentType/TreatmentTypeDropdown.vue";
//import ReceiptDetail from "../ReceiptDetail/ReceiptDetail.vue";
import { DIALOG_TYPE } from "../../stores/appConst";
import ProcessStepsApi from "../../api/processSteps.api";
import useReceiptDetailApi from "../../api/receiptDetail.api";
const receiptDetailApi = useReceiptDetailApi();
const processStepsApi = ProcessStepsApi();
const processStepsModel = ref({receiptDetails: []});
const displayDetailBasic = ref(false);
const displayDetailModel = ref({});
const props = defineProps(["modelValue", "dialogType", "receiptId"]);
const showDialog = ref(false);
const emits = defineEmits(["update:modelValue","refreshReceipt"]);
const submited = ref(false);
const receiptDetailDialogType = ref();
function add() {
  displayDetailBasic.value = true;
  receiptDetailDialogType.value = DIALOG_TYPE.ADD;
}
function editReceiptDetails(slotprops) {
  receiptDetailDialogType.value = DIALOG_TYPE.UPD;
  displayDetailModel.value = slotprops;
  displayDetailBasic.value = true;
}
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

async function deleteReceiptDetails(receiptDetail) {
  let index = processStepsModel.value.receiptDetails.findIndex(
    (x) => x.receiptDetailId == receiptDetail.receiptDetailId
  );
  if (props.dialogType == DIALOG_TYPE.ADD)
      processStepsModel.value.receiptDetails.splice(index, 1);
  if (props.dialogType == DIALOG_TYPE.UPD){
    await receiptDetailApi.deleteReceiptDetail(receiptDetail.receiptDetailId);
    fetchReceiptDetails();
  }
}
async function fetchReceiptDetails(){
  processStepsModel.value.receiptDetails= await receiptDetailApi.getReceiptDetail(props.receiptId);
}
watch(showDialog, async () => {
  if (props.dialogType == DIALOG_TYPE.ADD) {
    processStepsModel.value = { receiptDetails: [] };
  }
  if (props.dialogType == DIALOG_TYPE.UPD) {
    if(showDialog.value==true){
      processStepsModel.value = (await processStepsApi.getProcessSteps(props.receiptId))[0];
    fetchReceiptDetails();
    }

  } 
  emits("update:modelValue", showDialog.value);
});
function addReceipDetail(receiptDetail) {
  processStepsModel.value.receiptDetails.push(receiptDetail);
}
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
