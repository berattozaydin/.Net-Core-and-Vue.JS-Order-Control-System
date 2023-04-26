import api from "./index.js";
import { ref } from "vue";
import { objectToQueryForApi } from "../helper.js";
export const useReceiptDetailApi = () => {
    const receiptsDetailLoading = ref(false);
    async function getReceiptDetail(receiptId){
        try{
            receiptsDetailLoading.value=true;
            let response = await api.get("receiptdetail/Getreceiptdetails?receiptId="+receiptId);
            console.log(response.data);
            return response.data?.value;
        }catch(error){
            console.log(error);
        }finally{
            receiptsDetailLoading.value=false;
        }
    }
    async function deleteReceiptDetail(receiptDetailId){
        try{
            await api.post("receiptDetail/DeleteReceiptDetail?receiptDetailId="+receiptDetailId);
        }catch(error){
            console.log(error);
        }
    }
    async function updateReceiptDetail(receiptDetail){
        try{
            await api.post("receiptDetail/UpdateReceiptDetail",receiptDetail);
        }catch(error){
            console.log(error);
        }
    }
    return{
        getReceiptDetail,
        deleteReceiptDetail,
        updateReceiptDetail,
    }
};
export default useReceiptDetailApi;