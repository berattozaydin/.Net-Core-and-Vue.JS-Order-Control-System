<template>
  <Textarea v-model="textAreaValue" :autoResize="autoResize" :rows="rows" :cols="cols" :maxlength="maxlength"
    v-bind="$attrs" />
  <label class="textarea-counter" :class="{ 'textarea-counter-exceed': modelValueExceed }">{{ modelValueLength }}/{{
      maxlength
  }}</label>
</template>

<script>
import Textarea from "primevue/textarea";
export default {
  components: { Textarea },

  data() {
    return {
      textAreaValue: null
    }
  },

  props: {
    modelValue: String,
    maxlength: {
      type: Number,
      default: 2000,
    },
    cols: {
      type: Number,
      default: 30,
    },
    cols: {
      type: Number,
      default: 30,
    },
    rows: {
      type: Number,
      default: 5,
    },
    autoResize: {
      type: Boolean,
      default: true,
    },
  },

  computed: {
    modelValueLength() {
      return this.modelValue?.length || 0;
    },
    modelValueExceed() {
      return this.modelValue?.length >= this.maxlength;
    },
  },

  watch: {
    textAreaValue() {
      this.$emit("update:modelValue", this.textAreaValue);
    },
    modelValue() {
      this.textAreaValue = this.modelValue;
    },
  },
};
</script> 

<style scoped>
.textarea-counter {
  float: right;
}

.textarea-counter-exceed {
  color: red;
}
</style>