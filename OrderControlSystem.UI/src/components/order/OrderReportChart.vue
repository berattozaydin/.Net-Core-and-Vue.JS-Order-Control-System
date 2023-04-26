<template>
  <div id="chart">
    <VueApexCharts type="line" height="350" :options="chartOptions" :series="series"></VueApexCharts>

  </div>
</template>

<script setup>
import { onMounted, ref, watch } from "vue";
import VueApexCharts from "vue3-apexcharts";
import useCustomerOrderDetailApi from "../../api/customerOrderDetail.api";
const customerOrderItemApi = useCustomerOrderDetailApi();
const furnace1Data = ref([]);
const props = defineProps(["customerOrderItemId"]);

const series = ref([
]);
const chartOptions = ref({
  colors: ['#008ffb', '#F44336'],
  chart: {
    height: 350,
    type: 'line',
    zoom: {
      enabled: false
    },
  },
  dataLabels: {
    enabled: false
  },
  stroke: {
    width: [5, 7, 5],
    curve: 'straight',
    dashArray: [0, 8, 5]
  },
  /*  legend: {
     tooltipHoverFormatter: function (val, opts) {
       return val + ' - ' + opts.w.globals.series[opts.seriesIndex][opts.dataPointIndex] + ''
     }
   }, */
  markers: {
    size: 0,
    hover: {
      sizeOffset: 6
    }
  },
  xaxis: {
    categories: [
      'Başlangıç', '01. Sa', '02. Sa', '03. Sa', '04. Sa', '05. Sa', '06. Sa', '07. Sa', '08. Sa', '09. Sa',
      '10. Sa', '11. Sa'
    ],
  },
  tooltip: {
    y: [
      {
        title: {
          formatter: function (val) {
            return val + " (C)"
          }
        }
      },
      {
        title: {
          formatter: function (val) {
            return val + " (C)";
          }
        }
      }
    ]
  },
  grid: {
    borderColor: '#f1f1f1',
  }
});
 
</script> 