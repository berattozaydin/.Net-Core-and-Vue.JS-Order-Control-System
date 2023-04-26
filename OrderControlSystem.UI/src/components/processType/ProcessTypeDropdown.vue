<script>
import Dropdown from "primevue/dropdown";
import useProcessTypeStore from "../../stores/ProcessType";
export default {
  components: { Dropdown },

  props: ["modelValue"],

  emits: ["update:modelValue"],

  setup() {
    const processTypeStore = useProcessTypeStore();
    return { processTypeStore };
  },

  watch: {
    modelValue() { 
      this.$emit("update:modelValue", this.modelValue);
    },
  },

  mounted() {
    this.processTypeStore.fetchProcessTypes();
  },
};
</script>

<template>
  <Dropdown
    v-model="modelValue"
    :options="processTypeStore.processTypes"
    optionLabel="name"
    optionValue="processTypeId"
    placeholder="İşlem Türünü Seçiniz" 
    v-bind="$attrs"
  />
</template>