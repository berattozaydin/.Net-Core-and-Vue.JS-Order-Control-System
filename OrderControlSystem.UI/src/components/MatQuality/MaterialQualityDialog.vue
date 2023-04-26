<template>

<Dialog v-model:visible="matQDialogShow"
    header="Kalite"
    :modal="false"
    position="middle"
    :breakpoints="{ '960px': '75vw', '640px': '90vw' }"
    :style="{ width: '20vw' }"
>
<MaterialQualityForm ref="materialQualityFormComponent" :dialogType="props.dialogType" :matQId="props.matQId" @closeDialog="closeDialog"></MaterialQualityForm>
<template #footer>
      <Button
        label="Vazgeç"
        icon="pi pi-times"
        @click="closeDialog"
        class="p-button-text"
      />
      <Button label="Kaydet" icon="pi pi-save" @click="saveMaterialQuality" />
    </template>
</Dialog>
</template>
<script setup>
    import Dialog from 'primevue/dialog';
    import Button from 'primevue/button';
    import MaterialQualityForm from './MaterialQualityForm.vue';
    import { ref, watch } from 'vue';
    const props = defineProps(["modelValue","matQDialogShow","dialogType","matQId"]);
    const emits = defineEmits(["update:modelValue","refresh"]);
    const materialQualityFormComponent = ref();
    const matQDialogShow = ref(false);

   watch(matQDialogShow,()=>{
    emits("update:modelValue",matQDialogShow.value);
   })
   watch(() => props.modelValue,() => {
    matQDialogShow.value = props.modelValue;
    emits("update:modelValue", matQDialogShow.value);
  }
);
  function saveMaterialQuality(){
    materialQualityFormComponent.value.saveMatQ();
    emits("refresh",true);
  }
  function closeDialog(item){
    matQDialogShow.value=false;
    emits("refresh",true);
  }
</script>