<template>
    <ConfirmDialog></ConfirmDialog>
  <AppBaseLayout>
    <Toolbar class="mb-4">
      <template #start>
        
      </template>
    </Toolbar>
<DataTable :loading="materialQualityApi.materialQualityLoading.value" class="dataTable" :value="materialQualityModel" responsiveLayout="scroll"  :paginator="true" :rows="20"
      paginatorPosition="top" stripedRows v-model:filters="filters" :globalFilterFields="['code', 'name','createdDatetime']" dataKey="materialQualityId">
      <template #paginatorstart>
        <h3>Kaliteler</h3>
      </template>
      <template #paginatorend>
        <Button
          label="Kalite Ekle"
          :icon="PrimeIcons.PLUS"
          class="p-button-success p-button-rounded mr-2"
          @click="addNewMaterialQuality()"
        />
        <span class="p-input-icon-left">
          <i class="pi pi-search" />
          <InputText v-model="filters.global.value" placeholder="Ara..." />
        </span>

        <Button
        :icon="PrimeIcons.REFRESH" class="p-button-rounded p-button-outlined mx-2"
          @click="fetchMaterialQuality()"
        />
      </template>
            <Column field="code" header="Kalite Kodu"></Column>
            <Column field="name" header="Adı"></Column>
            <Column field="remark" header="Açıklaması"></Column>
            <Column field="createdDatetime" header="Oluşturma Tarihi">
            <template #body="slotprops">
                {{ formatDatetime(slotprops.data?.createdDatetime) }}
            </template>
            </Column>
            <Column field="updatedDatetime" header="Güncelleme Tarihi">
            <template #body="slotprops">
                {{ formatDatetime(slotprops.data?.updatedDatetime) }}
            </template>
            </Column>
            <Column :exportable="false" style="min-width: 8rem">
        <template #body="slotProps">
          <Button
          :icon="PrimeIcons.PENCIL"
            class="p-button-primary p-button-rounded p-button-outlined mr-2"
            @click="editMaterialQuality(slotProps.data)"
          />
          <Button
          :icon="PrimeIcons.TRASH" class="p-button-rounded p-button-danger p-button-outlined mr-2"
            @click="deleteMaterialQuality(slotProps.data)"
          />
        </template>
      </Column>
</DataTable>
       </AppBaseLayout> 
    <MaterialQualityDialog v-model="matQDialogShow" :dialogType="matQDialogType" :matQId="selectedMaterialQuality.materialQualityId" @refresh="fetchMaterialQuality"></MaterialQualityDialog>
</template>
<script setup>
import DataTable from 'primevue/datatable';
import Column from 'primevue/column';
import Button from "primevue/button";
import Toolbar from "primevue/toolbar";
import InputText from "primevue/inputtext";
import ConfirmDialog from "primevue/confirmdialog";
import AppBaseLayout from "../app/AppBaseLayout.vue";
import { DIALOG_TYPE } from "../../stores/appConst";
import { PrimeIcons, FilterMatchMode,FilterOperator } from "primevue/api";
import {formatDatetime} from '../../utilty/time';
import useMaterialQualityApi from '../../api/materialQuality.api';
import { onMounted, ref } from 'vue';
import MaterialQualityDialog from '../MatQuality/MaterialQualityDialog.vue';
import {cbox} from '../../plugins/dialogService';
const materialQualityApi = useMaterialQualityApi();
const materialQualityModel = ref([]);
const matQDialogType = ref(DIALOG_TYPE.ADD);
const matQDialogShow = ref(false);
const selectedMaterialQuality = ref([]);
const filters = ref({
  global: { value: "", matchMode: FilterMatchMode.CONTAINS },
});
async function fetchMaterialQuality(item){
    materialQualityModel.value=await materialQualityApi.getMaterialQualities();
}
onMounted(()=>{
    fetchMaterialQuality();
});
function addNewMaterialQuality(){
    matQDialogType.value=DIALOG_TYPE.ADD;
    matQDialogShow.value=true;
}
function editMaterialQuality(item){
    selectedMaterialQuality.value=item;
    matQDialogType.value=DIALOG_TYPE.UPD;
    matQDialogShow.value=true;
}
function deleteMaterialQuality(item){
    cbox(item.name+" Adlı Kalite Silinecek",async()=>{
    await materialQualityApi.deleteMaterialQuality(item.materialQualityId);
    fetchMaterialQuality();
  });
}


</script>