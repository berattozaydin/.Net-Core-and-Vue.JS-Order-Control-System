<script setup>
    import {ref, watch} from 'vue';
    import Sidebar from 'primevue/sidebar';
    import {PrimeIcons} from 'primevue/api';
    import Tag from 'primevue/tag';
    import DataTable from 'primevue/datatable';
    import Button from 'primevue/button';
    import Column from 'primevue/column';
    import useCustomerOrderApi from '../../api/custormerOrder.api';
    import {toastError,toastSuccess} from '../../plugins/toastService';
    import useCustomerOrderDetailApi from '../../api/customerOrderDetail.api';
    import CustomerOrderSideBarDlg from './CustomerOrderSideBarDlg.vue';
    const isTagTrue=ref(false);
    const customerOrderApi = useCustomerOrderApi();
    const customerOrderDetailApi = useCustomerOrderDetailApi();
    const customerOrderItemModel=ref([]);
    const propsCustomerOrder = ref([]);
    const isSideBarVisible = ref(false);
    const showOrderDialog = ref(false);
    const props = defineProps(["modelValue","customerOrder"]);
    const emits = defineEmits(["update:modelValue","onAddSelectedItemSend","refresh"]);
    const selectedCustomerOrder = ref({});
    const customerOrderModel = ref([]);
    const sendSelectedOrderDetails=ref([]);
    const onRowSelect = (event) => {
        isTagTrue.value=true;
            sendSelectedOrderDetails.value.push(event.data);
        };
    watch(()=>props.modelValue,()=>{isSideBarVisible.value=props.modelValue;});
    watch(isSideBarVisible,async ()=>{
        sendSelectedOrderDetails.value=[];
        customerOrderModel.value=[];
        customerOrderModel.value=await customerOrderApi.fetchL4CustomerOrder();
        propsCustomerOrder.value=props.customerOrder;
        emits("update:modelValue",isSideBarVisible.value); 
        });
    function deleteSelectedOrderDetails(item){
        let index = sendSelectedOrderDetails.value.findIndex(x=>x.customerOrderId == item.customerOrderId);
           sendSelectedOrderDetails.value.splice(index,1);
           if(selectedCustomerOrder.value==[])
                isTagTrue.value=false;
    }
    async function completeSelectionCustomerOrder(){
       selectedCustomerOrder.value=sendSelectedOrderDetails.value;
        var res= await customerOrderApi.l3tol4status(selectedCustomerOrder.value,20);
        if(res.success==0){
            toastError(res.id+" Numaralı Sipariş :"+res.value);
        }
        if(res.success==1){
            toastSuccess(res.id+ " Numaralı Sipariş Eklendi"); 
        }
        isSideBarVisible.value=false;
        emits("refresh",true);
        
    }
    async function getCustomerOrderItem(item){
        customerOrderItemModel.value = await customerOrderDetailApi.GetCustomerOrderItem(item);
        showOrderDialog.value=true;
    }
</script>

<template>
    <div>
        <Sidebar v-model:visible="isSideBarVisible" :baseZIndex="10000" style="width:45vw">
        <template #header>
            <Button label="Seçimi Tamamla" class="p-button-success p-button-rounded" :icon="PrimeIcons.SAVE" @click="completeSelectionCustomerOrder"></Button>
        </template>
            <h3>Üst API Sipariş Seçiniz</h3>
            <div class="grid p-fluid">
                <div v-for="item in sendSelectedOrderDetails" class="col-2 sm:col-2">
                    <Tag severity="success" v-if="isTagTrue" class="mr-2" >
                    {{item.customerOrderId}}
                    <Tag icon="pi pi-times" severity="danger" class="mr-2" v-on:click="deleteSelectedOrderDetails(item)"></Tag>
                    </Tag>               
                </div>
            </div>
            <DataTable :loading="customerOrderApi.customerOrderLoading.value" :value="customerOrderModel" v-model:selection="selectedCustomerOrder"
            dataKey="customerOrderId" responsiveLayout="scroll" selectionMode="single" @rowSelect="onRowSelect">
                <Column field="customerOrderId" header = "Id" sortable/>
                <Column field="orderNumber" header = "Sipariş Numarası" sortable/>
                <Column field="customerId" header = "Müşteri Adı" sortable/>
                <Column field="customerOrderStatusId" header = "Sipariş Durumu" sortable/>
                <Column field="name" header="Adı" sortable> </Column> 
                <Column field="remark" header="Açıklaması" sortable> </Column> 
                <Column field="inL3" header="Seviye 3">
                    <template #body="slotprops">
                            {{propsCustomerOrder.find(x=>x.customerOrderId==slotprops.data?.customerOrderId) ? 'var'.toLocaleUpperCase():'yok'}}
                    </template>
                </Column>
                <Column header="Alt Kalem Bilgisi"> 
                <template #body="slotprops">
                    <Button :icon="PrimeIcons.CHART_BAR" class="p-button-info p-button-rounded p-button-outlined mr-2" @click="getCustomerOrderItem(slotprops.data)"/>
                </template>
                </Column>
            </DataTable>
        </Sidebar>
    </div>
    <CustomerOrderSideBarDlg v-model:visible="showOrderDialog" :customerOrderItem="customerOrderItemModel"></CustomerOrderSideBarDlg>
</template>