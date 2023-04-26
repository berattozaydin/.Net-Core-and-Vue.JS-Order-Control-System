import { ref } from "vue";
import api from "./index.js";

export const useCustomerApi = () => {
    const customers = ref();
    const customerLoading = ref(false);
    async function fetchCustomer(){
        let response;
        try{
            customerLoading.value=true;
            response = await api.get("customer/GetCustomerList");
            customers.value=response.data?.value;
            return response.data?.value;
        }catch(error){
            console.log(error);
        }finally{
            customerLoading.value=false;
        }
    }
    async function synchronizeCustomer(){
        let response;
        try{
            customerLoading.value=true;
            response = await api.get("customer/getcustomerlistwithaccounting");
            return response.data;
        }catch(error){
            customerLoading.value=false;
            console.log(error);
        }finally{
            customerLoading.value=false;
        }
    }
    return{
        fetchCustomer,
        customers,
        synchronizeCustomer,
        customerLoading
    };
}
export default useCustomerApi;