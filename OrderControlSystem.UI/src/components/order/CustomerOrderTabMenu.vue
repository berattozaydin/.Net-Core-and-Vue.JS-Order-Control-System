<template>
    <TabMenu v-if="tabMenuModel.length" :model="tabMenuModel" v-model:activeIndex="active">
        <template #item="{ item }" >
            <a  @click="active = item.customerOrderStatusId" class="p-menuitem-link" :class=" 'p-menuitem-link '+ (active == item.customerOrderStatusId?'tp-highlight':' ' )">
                <div class="p-menuitem-text mr-2">{{ item.label }} </div>
                <Badge v-if="props.counts[item.customerOrderStatusId.toString()] != 0"  v-show="props.counts[item.customerOrderStatusId.toString()]" :severity="item.severity"
                    :value="props.counts[item.customerOrderStatusId.toString()]"></Badge>
            </a>
        </template>
    </TabMenu>
</template>
<script setup>
import TabMenu from 'primevue/tabmenu';
import Badge from 'primevue/badge';
import { onMounted, ref,watch } from 'vue';
const props=defineProps(["counts"]);
const emits = defineEmits(["update:modelValue"]);
const active = ref();
const tabMenuModel = ref([
]);
watch(active,()=>{
    emits("update:modelValue",active.value);
});
onMounted(()=>{
   
        tabMenuModel.value.push({ label: "Taslak", customerOrderStatusId: 10,severity:"warning" });
  
        tabMenuModel.value.push({ label: "Sipariş Alındı", customerOrderStatusId: 11,severity:"warning" });
 
        tabMenuModel.value.push({ label: "Onaylanmış", customerOrderStatusId: 20,severity:"success" });
        tabMenuModel.value.push({ label: "Paketleniyor", customerOrderStatusId: 21,severity:"success" });
    
        tabMenuModel.value.push({ label: "İptal Edilmiş", customerOrderStatusId: 30,severity:"danger" });
   
        tabMenuModel.value.push({ label: "Tamamlandı", customerOrderStatusId: 40, severity:"success" });
        tabMenuModel.value.push({ label: "Sevkediliyor", customerOrderStatusId: 50, severity:"info" });
        tabMenuModel.value.push({ label: "Kapandı", customerOrderStatusId: 60,severity:"info"});
    
})
</script>