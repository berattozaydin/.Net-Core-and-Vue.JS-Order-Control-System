<template>
  <div class="flex justify-content-center">
    <IconBoxEmpty class="w-3 md:w-1 p-2" />
    <div class="w-3 md:w-1 p-2">
      <h2>Veri yok</h2>
    </div>
  </div>
  <!-- <div class="flex justify-content-center">
    <h2>Veri bulunamadı.</h2>
  </div> -->
</template> 

<script>
import IconBoxEmpty from "../icons/IconBoxEmpty.vue";
export default {
  components: { IconBoxEmpty },
};
</script>