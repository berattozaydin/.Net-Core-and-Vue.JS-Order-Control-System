<script setup>
import DataTable from "primevue/datatable";
import InputText from "primevue/inputtext";
import Column from "primevue/column";
import Button from "primevue/button";
import { PrimeIcons, FilterMatchMode } from "primevue/api";
import ProgressSpinner from 'primevue/progressspinner';
import { ref, watch, onMounted } from 'vue'
import {toastSuccess,toastError} from '../../plugins/toastService';
import AppBaseLayout from "../app/AppBaseLayout.vue";
import AppInfoEmpty from "../app/AppInfoEmpty.vue";
import useCustomerApi from "../../api/customer.api";

const customerApi = useCustomerApi();
const globalSearch = ref(null)
const filters = ref({
  global: { value: "", matchMode: FilterMatchMode.CONTAINS },
});
const fetchCustomers = async () => {
  await customerApi.fetchCustomer();
}

async function synchronizeCustomer(){
  var res = await customerApi.synchronizeCustomer();
  if(res.success == 1){
    toastSuccess("Müşteri Senkronizasyonu Başarılı");
  }else{
    toastError(res.msg);
  }
  await fetchCustomers();
}
watch(globalSearch, () => {
  fetchCustomers()
})
onMounted( async () => {
  await fetchCustomers()
})

</script>

 <template>
  <Button :loadingIcon="PrimeIcons.SPINNER" class="p-button-rounded p-button-outlined mx-2" :icon="PrimeIcons.CLOUD" @click="synchronizeCustomer()"></Button>
  <ProgressSpinner v-if="customerApi.customerLoading.value" animationDuration=".5s" style="width:30px;height:30px"></ProgressSpinner>
  <app-base-layout>
    <DataTable :loading="customerApi.customerLoading.value" class="dataTable" :value="customerApi.customers.value" v-model:filters="filters" paginator :rows="15"
      :globalFilterFields="['taxNumber', 'companyName','companyFullName','companyCode','taxNumber']" responsiveLayout="stack" paginatorPosition="top" rowHover
      stripedRows>
      <template #paginatorstart>
        <h3>Müşteriler</h3>
      </template>
      <template #paginatorend>
        <span class="p-input-icon-left">
          <i class="pi pi-search" />
          <InputText v-model="filters.global.value" placeholder="Ara..." />
        </span>

        <Button :icon="PrimeIcons.REFRESH" class="p-button-rounded p-button-outlined mx-2" @click="fetchCustomers()" />
      </template>
      <Column field="companyName" header="Şirket Adı" sortable></Column>
      <Column field="companyFullName" header="Şirketin Tam Adı" sortable></Column>
      <Column field="taxAdministration" header="Şirket Yeri" sortable></Column>
      <Column field="taxNumber" header="Şirket Vergi Numarası" sortable></Column>
      <Column field="companyCode" header="Şirket kodu" sortable></Column>

      <Column>
        <template #header>
        </template>
        <template #body="slotprops">
          <!-- <Button :icon="PrimeIcons.PENCIL" class="p-button-success p-button-rounded p-button-outlined mr-2"
            @click="editCustomer(slotprops.data)" />
          <Button :icon="PrimeIcons.TRASH" class="p-button-danger p-button-rounded p-button-outlined mr-2"
            @click="deleteCustomer(slotprops.data)" /> -->
        </template>
      </Column>

      <template #empty>
        <AppInfoEmpty />
      </template>
    </DataTable>
  </app-base-layout>
</template>

