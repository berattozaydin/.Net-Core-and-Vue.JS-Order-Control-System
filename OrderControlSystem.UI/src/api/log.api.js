import { ref } from "vue";
import api from "./index.js";

export const useLogApi = () => {
    const logs = ref();
    const logsLoading = ref(false);
    async function fetchLogData(){
        let response;
        try{
            logsLoading.value=true;
            response = await api.get("Log/FetchLogData");
            console.log(response);
            return response.data?.value;
        }catch(error){
            console.log(error);
        }finally{
            logsLoading.value=false;
        }
    }
    return{
        fetchLogData,
        logs,
        logsLoading
    };
}
export default useLogApi;