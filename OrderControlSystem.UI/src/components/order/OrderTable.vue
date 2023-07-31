
<script setup>
import DataTable from "primevue/datatable";
import InputText from "primevue/inputtext";
import Column from "primevue/column";
import Button from "primevue/button";
import ConfirmDialog from "primevue/confirmdialog";
import { PrimeIcons } from "primevue/api";
import Toolbar from "primevue/toolbar";
import useAuthStore from "../../stores/auth";
import { DIALOG_TYPE,CUSTOMER_ORDER_STATUS } from "../../stores/appConst";
import {ref,onMounted, watch} from "vue";
import { HubConnectionBuilder,LogLevel } from "@microsoft/signalr";
import AppInfoEmpty from "../app/AppInfoEmpty.vue";
import OrderDialog from "./OrderDialog.vue";
import OrderDetailSideBar from "../orderDetail/OrderDetailSideBar.vue";
import CustomerOrderTabMenu from '../order/CustomerOrderTabMenu.vue';
import useCustomerOrderapi from '../../api/custormerOrder.api';
import { cbox,mbox } from "../../plugins/dialogService";
import AppBaseLayout from "../app/AppBaseLayout.vue";
import { formatDatetime } from "../../helper";
const customerOrderApi = useCustomerOrderapi();
const authStore = useAuthStore();
const isOrderSideBarVisible = ref(false);
const customerOrderModel = ref([]);
const showOrderDialog=ref(false);
const orderDialogType=ref(DIALOG_TYPE.ADD);
const orderModel=ref([]);
const statusCounts = ref([]);
const activeIndexCustomerOrder = ref(10);
const totalRecords = ref(null);
const connection = ref(new HubConnectionBuilder()
  .withUrl("/websocket")
  .configureLogging(LogLevel.Information)
  .build());
const filters = ref({
  global: { value: "", matchMode:"contains" },
  customerOrderId:{value:"",matchMode:"contains"},
  customerName:{value:"",matchMode:"contains"},
  name:{value:"",matchMode:"contains"},
  orderNumber:{value:"",matchMode:"contains"},
  barcodeNumber:{value:"",matchMode:"contains"},
})

const lazyParams=ref({
                    Page: 0,
                    First: 0,
                    Rows: 20,
                    SortField: "customerOrderId",
                    SortOrder: -1,
                    ActiveIndexCustomerOrder:activeIndexCustomerOrder.value,
                    filters: filters.value,
                    
                });


onMounted(() => {
  fetchOrders();
  connectHub();
})
async function connectHub(){
  try{
    await connection.value.start();
  }catch(err){
    console.log(err);
  }
}
  async function fetchOrders(item) {
    let returnResult = [];
    returnResult = await customerOrderApi.getAll(lazyParams.value);
   customerOrderModel.value = returnResult.value;
   totalRecords.value = returnResult.totalRecords; 
   getStatusCount();
    }

    function customerOrderDlg(cmd,slotprops=null) {
      if(cmd ==='create'){
        orderDialogType.value= DIALOG_TYPE.ADD;
      }
      if(cmd ==='update'){
        orderModel.value = slotprops;
        orderDialogType.value = DIALOG_TYPE.UPD;
      }
      if(cmd==='sideBarOpen'){
        isOrderSideBarVisible.value=true;
        return;
      }
      showOrderDialog.value = true;
    }
    async function deleteCustomerOrder(customerOrder){
      if(customerOrder.customerOrderStatusId == CUSTOMER_ORDER_STATUS.TAMAMLANDI){
        mbox("Sipariş Tamamlandığı İçin Silinemez");
        return;
      }
      cbox(customerOrder.name +" silinecek",async()=>{
       await customerOrderApi.deleteCustomerOrder(customerOrder.customerOrderId);
       fetchOrders();
      });
     
    }
watch(activeIndexCustomerOrder, async()=>{
    lazyParams.value.ActiveIndexCustomerOrder=activeIndexCustomerOrder.value;
  fetchOrders();
},{
  immediate:true
});
async function getStatusCount(){
  statusCounts.value = await customerOrderApi.getCustomerOrderStatusCount();
}
function onPage(event){
  lazyParams.value = event;
   fetchOrders();
}

function onSort(event){
  lazyParams.value.SortField=event.sortField;
  lazyParams.value.SortOrder=event.sortOrder;
  fetchOrders();

}

function onFilter(){
  lazyParams.value.filters = filters.value;
  fetchOrders();
  
}
watch(filters,()=>{
  onFilter();
})
</script>

