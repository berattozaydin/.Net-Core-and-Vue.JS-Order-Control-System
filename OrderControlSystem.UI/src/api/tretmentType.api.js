import api from "./index.js";
export const useTreatmentTypeApi = ()=>{
    async function GetTreatmentTypeList(){
        try{
            let res = await api.get("TreatmentType/GetTreatmentTypeList");
            return res.data?.value;
        }catch(error){
            console.log(error);
        }
    }
    return{
        GetTreatmentTypeList
    };
}
export default useTreatmentTypeApi;