 
<template>
  <form class="grid">
    <div class="col-12">
      <slot name="header"></slot>
    </div>
    <div class="col-12">
      <slot name="body"></slot>
    </div>
    <div class="col-12 pb-0">
      <div class="flex justify-content-end">
        <slot name="footer"></slot>
      </div>
    </div>
  </form>
</template>