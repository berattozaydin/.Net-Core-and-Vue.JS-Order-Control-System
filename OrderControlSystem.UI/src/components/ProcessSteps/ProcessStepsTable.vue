<script setup>

import DataTable from "primevue/datatable";
import InputText from "primevue/inputtext";

import Column from "primevue/column";
import Button from "primevue/button";
import Toolbar from 'primevue/toolbar'
import { PrimeIcons } from "primevue/api";
import AppInfoEmpty from "../app/AppInfoEmpty.vue";
import AppBaseLayout from "../app/AppBaseLayout.vue";
import {toastSuccess} from "../../plugins/toastService";
import { ref, watch, onMounted } from 'vue'
import ReceiptDlg from './ReceiptDlg.vue'
import { DIALOG_TYPE } from "../../stores/appConst";
import ConfirmDialog from "primevue/confirmdialog";

import ReceiptApi from "../../api/receipts.api";
import ReceiptReportDialog from "./ReceiptReportDialog.vue";

const receiptApi = ReceiptApi();

const displayBasic = ref(false);
const props = defineProps(["modelValue"]);
const displayReceiptReportDlg = ref(false);
const receiptDialogType = ref(null);
const processStepsModel = ref([]);
const selectedProcessSteps = ref([]);
const filters = ref({
  global: { value: "", matchMode: "contains" },
  receiptId: {value: "", matchMode: "contains" },
  furnaceName:{value:"",matchMode:"contains"},
  treatmentTypeName:{value:"",matchMode:"contains"},
  name:{value:"",matchMode:"contains"}
})
const lazyParams=ref({
                    Page: 0,
                    First: 0,
                    Rows: 20,
                    SortField: "receiptId",
                    SortOrder: 1,
                    filters: filters.value,
                });
const fetchReceipts = async () => {
  processStepsModel.value=await receiptApi.getAll(lazyParams.value);
}
onMounted(() => {
   fetchReceipts();
})

async function getReportReceipt(item){
  displayReceiptReportDlg.value=true;
    processStepsModel.value=item;
}
function receiptDlg(cmd,slotprops=null){
  if(cmd === 'create')
  {
    receiptDialogType.value=DIALOG_TYPE.ADD;
  }
  if(cmd === 'update')
  {
    selectedProcessSteps.value=slotprops
    receiptDialogType.value=DIALOG_TYPE.UPD;
  }
  displayBasic.value=true;
}
const deleteReceipt=async (receipt)=>{
  toastSuccess(receipt.name+" reçetesi silindi.");
  await receiptApi.deleteReceipt(receipt.receiptId);
  fetchReceipts();
}
function onPage(event){
  lazyParams.value = event;
  fetchReceipts();
}

function onSort(event){
  lazyParams.value.SortField=event.sortField;
  lazyParams.value.SortOrder=event.sortOrder;
  fetchReceipts();

}

function onFilter(){
  lazyParams.value.filters = filters.value;
  fetchReceipts();
  
}
watch(filters,()=>{
  onFilter();
})
</script>
 <template>
 <ConfirmDialog></ConfirmDialog>
  <app-base-layout>
    <Toolbar class="mb-4">
      <template #start>
      </template>
    </Toolbar>
    <DataTable :lazy="true" 
          :loading="receiptApi.receiptsLoading.value" 
          class="dataTable" 
          :value="processStepsModel" 
          v-model:filters="filters" 
          :paginator="true" 
          :rows="20"
          paginatorPosition="top"
          filterDisplay="row"
          dataKey="processStepsId"
          @page="onPage($event)"
          @sort="onSort($event)"
          :sortOrder="1"
          >
      <template #paginatorstart>
        <h3>İşlemler</h3>
      </template>
      <template #paginatorend>
        <Button label="Sipariş İşlemi Ekle" :icon="PrimeIcons.PLUS" class="p-button-success p-button-rounded mr-2" @click="receiptDlg('create')" />
        <span class="p-input-icon-left">
          <i class="pi pi-search" />
          <InputText v-model="filters.global.value" placeholder="Ara..." />
        </span>

        <Button :icon="PrimeIcons.REFRESH" class="p-button-rounded p-button-outlined mx-2" @click="fetchReceipts()" />
      </template>
      <Column field="processStepsId" header="Id" sortable> 
        <template #filter="{ filterModel, filterCallback }">
                    <InputText type="text" v-model="filterModel.value" @keydown.enter="filterCallback()"
                               class="p-column-filter" placeholder="Ara..." />
                </template>
      </Column>
      <Column field="treatmentTypeName" header="İşlem Tipi" sortable>
        <template #filter="{ filterModel, filterCallback }">
                    <InputText type="text" v-model="filterModel.value" @keydown.enter="filterCallback()"
                               class="p-column-filter" placeholder="Ara..." />
                </template>
      </Column>
      <Column field="name" header="İsmi" sortable>
        <template #filter="{ filterModel, filterCallback }">
                    <InputText type="text" v-model="filterModel.value" @keydown.enter="filterCallback()"
                               class="p-column-filter" placeholder="Ara..." />
                </template>
      </Column>
      <Column field="remark" header="Açıklama" sortable></Column>
   


      <Column :exportable="false" style="min-width:8rem">
        <template #body="slotProps">
          <Button :icon="PrimeIcons.PENCIL"
            class="p-button-primary p-button-rounded p-button-outlined mr-2"  @click="receiptDlg('update',slotProps.data)" />
          <Button :icon="PrimeIcons.TRASH" class="p-button-rounded p-button-danger p-button-outlined mr-2"  @click="deleteReceipt(slotProps.data)" />
          <Button :icon="PrimeIcons.CHART_BAR" class="p-button-info p-button-rounded p-button-outlined mr-2"  @click="getReportReceipt(slotProps.data)" />
       
        </template>
      </Column>
      <template #empty>
        <AppInfoEmpty />
      </template>
    </DataTable>
  </app-base-layout>
    <ReceiptReportDialog v-model="displayReceiptReportDlg" :receiptId="processStepsModel.processStepsId"></ReceiptReportDialog>
    <ReceiptDlg v-model="displayBasic" :dialogType="receiptDialogType" :receiptId="selectedProcessSteps.processStepsId" @refreshReceipt="fetchReceipts"/>
    </template>

