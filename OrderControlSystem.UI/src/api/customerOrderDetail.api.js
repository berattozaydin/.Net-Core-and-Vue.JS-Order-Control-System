import api from "./index.js";

export const useCustomerOrderDetailApi = () => {
    async function getCustomerOrderDetail(customerOrderItemId){
        let response;
        try{
            response = await api.get("customerOrderItem/GetCustomerOrderDetail?customerOrderItemId="+customerOrderItemId);
            return response.data;
        }catch(error){
            console.log(error);
        }
    }
    async function getCustomerOrderDetailList(customerOrderId){
        let response;
        try{ 
            response = await api.get("customerOrderItem/GetCustomerOrderItemList?customerOrderId="+customerOrderId);
            return response.data?.value;
        }catch(error){
            console.log(error);
        }
    }
    async function deleteCustomerOrderDetail(customerOrderItemId){
        try{ 
           await api.post("customerOrderItem/DeleteCustomerOrderItem?customerOrderItemId= "+customerOrderItemId);
            
        }catch(error){
            console.log(error);
        }
    }
    async function getCustomerOrderItemList(){
        try{
            let response = await api.get("customerOrderItem/GetCustomerOrderItem");
            return response.data?.value;
        }catch(error){
            console.log(error);
        }
    }
    async function addCustomerOrderDetail(customerOrderItem){
        try{
            await api.post("customerOrderItem/AddCustomerOrderItem",customerOrderItem);
        }catch(error){
            console.log(error);
        }
    }
    async function updateCustomerOrderItem(customerOrderItem){
        try{
            await api.post("customerOrderItem/UpdateCustomerOrderItem",customerOrderItem);
        }catch(error){
            console.log(error);
        }
    }
    async function getCustomerOrderItemStatus(){
        try{
            let response;
            response=await api.get("customerOrderItem/GetCustomerOrderItemStatus");
            return response.data?.value;
        }catch(error){
            console.log(error);
        }
    }
    async function GetFurnaceDataByCustomerOrderItem(customerOrderItemId){
        try{
            let response;
            response=await api.get("customerOrderItem/GetFurnaceDataByCustomerOrderItem?CustomerOrderItemId="+customerOrderItemId);
           
            return response.data?.result;
        }catch(error){
            console.log(error);
        }
    }
    
    async function GetCustomerOrderItem(customerOrderItem){
        try{
            let response;
            response=await api.get("Level4/GetCustomerOrderItem?customerOrderId="+customerOrderItem.customerOrderId);
            console.log(response.data);
            return response.data;
        }catch(error){
            console.log(error);
        }
    }
    async function UploadFile(customerOrderItem){
        try{
            let response;
            response=await api.post("CustomerOrderItem/UploadFile",customerOrderItem);
            console.log(response.data);
            return response.data;
        }catch(error){
            console.log(error);
        }
    }
    
    return {
        addCustomerOrderDetail,
        getCustomerOrderDetail,
        deleteCustomerOrderDetail,
        getCustomerOrderDetailList,
        getCustomerOrderItemList,
        updateCustomerOrderItem,
        getCustomerOrderItemStatus,
        GetFurnaceDataByCustomerOrderItem,
        GetCustomerOrderItem,
        UploadFile,
    }
}
export default useCustomerOrderDetailApi;