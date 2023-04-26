<script setup>
import DataTable from "primevue/datatable";
import InputText from "primevue/inputtext";
import Column from "primevue/column";
import Button from "primevue/button";
import { FilterMatchMode,FilterOperator,PrimeIcons } from "primevue/api";
import useAccountApi from "../../api/account.api";
import AppBaseLayout from "../app/AppBaseLayout.vue";
import AppInfoEmpty from "../app/AppInfoEmpty.vue";
import AccountDialog from "./AccountDialog.vue";
import { onMounted, ref } from "vue";
import { DIALOG_TYPE } from "../../stores/appConst";
import useAuthStore from "../../stores/auth";
const authStore = useAuthStore();
const filters = ref({
  global: { value: "", matchMode: FilterMatchMode.CONTAINS },
 
});
const selectedAccount = ref({});
const showAccountDialog = ref(false);
const accountApi = useAccountApi();
const accountModel = ref([]);
const dialogType = ref(null);
onMounted(()=>{
  fetchAccounts();
})
function accountDlg(cmd,item=null){
  showAccountDialog.value=true;
  selectedAccount.value = item;
  dialogType.value=cmd;
}
async function fetchAccounts(){
 accountModel.value= await accountApi.fetchAccount();
}
async function deleteAccount(item){
  await accountApi.deleteAccount(item.username);
  fetchAccounts();
}
  
</script>

 <template>
<AppBaseLayout>
    <DataTable class="dataTable" :value="accountModel" v-model:filters="filters" paginator :rows="20"
      :globalFilterFields="['customer', 'name','lastName','phoneNumber','email','isActive']" responsiveLayout="stack" paginatorPosition="top" rowHover stripedRows>
      <template #paginatorstart>
        <h3>Kullanıcı Hesapları</h3>
      </template>
      <template #paginatorend>
        <span class="p-input-icon-left">
          <i class="pi pi-search" />
          <InputText v-model="filters['global'].value" placeholder="Ara..." style="margin-right: 1rem;" />
        </span>
        <Button
        :icon="PrimeIcons.PLUS"
        class="p-button-success p-button-rounded mr-2"
        label="Kullanıcı Ekle"
        @click="accountDlg(DIALOG_TYPE.ADD)"
        :disabled="authStore.user.role ==3 || authStore.user.role ==2"
      />  
        <!-- <Button :icon="PrimeIcons.REFRESH" class="p-button-rounded p-button-outlined mx-2" @click="fetchAccounts()" /> -->
      </template>
 
      <Column field="customer.companyName" header="Şirket Adı" sortable> </Column>
      <Column field="name" header="Adı" sortable> </Column> 
      <Column field="lastName" header="Soyadı" sortable> </Column>
      <Column field="role" header="Rolü" sortable> </Column>
      <Column field="isActive" header="Durumu" sortable> </Column>
      <Column field="phoneNumber" header="Telefon Numarası" sortable/> 
      <Column field="email" header="E-Mail Adresi" sortable/> 
      
      <Column>
        <template #header>
          <!-- <Button :icon="PrimeIcons.PLUS" class="p-button-rounded p-button-outlined" @click="newAccount()" /> -->
        </template>
        <template #body="slotprops">
          <Button :icon="PrimeIcons.PENCIL" class="p-button-success p-button-rounded p-button-outlined mr-2"
            @click="accountDlg(DIALOG_TYPE.UPD,slotprops.data)" />
          <Button :icon="PrimeIcons.TRASH" class="p-button-danger p-button-rounded p-button-outlined mr-2"
            @click="deleteAccount(slotprops.data)" />
        </template>
      </Column>

      <template #empty>
        <AppInfoEmpty />
      </template>
    </DataTable>
  </AppBaseLayout>
  <AccountDialog v-model="showAccountDialog" :dialogType="dialogType" :account="selectedAccount" @onSuccess="fetchAccounts" ></AccountDialog> 
</template>

