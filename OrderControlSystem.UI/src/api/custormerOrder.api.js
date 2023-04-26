import api from "./index.js";
import { ref } from "vue";
import { flatFiltersForApi, objectToQueryForApi } from "../helper.js";
export const useCustomerOrderApi = () => {
  const customerOrder = ref(null);
  const customerOrderLoading = ref(false);
    async function getCustomerOrderList(filter){
      let response;
        try {
            customerOrderLoading.value=true;
            let qs = objectToQueryForApi(filter);
            response = await api.post("CustomerOrder/GetCustomerOrderList" ,{statusId:filter});
            customerOrder.value = response.data?.value;
            return response.data?.value;
          } catch{
            return "Sunucuya Bağlanılamadı";
          }finally{
            customerOrderLoading.value=false;
        }
    }
    async function getCustomerOrder(customerOrderId){
      try{
        let response = await api.get("customerOrder/GetCustomerOrder?customerOrderId=" + customerOrderId);
        return response.data?.result.value;
      }catch(error){
        console.log(error);
      }
    }
    async function addCustomerOrder(customerOrder){
      try{
       let response  = await api.post("customerOrder/AddCustomerOrder",customerOrder);
       //return response.data?.value;
      }catch(error){
        console.log(error);
      }
    }
    async function updateCustomerOrder(willCustomerOrder){
      let response;
      try{
        response = await api.post("customerOrder/UpdateCustomerOrder",willCustomerOrder);
        return response.data;
      }catch(error){
        return response.data?.message;
      }
    }
    async function deleteCustomerOrder(customerOrderId){
      try{
        await api.post("customerOrder/DeleteCustomerOrder?customerOrderId="+customerOrderId);
      }catch(error){
        console.log(error);
      }
    }
    async function getCustomerOrderStatus(){
      try{
        let res = await api.get("customerOrder/GetCustomerOrderStatus");
        return res.data?.result;
      }catch(error){
        console.log(error);
      }
    }
    async function getCustomerOrderStatusCount(){
      try{
        let res = await api.get("customerOrder/GetCustomerOrderStatusCount");
        return res.data?.result.value;
      }catch(error){
        console.log(error);
      }
    }
    async function fetchL4CustomerOrder(){
      try{
        customerOrderLoading.value=true;
        let res = await api.get("level4/GetCustomerOrder");
        return res.data;
      }catch(error){
         console.log(error);
      }finally{
        customerOrderLoading.value=false;
      }
    }
    async function l3tol4status(customerOrder,statusId){
      try{
        let res = await api.post("level4/UpdateL4Status",{customerOrder:customerOrder,statusId:statusId});
        return res.data;
      }catch(error){
         console.log(error);
      }
    }
    async function getAll(data){
      try{
        customerOrderLoading.value=true;
        let res = await api.post("customerorder/ListWithCustomerOrder",flatFiltersForApi(data));
        return res.data;
      }catch(error){
        console.log(error);
        customerOrderLoading.value=true;
      }finally{
        customerOrderLoading.value=false;
      }
    }
    async function getCustomerOrderNumber(){
      try{
        let res = await api.get("customerorder/GetCustomerOrderNumber");
        return res.data;
      }catch(error){
        console.log(error);
      }
    }
  return {
    useCustomerOrderApi,
    customerOrder,
    getCustomerOrderList,
    getCustomerOrder,
    addCustomerOrder,
    updateCustomerOrder,
    deleteCustomerOrder,
    getCustomerOrderStatus,
    fetchL4CustomerOrder,
    l3tol4status,
    getCustomerOrderStatusCount,
    customerOrderLoading,
    getAll,
    getCustomerOrderNumber,
  };
};
export default useCustomerOrderApi;