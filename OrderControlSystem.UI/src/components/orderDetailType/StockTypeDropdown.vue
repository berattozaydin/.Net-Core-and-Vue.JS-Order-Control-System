<script>
import Dropdown from "primevue/dropdown";
import useStockTypeStore from "../../stores/StockType";
export default {
  components: { Dropdown },

  props: ["modelValue"],

  emits: ["update:modelValue"],

  setup() {
    const stockTypeStore = useStockTypeStore();
    return { stockTypeStore };
  },

  watch: {
    modelValue() { 
      this.$emit("update:modelValue", this.modelValue);
    },
  },

  mounted() {
    this.stockTypeStore.fetchStockTypes();
  },
};
</script>

<template>
  <Dropdown
    v-model="modelValue"
    :options="this.stockTypeStore.stockTypes"
    optionLabel="name"
    optionValue="stockTypeId"
    placeholder="Stok Tipi Seçiniz" 
    v-bind="$attrs"
  />
</template>