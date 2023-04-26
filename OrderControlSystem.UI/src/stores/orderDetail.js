import { defineStore } from "pinia";
import api from "@/api";
import qs from "qs";

export const useOrderDetailStore = defineStore({
  id: "orderDetail",

  state: () => ({
    orderDetails: [],
    orderDetailTotalRecords: 0,
    selectedOrderDetail: {},
    orderDetailLoading: false,
  }),

  getters: {
    getOrderDetails: (state) => state.orderDetails,
  },

  actions: {
    async fetchOrderDetails(params) {
      this.orderDetailLoading = true;
      let queryParams = qs.stringify(params);
      let res = await api.get("OrderDetail.php?get&" + queryParams);
      if (res && res.data?.success) {
        this.orderDetails = res.data.value;
        this.orderDetailTotalRecords = res.data.totalRecords;
      }
      this.orderDetailLoading = false;
    },

    async updateOrderDetail(orderDetail) {
      this.orderDetailLoading = true;
      let orderDetailQs = qs.stringify({
        orderDetailId: orderDetail.orderDetailId,
        orderDetailQtyTypeId: orderDetail.orderDetailQtyTypeId,
        orderDetailSubplaceId: orderDetail.orderDetailSubplaceId,
        orderDetailTypeId: orderDetail.orderDetailTypeId,
        workId: orderDetail.workId,
        orderDetailCardId: orderDetail.orderDetailCardId,
        lockQty: orderDetail.lockQty,
        curQty: orderDetail.curQty,
        ordQty: orderDetail.ordQty,
        minQty: orderDetail.minQty,
        shelf: orderDetail.shelf,
        remark: orderDetail.remark,
        lockReason: orderDetail.lockReason,
        deliveryDate: orderDetail.deliveryDate,
      });
      await api.post("OrderDetail.php?update&", orderDetailQs);
      this.orderDetailLoading = false;
    }, 

    async addOrderDetail(orderDetail) {
      this.orderDetailLoading = true;
      let orderDetailQs = qs.stringify({
        orderDetailQtyTypeId: orderDetail.orderDetailQtyTypeId,
        orderDetailSubplaceId: orderDetail.orderDetailSubplaceId,
        orderDetailTypeId: orderDetail.orderDetailTypeId,
        workId: orderDetail.workId,
        orderDetailCardId: orderDetail.orderDetailCardId,
        lockQty: orderDetail.lockQty,
        curQty: orderDetail.curQty,
        ordQty: orderDetail.ordQty,
        minQty: orderDetail.minQty,
        shelf: orderDetail.shelf,
        remark: orderDetail.remark,
        lockReason: orderDetail.lockReason,
        deliveryDate: orderDetail.deliveryDate,
      });
      await api.post("OrderDetail.php?add&", orderDetailQs);
      this.orderDetailLoading = false;
    },

    async deleteOrderDetail(orderDetail) {
      this.orderDetailLoading = true;
      let orderDetailQs = qs.stringify({
        orderDetailId: orderDetail.orderDetailId,
      });
      await api.post("OrderDetail.php?delete&", orderDetailQs);
      this.orderDetailLoading = false;
    },

    initOrderDetail() {
      return {
        orderDetailQtyTypeId: null,
        orderDetailSubplaceId: null,
        orderDetailTypeId: null,
        workId: null,
        orderDetailCardId: null,
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

export default useOrderDetailStore;
