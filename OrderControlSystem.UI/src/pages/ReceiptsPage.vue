<script setup>
import { useReceiptStore } from '../stores/receipt';
import { onMounted } from 'vue';
import ProcessStepsTable from '../components/ProcessSteps/ProcessStepsTable.vue';



const receiptsStore = useReceiptStore()
onMounted(async () => {
  receiptsStore.fetchReceipts()
})

</script>

  <template>
    <AppBaseLayout>
      <ProcessStepsTable />
    </AppBaseLayout>
  </template>