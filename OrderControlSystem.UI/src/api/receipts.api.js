import api from "./index.js";
import { ref } from "vue";
import { flatFiltersForApi, objectToQueryForApi } from "../helper.js";
export const useReceiptApi = () => {
  const receipts = ref(null);
  const receiptsLoading = ref(false);
  async function getReceipt(receiptId) {
    try {
      receiptsLoading.value = true;
      let response = await api.get("processSteps/getreceipt?receiptId=" + receiptId);
      console.log("get receipt = ", response.data?.value);
      return response.data?.value;
    } catch (error) {
      console.log(error);
      receiptsLoading.value = false;
    } finally {
      receiptsLoading.value = false;
    }
  }
  async function addReceipt(receipt) {
    try {
      receiptsLoading.value = true;
      let response = await api.post("processSteps/AddReceipt", receipt);
    } catch (error) {
      console.log(error);
      receiptsLoading.value = false;
    } finally {
      receiptsLoading.value = false;
    }
  }
  async function getReceiptsList(filter) {
    try {
      receiptsLoading.value = true;
      let qs = objectToQueryForApi(filter);
      let response = await api.get("processSteps/getreceiptlist");
      receipts.value = response.data?.value;
      return response.data?.value;
      
    } catch (error) {
      console.log(error);
      receiptsLoading.value = false;
    } finally {
      receiptsLoading.value = false;
    }
  }
  async function updateReceipt(willUpdateReceipt) {
    try {
      receiptsLoading.value = true;
      await api.post("processSteps/UpdateReceipt", willUpdateReceipt);
    } catch (error) {
      console.log(error);
      receiptsLoading.value = false;
    } finally {
      receiptsLoading.value = false;
    }
  }
  async function deleteReceipt(receiptId) {
    try {
      receiptsLoading.value = true;
      await api.post("processSteps/DeleteReceipt?receiptId=" + receiptId);
    } catch (error) {
      console.log(error);
      receiptsLoading.value = false;
    } finally {
      receiptsLoading.value = false;
    }
  }
  async function getReceiptDataByCustomerOrderItem(customerOrderItemId) {
    try {
      receiptsLoading.value = true;
      let res;
      res = await api.get("processSteps/GetReceiptDataByCustomerOrderItem?customerOrderItemId=" + customerOrderItemId);
      return res.data?.result;
    } catch (error) {
      console.log(error);
      receiptsLoading.value = false;
    } finally {
      receiptsLoading.value = false;
    }
  }

  async function getReceiptData(receiptId) {
    try {
      receiptsLoading.value = true;
      let res;
      res = await api.get("processSteps/getReceiptData?receiptId=" + receiptId);
      console.log(res.data);
      return res.data?.result;
    } catch (error) {
      console.log(error);
      receiptsLoading.value = false;
    } finally {
      receiptsLoading.value = false;
    }
  }
  async function getAll(data) {
    try {
      receiptsLoading.value = true;
      let res;
      res = await api.post("processSteps/ListWithDetail",flatFiltersForApi(data));
      console.log(res.data);
      return res.data?.value;
    } catch (error) {
      console.log(error);
      receiptsLoading.value = false;
    } finally {
      receiptsLoading.value = false;
    }
  }

  return {
    useReceiptApi,
    getReceiptsList,
    getReceipt,
    addReceipt,
    receipts,
    updateReceipt,
    deleteReceipt,
    getReceiptDataByCustomerOrderItem,
    getReceiptData,
    receiptsLoading,
    getAll
  };
};
export default useReceiptApi;
