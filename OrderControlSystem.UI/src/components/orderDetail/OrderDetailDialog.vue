<script setup>
import Dialog from "primevue/dialog";
import Button from "primevue/button";
import InputText from "primevue/inputtext";
import Fieldset from 'primevue/fieldset';
import Checkbox from 'primevue/checkbox';
import Textarea from "primevue/textarea";
import AppCalendar from '../app/AppCalendar.vue';

import { DIALOG_TYPE } from "../../stores/appConst";

import {watch,ref,computed} from 'vue';
import useCustomerOrderDetailApi from "../../api/customerOrderDetail.api";
import CustomerDropdown from "../customer/CustomerDropdown.vue";
import MatQualityDropdown from "../MatQuality/MatQualityDropdown.vue";
import TreatmentTypeDropdown from "../TreatmentType/TreatmentTypeDropdown.vue";
import { mbox } from "../../plugins/dialogService";
const props = defineProps(["modelValue", "orderDetail", "dialogType","showDialog","customerOrderId","customerId"]);
const emits = defineEmits(["update:modelValue", "onSuccess", "onError","completedOrderDetail"]);
const orderDetailApi=useCustomerOrderDetailApi();
const showDialog=ref(false);
const submited = ref(false);
const checked = ref(false);
const orderDetailModel=ref({});
 const modalName = computed(()=>props.dialogType == DIALOG_TYPE.ADD ? "Yeni Sipariş Detayı Ekle" : "Sipariş Detayı Düzenle");

  async function saveOrderDetail() {
    let result = await checkRequiredCustomerOrderItems();
    if(result == true){
      submited.value=true;
      return;
    }else{
      let copy;
      if(orderDetailModel.value.customerOrderItemStatusId !=null){
        copy = orderDetailModel.value.customerOrderItemStatusId;
      }
      if (props.dialogType == DIALOG_TYPE.ADD) {
        orderDetailModel.value.createDate = Date.now();
          if(props.customerOrderId!=null){
            orderDetailModel.value.customerOrderId=props.customerOrderId;
            if(orderDetailModel.value.customerOrderItemStatusId>=30){
              orderDetailModel.value.customerOrderItemStatusId=copy;
            }else{
              if(checked.value==true){
                orderDetailModel.value.customerOrderItemStatusId=20
              }else{
                orderDetailModel.value.customerOrderItemStatusId=10
              }
            }
            await orderDetailApi.addCustomerOrderDetail(orderDetailModel.value);
          }else{
            if(orderDetailModel.value.customerOrderItemStatusId>=30){
              orderDetailModel.value.customerOrderItemStatusId=copy;
            }else{
              if(checked.value==true){
                orderDetailModel.value.customerOrderItemStatusId=20
              }else{
                orderDetailModel.value.customerOrderItemStatusId=10
              }
            }
            emits("completedOrderDetail",orderDetailModel.value)
          }
          
          showDialog.value=false;
      } 
      if (props.dialogType == DIALOG_TYPE.UPD) {
        if(props.customerOrderId!=null)
          orderDetailModel.value.customerOrderId=props.customerOrderId;
          if(orderDetailModel.value.customerOrderItemStatusId>=30){
              orderDetailModel.value.customerOrderItemStatusId=copy;
            }else{
              if(checked.value==true){
                orderDetailModel.value.customerOrderItemStatusId=20
              }else{
                orderDetailModel.value.customerOrderItemStatusId=10
              }
            }
          await orderDetailApi.updateCustomerOrderItem(orderDetailModel.value);
          emits("completedOrderDetail");
        showDialog.value=false;
      }else{
        onError();
      }
      onSuccess();
    }
    }

   function onSuccess() {
     emits("onSuccess",orderDetailModel.value);
    }

    function onError() {
      emits("onError",orderDetailModel.value);
    }
    watch(showDialog, () => {
      if(props.dialogType==DIALOG_TYPE.UPD){
        orderDetailModel.value={...props.orderDetail}
        if(orderDetailModel.value.customerOrderItemStatusId == 20){
          checked.value=true;
        }
      }
      if(props.dialogType==DIALOG_TYPE.ADD){
        orderDetailModel.value={};
        orderDetailModel.value.customerId=props.customerId
      }
         
    emits("update:modelValue", showDialog.value);
    });
    watch(
     ()=> props.modelValue,
        () => {
          showDialog.value = props.modelValue;
          emits("update:modelValue", showDialog.value);
             }
        );

       async function checkRequiredCustomerOrderItems(){
        let result = false;
          if(!orderDetailModel.value.name||
            !orderDetailModel.value.drawingNo||
            !orderDetailModel.value.customerId||
            !orderDetailModel.value.treatmentTypeId||
            !orderDetailModel.value.pieceNumber||
            !orderDetailModel.value.pieceWeight||
            !orderDetailModel.value.width||
            !orderDetailModel.value.height||
            !orderDetailModel.value.depth||
            !orderDetailModel.value.hrc||
            !orderDetailModel.value.hb||
            !orderDetailModel.value.createDate||
            !orderDetailModel.value.registrationDate||
            !orderDetailModel.value.requestDate||
            !orderDetailModel.value.startDate||
            !orderDetailModel.value.finishDate||
            !orderDetailModel.value.remark

            ){
              result= true;
          }else{
            result= false;
          }
          if(result = false){
            if(orderDetailModel.value.name.length>50){
              mbox("Sipariş Alt Kalem Adı 50 Karakterden Büyük Olamaz");
              result =true;
            }
            if(typeof orderDetailModel.value.drawingNo == 'string'){
              mbox("Çizim Numarası Nümerik Karakter Olmalıdır");
              result =true;
            }
          }
          return result;
        }
