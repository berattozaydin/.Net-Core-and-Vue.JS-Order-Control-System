import { ref } from "vue";
import api from "./index.js";

export const useAccountApi = () => {
    const accounts = ref(null);
    async function fetchAccount(){
        let response;
        try{
            response = await api.get("Account/GetAllAccount");
            console.log(response);
            accounts.value=response.data?.value;
            return response.data?.value;
        }catch(error){
            console.log(error);
        }
    }
    async function deleteAccount(userName){
        try{
            await api.post("Account/DeleteAccount?userName="+userName);
        }catch(error){
            console.log(error);
        }
    }
    return{
        fetchAccount,
        deleteAccount,
    };
}
export default useAccountApi;