<script setup>
import DataTable from "primevue/datatable";
import InputText from "primevue/inputtext";
import Column from "primevue/column";
import Button from "primevue/button";
import FileUpload from "primevue/fileupload";
import { onMounted, ref, watch } from 'vue';

import { PrimeIcons, FilterMatchMode } from "primevue/api";
import OrderDetailDialog from "@/components/orderDetail/OrderDetailDialog.vue";

import { CUSTOMER_ORDER_ITEM_STATUS, DIALOG_TYPE } from "../../stores/appConst";
import AppBaseLayout from "../app/AppBaseLayout.vue";
import AppInfoEmpty from "../app/AppInfoEmpty.vue";
import { cbox,mbox } from "../../plugins/dialogService";
import { formatDatetime } from '../../utilty/time';
import OrderDetailSideBar from './OrderDetailSideBar.vue';
import useCustomerApi from '../../api/customer.api';
import useCustomerOrderDetailApi from "../../api/customerOrderDetail.api";
import useReportApi from "../../api/report.api";
import { downloadFile } from "../../helper";
import useTreatmentTypeApi from "../../api/tretmentType.api";
import useMaterialQualityApi from "../../api/materialQuality.api";

const filters = ref({
  global: { value: "", matchMode: FilterMatchMode.CONTAINS },
});

const customerOrderDetailApi = useCustomerOrderDetailApi();
const reportApi = useReportApi();
const customerApi = useCustomerApi();
const materialQualityApi = useMaterialQualityApi();
const treatmentTypeApi = useTreatmentTypeApi();
const orderDetailDialogType = ref(DIALOG_TYPE.ADD);
const showDialog = ref(false);
const props = defineProps(["isSelectedBoxShow", "customerOrderId", "dialogType","customerId"]);
const emits = defineEmits(["onSelectedOrderDetails", "onSideBarOrderDetails", "addOrderDetail"]);
const orderDetailModel = ref([]);
const orderDetails = ref([]);
const selectedOrderDetails = ref([]);
const showReportDlg = ref(false);
const selectedFile = ref(null);
const customer = ref([]);
const customerOrderItemStatus = ref([]);
const materialQuality= ref([]);
const treatmentType =ref([]);

onMounted(async () => {
    await fetchOrderDetails();
});
async function fetchDetail(){
  customerOrderItemStatus.value = await customerOrderDetailApi.getCustomerOrderItemStatus();
  customer.value = await customerApi.fetchCustomer();
  treatmentType.value = await treatmentTypeApi.GetTreatmentTypeList();
  materialQuality.value = await materialQualityApi.getMaterialQualities();
}
async function fetchOrderDetails() {
  if(props.dialogType == DIALOG_TYPE.ADD){
    await fetchDetail();
  }
  if(props.dialogType==DIALOG_TYPE.UPD){
    orderDetails.value = await customerOrderDetailApi.getCustomerOrderDetailList(props.customerOrderId);
  }
  if(props.dialogType=="sideBarDlg")
    orderDetails.value=props.customerOrderId;
}
function orderDetailDlg(cmd,orderDetail = null) {
  orderDetail == null ? orderDetailModel.value=[]:orderDetailModel.value = { ...orderDetail };
  if(cmd === 'create'){   
  orderDetailDialogType.value = DIALOG_TYPE.ADD;
  }
  if(cmd ==='update'){
    let selectedIndex = 0;
  selectedIndex = orderDetail.index;
  orderDetailModel.value[selectedIndex] = orderDetail;
  orderDetailDialogType.value = DIALOG_TYPE.UPD;
  }
  showDialog.value = true;
}
function saveCustomerOrderItem(item) {
  if (props.dialogType == DIALOG_TYPE.ADD){
    fetchOrderDetails();
    orderDetails.value.push(item);
    emits("addOrderDetail", orderDetails.value);
  }
  
  if (props.dialogType == DIALOG_TYPE.UPD)
    fetchOrderDetails();
}

