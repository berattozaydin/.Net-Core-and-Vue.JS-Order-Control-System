<template>
    <Dropdown v-model="selectedMatQuality" :options="matQualities" optionLabel="name" optionValue="materialQualityId" placeholder="Malzeme Kalitesi Seçiniz" />
</template>

<script setup>
    import Dropdown from 'primevue/dropdown';
    import {onMounted, ref,watch} from 'vue';
    import useMaterialQualityApi from '../../api/materialQuality.api';
    const emits = defineEmits(["update:modelValue"]);
    const materialQualityApi = useMaterialQualityApi();
    const matQualities = ref([]);
    const selectedMatQuality = ref();
    onMounted(async()=>{
        matQualities.value=await materialQualityApi.getMaterialQualities();
    })
    watch(selectedMatQuality,()=>{
        emits("update:modelValue",selectedMatQuality.value);
    })

</script>