<template>
 
  <ConfirmDialog></ConfirmDialog>
  <CustomerOrderTabMenu class="dataTable" v-model="activeIndexCustomerOrder" :counts="statusCounts"></CustomerOrderTabMenu>  
  <AppBaseLayout>
  <Toolbar>
  <template #start>
    </template>
    </Toolbar>
     
 <DataTable :loading="customerOrderApi.customerOrderLoading.value" 
            class="dataTable"
            
            :value="customerOrderModel" 
            v-model:filters="filters" 
            :lazy="true"
            @page="onPage($event)"
            @sort="onSort($event)"
            filterDisplay="row"
            :sortOrder="1"
            :paginator="true"
            sortField="customerOrderId"
            :rows="20"
            paginatorPosition="top" 
            stripedRows 
            dataKey="customerOrderId"
            :totalRecords="totalRecords"
            >
    <template #paginatorstart>
      <h3>Siparişler</h3>
    </template>
    <template #paginatorend>
      <div class="tooltip">
  <Button :disabled="authStore.user.role==3" :icon="PrimeIcons.PLUS" label="Üst API Sipariş Ekle" class="p-button-warning p-button-rounded mr-3" @click="customerOrderDlg('sideBarOpen')"></Button>
  
 <Button
        :disabled="authStore.user.role==3"
        :icon="PrimeIcons.PLUS"
        class="p-button-success p-button-rounded mr-2"
        label="Sipariş Ekle"
        @click="customerOrderDlg('create')"
        
      />
      <span class="tooltiptext" v-if="authStore.user.role==3">{{'Erişim Yetkiniz Yok Süpervisor'+' '+authStore.user.name}}</span>
    </div>
      
        
      <Button
      :icon="PrimeIcons.REFRESH" class="p-button-rounded p-button-outlined mx-2"
        @click="fetchOrders()"
      /> 
    </template>
    <Column field="customerOrderId" header = "Id" sortable>
      <template #filter="{ filterModel, filterCallback }">
                    <InputText type="text" v-model="filterModel.value" @keydown.enter="filterCallback()"
                               class="p-column-filter" placeholder="Ara..." />
                </template>
    </Column>
    <Column field="orderNumber" header = "Sipariş Numarası" sortable>
      <template #filter="{ filterModel, filterCallback }">
                    <InputText type="text" v-model="filterModel.value" @keydown.enter="filterCallback()"
                               class="p-column-filter" placeholder="Ara..." />
                </template>
    </Column>
    <Column field="barcodeNumber" header = "Barkod Numarası" sortable>
      <template #filter="{ filterModel, filterCallback }">
                    <InputText type="text" v-model="filterModel.value" @keydown.enter="filterCallback()"
                               class="p-column-filter" placeholder="Ara..." />
                </template>
    </Column>
    <Column field="customerName" header = "Müşteri Adı" sortable>
      <template #filter="{ filterModel, filterCallback }">
                    <InputText type="text" v-model="filterModel.value" @keydown.enter="filterCallback()"
                               class="p-column-filter" placeholder="Ara..." />
                </template>
    </Column>
    <Column field="customerOrderStatusName" header = "Sipariş Durumu" sortable/>
    <Column field="name" header="Adı" sortable>
      <template #filter="{ filterModel, filterCallback }">
                    <InputText type="text" v-model="filterModel.value" @keydown.enter="filterCallback()"
                               class="p-column-filter" placeholder="Ara..." />
                </template>
     </Column> 
    <Column field="remark" header="Açıklaması" sortable> </Column> 
    <Column field="createdDate" header="Sipariş Tarihi" sortable>
    <template #body="slotProps">
      {{ formatDatetime(slotProps.data?.createdDate) }}
    </template>
     </Column> 
    <Column>
      <template #body="slotprops">
        <div class="flex">
        <div class="tooltip">
          <Button
            :disabled="authStore.user.role==3"
            :icon="PrimeIcons.PENCIL"
            class="p-button-primary p-button-rounded p-button-outlined mr-2"
            @click="customerOrderDlg('update',slotprops.data)"
          />
          <Button :disabled="authStore.user.role==3" :icon="PrimeIcons.TRASH" class="p-button-rounded p-button-danger p-button-outlined mr-2" @click="deleteCustomerOrder(slotprops.data)"/>
          <span class="tooltiptext" v-if="authStore.user.role==3">{{('Erişim Yetkiniz Yok SuperVisor'+ ' ' + authStore.user.name)}}</span>
        </div>
        </div>
      </template>
    </Column>

    <template #empty>
      <AppInfoEmpty></AppInfoEmpty>
    </template>
  </DataTable>
</AppBaseLayout>
   <OrderDialog
    v-model="showOrderDialog"
    :customerOrder="orderModel.customerOrderId"
    :dialogType="orderDialogType" @refresh="fetchOrders"
  ></OrderDialog>
  <OrderDetailSideBar v-model="isOrderSideBarVisible" :customerOrder="customerOrderModel" @refresh="fetchOrders"></OrderDetailSideBar>
</template>

<style scoped>
  .tooltip {
  position: relative;
  display: inline-block;
}

.tooltip .tooltiptext {
  visibility: hidden;
  width: 120px;
  background-color: rgb(243, 19, 19);
  color: #fff;
  text-align: center;
  border-radius: 6px;
  padding: 2px 0;

  /* Position the tooltip */
  position: top;
  z-index: 1;
}

.tooltip:hover .tooltiptext {
  visibility: visible;
}
</style>