async function deleteOrderDetail(customerOrderItem) {
  if(customerOrderItem.customerOrderItemStatusId == CUSTOMER_ORDER_ITEM_STATUS.TAMAMLANDI){
    mbox("Tamamlanan Sipariş Alt Kalemi Silinemez");
    return;
  }
  cbox(customerOrderItem.customerOrderItemId + " siliniyor...", async () => {
    await customerOrderDetailApi.deleteCustomerOrderDetail(customerOrderItem.customerOrderItemId);
  });
  await fetchOrderDetails();
}
function getReportCustomerOrderItem(item) {
    orderDetailModel.value = item;
  showReportDlg.value = true;
}
async function getExcelReportCustomerOrderItem(item) { 
   var data = await reportApi.getCustomerReport( item.customerOrderItemId);
   downloadFile(data.value, `Sipariş Raporu ${new Date().toLocaleDateString('tr-TR')}.xlsx`);
}
watch(selectedOrderDetails, () => {
  emits("onSelectedOrderDetails", selectedOrderDetails.value)
});
function uploadFile(event,slotprops){
  selectedFile.value = event.files[0];
  submitFile(slotprops);
}
async function submitFile(e){
  const formData = new FormData();
  formData.append("Files",selectedFile.value,selectedFile.value.name)
  formData.append("customerOrderItemId",e.customerOrderItemId);
  await customerOrderDetailApi.UploadFile(formData);
}
function rowClass(e){
  if(e.customerOrderItemStatusId>=CUSTOMER_ORDER_ITEM_STATUS.TAMAMLANDI){
    return 'tp-cusDetTable-bg';
  }
  if(e.customerOrderItemStatusId==CUSTOMER_ORDER_ITEM_STATUS.IPTAL_EDILMIS){
    return 'tp-dataCoi-bg';
  }
}
</script>

