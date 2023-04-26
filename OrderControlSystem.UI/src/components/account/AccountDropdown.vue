<script>
import Dropdown from "primevue/dropdown";
import useAccountStore from "../../stores/Account";
export default {
  components: { Dropdown },

  props: ["modelValue"],

  emits: ["update:modelValue", "onValueChange"],

  setup() {
    const accountStore = useAccountStore();
    return { accountStore };
  },

  watch: {
    modelValue() {
      this.$emit("update:modelValue", this.modelValue);
      this.$emit("onValueChange", this.modelValue);
    },
  },

  mounted() {
    this.accountStore.fetchAccounts();
  },
};
</script>

<template>
  <Dropdown
    v-model="modelValue"
    :options="accountStore.accounts"
    optionLabel="name"
    optionValue="accountId"
    placeholder="Müşteri Seçiniz"
    filter
    v-bind="$attrs" 
  />
</template>