</script>

<template>
  <Dialog v-model:visible="showDialog" modal position="top" class="col-12 md:col-8 p-0">
    <template #header>
      <h3>{{ modalName }}</h3>
    </template>
    <div class="grid p-fluid">
      <div class="p-col-12 p-md-8 p-sm-8" style="padding: unset;">
    <Fieldset legend="Sipariş Bilgileri">
    <div class="grid">
      <div class="p-col-12 p-lg-6 p-md-6 p-sm-12">
      <div class="p-field">
        <label for="name">Sipariş Adı*</label>
        <InputText id="name" v-model="orderDetailModel.name"/>
        <small class="p-error" v-if="(submited&&!orderDetailModel.name)">Lütfen Değer Giriniz</small> 
      </div>
      <!--<div class="p-field">
        <label for="drawingNo">Çizim Numarası*</label>
        <InputText id="drawingNo" v-model="orderDetailModel.drawingNo"/>
        <small class="p-error" v-if="(submited&&!orderDetailModel.drawingNo)">Lütfen Değer Giriniz</small> 
      </div>-->
      <div class="p-field" style="display:none;">
        <label for="CustomerId">Müşteri Adı*</label>
        <CustomerDropdown id="CustomerId" v-model="orderDetailModel.customerId" disabled/>
        <small class="p-error" v-if="submited&&!orderDetailModel.customerId">Lütfen Değer Giriniz</small> 
      </div> 
      <div class="p-field" v-if="props.dialogType==DIALOG_TYPE.ADD">
        <label for="customerOrderItemStatus" style="padding:0.5">Sipariş Alt kalem Durumu : {{checked?'Onaylandı':'Taslak'}}</label>
        <Checkbox v-model="checked" :binary="true"></Checkbox>
      </div>
    </div> 
    </div>
    </Fieldset>
  </div>
    <div class="p-col-12 p-md-8 p-sm-6" style="padding: unset; margin-left: 3rem;">
      <Fieldset legend="Parça İşlemleri">
      <div class="grid">
        <div class="p-col-12 p-lg-3 p-md-6 p-sm-12">
      <!--<div class="p-field">
        <label for="MaterialQualityName">Malzeme Stok Numarası</label>
        <MatQualityDropdown id="MaterialQualityName" v-model="orderDetailModel.materialQualityId"/>
        <small class="p-error" v-if="submited&&!orderDetailModel.materialQualityId">Lütfen Değer Giriniz</small> 
      </div> -->
      <div class="p-field">
        <label for="TreatmentTypeId">İşlem Tipi*</label>
        <TreatmentTypeDropdown id="TreatmentTypeId" v-model="orderDetailModel.treatmentTypeId"/>
        <small class="p-error" v-if="submited&&!orderDetailModel.treatmentTypeId">Lütfen Değer Giriniz</small> 
      </div> 
    </div>
    </div>
    </Fieldset>
    </div>
    <div class="p-col-12 p-md-8 p-sm-6" style="padding: unset; margin-left: 3rem;">
      <Fieldset legend="Parça Özellikleri">
      <div class="grid">
        <div class="p-col-12 p-lg-3 p-md-6 p-sm-12">
      <div class="p-field">
        <label for="PieceNumber">Ürün Numarası*</label>
        <InputText id="PieceNumber" v-model="orderDetailModel.pieceNumber"/>
        <small class="p-error" v-if="submited&&!orderDetailModel.pieceNumber">Lütfen Değer Giriniz</small> 
      </div>
      <div class="p-field">
        <label for="PieceWeight">Ürün Ağırlığı*</label>
        <InputText id="PieceWeight" v-model="orderDetailModel.pieceWeight"/>
        <small class="p-error" v-if="submited&&!orderDetailModel.pieceWeight">Lütfen Değer Giriniz</small> 
      </div> 
      <div class="p-field">
        <label for="PieceWeight">Genişlik*</label>
        <InputText id="PieceWeight" v-model="orderDetailModel.width"/>
        <small class="p-error" v-if="submited&&!orderDetailModel.width">Lütfen Değer Giriniz</small> 
      </div> 
      <div class="p-field">
        <label for="PieceWeight">Yükseklik*</label>
        <InputText id="PieceWeight" v-model="orderDetailModel.height"/>
        <small class="p-error" v-if="submited&&!orderDetailModel.height">Lütfen Değer Giriniz</small> 
      </div> 
     <!-- <div class="p-field">
        <label for="PieceWeight">Depth</label>
        <InputText id="PieceWeight" v-model="orderDetailModel.depth"/>
        <small class="p-error" v-if="submited&&!orderDetailModel.depth">Lütfen Değer Giriniz</small> 
      </div> 
      <div class="p-field">
        <label for="Hrc">Önceki Sertlik(Hrc)*</label>
        <InputText id="Hrc" v-model="orderDetailModel.hrc"/>
        <small class="p-error" v-if="submited&&!orderDetailModel.hrc">Lütfen Değer Giriniz</small> 
      </div>   
      <div class="p-field">
        <label for="Hb">Önceki Sertlik(Hb)*</label>
        <InputText id="Hb" v-model="orderDetailModel.hb"/>
        <small class="p-error" v-if="submited&&!orderDetailModel.hb">Lütfen Değer Giriniz</small> 
      </div> -->
    </div>
    </div>
    </Fieldset>
  </div>
    <div class="p-col-12 p-md-4 p-sm-6" style="padding: unset; margin-left: 3rem;">
    <Fieldset legend="Tarihler">
    <div class="grid">
      <div class="p-col-12 p-md-6 p-sm-12">

      <div class="p-field">
        <label for="RegistrationDate">Kayıt Zamanı*</label>
        <AppCalendar v-model="orderDetailModel.registrationDate"/>
        <small class="p-error" v-if="submited&&!orderDetailModel.registrationDate">Lütfen Değer Giriniz</small> 
      </div>
      
      <div class="p-field">
        <label for="RequestDate">İstek Tarihi*</label>
        <AppCalendar v-model="orderDetailModel.requestDate"/>
        <small class="p-error" v-if="submited&&!orderDetailModel.requestDate">Lütfen Değer Giriniz</small> 
      </div>
      
      <div class="p-field ">
        <label for="StartDate">Başlangıç Zamanı*</label>
        <AppCalendar v-model="orderDetailModel.startDate"/>
        <small class="p-error" v-if="submited&&!orderDetailModel.startDate">Lütfen Değer Giriniz</small> 
      </div>
      
      <div class="p-field">
        <label for="FinishDate">Bitiş Zamanı*</label>
        <AppCalendar v-model="orderDetailModel.finishDate"/>
        <small class="p-error" v-if="submited&&!orderDetailModel.finishDate">Lütfen Değer Giriniz</small> 
      </div>
      
      <div class="p-field">
        <label for="ShipingDate">Sevkiyat Tarihi*</label>
        <AppCalendar id="ShipingDate" v-model="orderDetailModel.shippingDate"/>
        <small class="p-error" v-if="submited&&!orderDetailModel.shippingDate">Lütfen Değer Giriniz</small> 
      </div>
    </div>
    </div>
    </Fieldset>
  </div>
    <Fieldset legend="Sipariş Alt Kalemi Açıklaması">
    <div class="p-grid">
      <div class="p-field">
        <label for="Remark">Açıklama*</label>
        <Textarea :rows="5" :cols="50" id="Remark" v-model="orderDetailModel.remark"/>
        <small class="p-error" v-if="submited&&!orderDetailModel.remark">Lütfen Değer Giriniz</small> 
      </div>
    </div>
    </Fieldset>
    </div>

    <template #footer>
      <Button label="Kapat" icon="pi pi-times" @click="modelValue = false" />
      <Button label="Kaydet" icon="pi pi-check" @click="saveOrderDetail()" />
    </template>
  </Dialog>
</template>
<style scoped>
  label{
    font-size: 1.1rem;
    font-weight: bold;
  }
</style>