<template>

  <OrderDetailSideBar />
  <app-base-layout>
    <DataTable style="margin-left: auto !important;margin-right: auto !important;" class="dataTable" :value="orderDetails" v-model:filters="filters" v-model:selection="selectedOrderDetails" paginator
      :rows="20" :globalFilterFields="['customerOrderItemId','companyName', 'name','drawingNo','materialQualityId']" responsiveLayout="stack"
      paginatorPosition="top" rowHover stripedRows :rowClass="rowClass">
      <template #paginatorstart>
        <h3>Sipariş Detayları</h3>
      </template>

      <template #paginatorend>
        <span class="p-input-icon-left">
          <i class="pi pi-search" />
          <InputText v-model="filters.global.value" placeholder="Ara..." />
        </span>
        <Button :icon="PrimeIcons.REFRESH" class="p-button-rounded p-button-outlined mx-2"
          @click="fetchOrderDetails()" />

        <Button :icon="PrimeIcons.PLUS" class="p-button-rounded p-button-outlined" @click="orderDetailDlg('create')"
          v-if="/*props.isAddNewOrderDetailShow*/true" />
      </template>
      <Column field="customerOrderItemStatusName" header="Sipariş Alt Kalem Durumu" sortable> 
        <template #body="slotProps">
            {{ props.dialogType == DIALOG_TYPE.UPD ? slotProps.data?.customerOrderItemStatusName:customerOrderItemStatus?.filter(x=>x.customerOrderItemStatusId ==slotProps.data?.customerOrderItemStatusId)[0]?.name }}
          </template>
      </Column>
      <Column field="name" header="Sipariş Adı" sortable> </Column>
      <Column field="drawingNo" header="Çizim Numarası" sortable> </Column>
      <Column field="width" header="Genişlik" sortable> </Column>
      <Column field="height" header="Yükseklik" sortable> </Column>
      <Column field="depth" header="Derinlik" sortable> </Column>
      <Column field="pieceNumber" header="Parça Numarası" sortable> </Column>
      <Column field="pieceWeight" header="Parça Ağırlığı" sortable> </Column>
      <Column field="hrc" header="Önceki Sertlik(HRC)" sortable> </Column>
      <Column field="hb" header="Önceki Sertlik(HB)" sortable> </Column>
      <Column field="nextHb" header="Sonraki Sertlik(Hb)" sortable> </Column>
      <Column field="nextHrc" header="Sonraki Sertlik(Hrc)" sortable> </Column>
      <Column field="materialQualityId" header="Malzeme Kalitesi" sortable>
        <template #body="slotProps">
          {{ props.dialogType == DIALOG_TYPE.UPD ? slotProps.data?.materialQualityName:materialQuality?.filter(x=>x.materialQualityId ==slotProps.data?.materialQualityId )[0]?.name }}
        </template>
       </Column>
      
      <Column field="treatmentTypeId" header="İşlem Tipi" sortable>
        <template #body="slotProps">
            {{ props.dialogType == DIALOG_TYPE.UPD ? slotProps.data?.treatmentTypeName:treatmentType?.filter(x=>x.treatmentTypeId == slotProps.data?.treatmentTypeId)[0]?.name }}
          </template>
        
       </Column>
      <Column field="createDate" header="Sipariş Tarihi" sortable>
        <template #body="slotprops">
          {{ formatDatetime(slotprops.data?.createDate) }}
        </template>
      </Column>
      <Column field="registrationDate" header="Kayıt Zamanı" sortable> 
        <template #body="slotprops">
          {{ formatDatetime(slotprops.data?.registrationDate) }}
        </template>
      </Column>
      <Column field="requestDate" header="İstek Tarihi" sortable>
        <template #body="slotprops">
          {{ formatDatetime(slotprops.data?.requestDate) }}
        </template>
      </Column>
      <Column field="startDate" header="Başlangıç Zamanı" sortable> 
        <template #body="slotprops">
          {{ formatDatetime(slotprops.data?.startDate) }}
        </template>
      </Column>
      <Column field="finishDate" header="Bitiş Zamanı" sortable> 
        <template #body="slotprops">
          {{ formatDatetime(slotprops.data?.finishDate) }}
        </template>
      </Column>
      <Column field="shippingDate" header="Sevkiyat Tarihi" sortable>
        <template #body="slotprops">
          {{ formatDatetime(slotprops.data?.shippingDate) }}
        </template>
      </Column>

      <Column field="remark" header="Açıklama" sortable> </Column>

      <Column>
        <template #header>
        </template>
        <template #body="slotprops">
          <Button :icon="PrimeIcons.PENCIL" class="p-button-success p-button-rounded p-button-outlined mr-2"
            @click="orderDetailDlg('update',slotprops.data)" />

          <Button :icon="PrimeIcons.TRASH" class="p-button-danger p-button-rounded p-button-outlined mr-2"
            @click="deleteOrderDetail(slotprops.data)" />

          <Button :icon="PrimeIcons.CHART_BAR" class="p-button-info p-button-rounded p-button-outlined mr-2"
            @click="getReportCustomerOrderItem(slotprops.data)" />

          <Button :icon="PrimeIcons.FILE_EXCEL" class="p-button-info p-button-rounded p-button-outlined mr-2"
            @click="getExcelReportCustomerOrderItem(slotprops.data)" />
            <FileUpload v-if="slotprops.data?.filePath==null" chooseLabel="Dosya Yükle" mode="basic" @select="uploadFile($event,slotprops.data)" :icon="PrimeIcons.PLUS" class="p-button-info p-button-rounded p-button-outlined mr-2" />
        </template>
      </Column>

      <template #empty>
        <AppInfoEmpty />
      </template>
    </DataTable>
  </app-base-layout>
  <OrderDetailReport v-model="showReportDlg" :customerOrderItemId="orderDetailModel.customerOrderItemId"
    ></OrderDetailReport>
  <OrderDetailDialog v-model="showDialog" :orderDetail="orderDetailModel" :customerOrderId="props.customerOrderId"
    :dialogType="orderDetailDialogType" @completedOrderDetail="saveCustomerOrderItem" :customerId="props.customerId"></OrderDetailDialog>
</template>
