import { defineStore } from "pinia";
import api from "@/api";
import qs from "qs";

export const useOrderStore = defineStore({
  id: "order",

  state: () => ({
    orders: [],
    orderTotalRecords: 0,
    selectedOrder: {},
    orderLoading: false,
  }),

  getters: {
    getOrders: (state) => state.orders,
  },

  actions: {
    async fetchOrders(params) {
      this.orderLoading = true;
      let queryParams = qs.stringify(params);
      let res = await api.get("Order.php?get&" + queryParams);
      if (res && res.data?.success) {
        this.orders = res.data.value;
        this.orderTotalRecords = res.data.totalRecords;
      }
      this.orderLoading = false;
    },

    async updateOrder(order) {
      this.orderLoading = true;
      let orderQs = qs.stringify({
        orderId: order.orderId,
        orderQtyTypeId: order.orderQtyTypeId,
        orderSubplaceId: order.orderSubplaceId,
        orderTypeId: order.orderTypeId,
        workId: order.workId,
        orderCardId: order.orderCardId,
        lockQty: order.lockQty,
        curQty: order.curQty,
        ordQty: order.ordQty,
        minQty: order.minQty,
        shelf: order.shelf,
        remark: order.remark,
        lockReason: order.lockReason,
        deliveryDate: order.deliveryDate,
      });
      await api.post("Order.php?update&", orderQs);
      this.orderLoading = false;
    }, 

    async addOrder(order) {
      this.orderLoading = true;
      let orderQs = qs.stringify({
        orderQtyTypeId: order.orderQtyTypeId,
        orderSubplaceId: order.orderSubplaceId,
        orderTypeId: order.orderTypeId,
        workId: order.workId,
        orderCardId: order.orderCardId,
        lockQty: order.lockQty,
        curQty: order.curQty,
        ordQty: order.ordQty,
        minQty: order.minQty,
        shelf: order.shelf,
        remark: order.remark,
        lockReason: order.lockReason,
        deliveryDate: order.deliveryDate,
      });
      await api.post("Order.php?add&", orderQs);
      this.orderLoading = false;
    },

    async deleteOrder(order) {
      this.orderLoading = true;
      let orderQs = qs.stringify({
        orderId: order.orderId,
      });
      await api.post("Order.php?delete&", orderQs);
      this.orderLoading = false;
    },

    initOrder() {
      return {
        orderQtyTypeId: null,
        orderSubplaceId: null,
        orderTypeId: null,
        workId: null,
        orderCardId: null,
        lockQty: 0,
        curQty: 0,
        ordQty: 0,
        minQty: 0,
        shelf: null,
        remark: null,
        lockReason: null,
        deliveryDate: null,
      };
    }, 
    
  },
  persist: false,
});

export default useOrderStore;
