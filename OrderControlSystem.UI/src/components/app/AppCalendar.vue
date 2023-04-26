<template>
  <Calendar
  ref="appCalendar"
    v-model="date"
    @hide="onHide()"
    :dateFormat="props.showTime ? props.dateFormatDatetime : props.dateFormatDate"
    :placeholder="props.showTime ? props.placeholderDatetime : props.placeholderDate"
    :manualInput="props.manualInput"
    :showTime="props.showTime"
    :showIcon="true"
    showButtonBar
    autocomplete="off"
    hideOnDateTimeSelect
  />
</template>

<script setup>
import { onMounted, ref, watch } from "vue";
import Calendar from "primevue/calendar"
const emits = defineEmits(["update:modelValue", "hide"]);
const props = defineProps({
  
    modelValue: [Object, String],
    dateFormatDate: {
      type: String,
      default: "dd.mm.yy",
    },
    dateFormatDatetime: {
      type: String,
      default: "dd.mm.yy",
    },
    placeholderDate: {
      type: String,
      default: "gg.aa.yy",
    },
    placeholderDatetime: {
      type: String,
      default: "gg.aa.yy ss:dd",
    },
    manualInput: {
      type: Boolean,
      default: true,
    },
    showTime: {
      type: Boolean,
      default: true,
    },
  });
  const date = ref(null);
  function onHide(){
    emits("hide");
  }
  watch(date,()=>{
    emits("update:modelValue",date.value)
  });
  watch(()=>props.modelValue,()=>{
    
      setDate();
    
  });
  
  function setDate() {
      if (typeof props.modelValue == "string") {
        date.value = new Date(props.modelValue);
      } else {
        date.value = props.modelValue;
      }
    }
  onMounted(()=>{
    setDate();
  })
</script> 