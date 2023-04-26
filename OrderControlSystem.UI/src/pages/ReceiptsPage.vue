<script setup>
import { useReceiptStore } from '../stores/receipt';
import { onMounted } from 'vue';
import ReceiptsTable from '../components/receipts/ReceiptsTable.vue';



const receiptsStore = useReceiptStore()
onMounted(async () => {
  receiptsStore.fetchReceipts()
})

</script>

  <template>
    <AppBaseLayout>
      <ReceiptsTable />
    </AppBaseLayout>
  </template>