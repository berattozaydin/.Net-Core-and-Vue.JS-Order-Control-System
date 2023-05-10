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
import ProcessStepsDlg from './ProcessStepsDlg.vue'
import { DIALOG_TYPE } from "../../stores/appConst";
import ConfirmDialog from "primevue/confirmdialog";

import ProcessStepsApi from "../../api/processSteps.api";

const processStepsApi = ProcessStepsApi();

const displayBasic = ref(false);
const props = defineProps(["modelValue"]);
const processStepsDlgType = ref(null);
const processStepsModel = ref([]);
const selectedProcessSteps = ref([]);
const filters = ref({
  global: { value: "", matchMode: "contains" },
  processStepsId: {value: "", matchMode: "contains" },
  furnaceName:{value:"",matchMode:"contains"},
  treatmentTypeName:{value:"",matchMode:"contains"},
  name:{value:"",matchMode:"contains"}
})
const lazyParams=ref({
                    Page: 0,
                    First: 0,
                    Rows: 20,
                    SortField: "processStepsId",
                    SortOrder: 1,
                    filters: filters.value,
                });
const fetchProcessSteps = async () => {
  processStepsModel.value=await processStepsApi.getAll(lazyParams.value);
}
onMounted(() => {
   fetchProcessSteps();
})

function processStepsDlg(cmd,slotprops=null){
  if(cmd === 'create')
  {
    processStepsDlgType.value=DIALOG_TYPE.ADD;
  }
  if(cmd === 'update')
  {
    selectedProcessSteps.value=slotprops
    processStepsDlgType.value=DIALOG_TYPE.UPD;
  }
  displayBasic.value=true;
}
const deleteProcessSteps=async (processSteps)=>{
  toastSuccess(processSteps.name+" işlemi silindi.");
  await processStepsApi.deleteProcessSteps(processSteps.processStepsId);
  fetchProcessSteps();
}
function onPage(event){
  lazyParams.value = event;
  fetchProcessSteps();
}

function onSort(event){
  lazyParams.value.SortField=event.sortField;
  lazyParams.value.SortOrder=event.sortOrder;
  fetchProcessSteps();

}

function onFilter(){
  lazyParams.value.filters = filters.value;
  fetchProcessSteps();
  
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
          :loading="processStepsApi.processStepssLoading.value" 
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
        <Button label="Sipariş İşlemi Ekle" :icon="PrimeIcons.PLUS" class="p-button-success p-button-rounded mr-2" @click="processStepsDlg('create')" />
        <span class="p-input-icon-left">
          <i class="pi pi-search" />
          <InputText v-model="filters.global.value" placeholder="Ara..." />
        </span>

        <Button :icon="PrimeIcons.REFRESH" class="p-button-rounded p-button-outlined mx-2" @click="fetchProcessSteps()" />
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
            class="p-button-primary p-button-rounded p-button-outlined mr-2"  @click="processStepsDlg('update',slotProps.data)" />
          <Button :icon="PrimeIcons.TRASH" class="p-button-rounded p-button-danger p-button-outlined mr-2"  @click="deleteProcessSteps(slotProps.data)" />       
        </template>
      </Column>
      <template #empty>
        <AppInfoEmpty />
      </template>
    </DataTable>
  </app-base-layout>
    <ProcessStepsDlg v-model="displayBasic" :dialogType="processStepsDlgType" :receiptId="selectedProcessSteps.processStepsId" @refreshReceipt="fetchProcessSteps"/>
    </template>

