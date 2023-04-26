import { ref } from "vue";
import api from "./index.js";

export const useMaterialQualityApi = () => {
    const materialQualityLoading = ref(false);
    async function getMaterialQualities(){
        let response;
        try{
            materialQualityLoading.value=true;
            response = await api.get("MaterialQuality/GetMaterialQualityList");
            return response.data?.value;
        }catch(error){
            console.log(error);
        }finally{
            materialQualityLoading.value=false;
        }
    }
    async function deleteMaterialQuality(materialQualityId){
        let response;
        try{
            materialQualityLoading.value=true;
            response = await api.get("MaterialQuality/DeleteMaterialQuality?materialQualityId="+materialQualityId);
            return response.data?.value;
        }catch(error){
            console.log(error);
        }finally{
            materialQualityLoading.value=false;
        }
    }
    async function AddMaterialQuality(newMaterialQuality){
        let response;
        try{
            materialQualityLoading.value=true;
            response = await api.post("MaterialQuality/AddMaterialQuality",newMaterialQuality);
            return response.data?.value;
        }catch(error){
            console.log(error);
        }finally{
            materialQualityLoading.value=false;
        }
    }
    async function getMaterialQuality(materialQualityId){
        let response;
        try{
            materialQualityLoading.value=true;
            response = await api.get("MaterialQuality/GetMaterialQuality?materialQualityId="+materialQualityId);
            return response.data?.value;
        }catch(error){
            console.log(error);
        }finally{
            materialQualityLoading.value=false;
        }
    }
    async function updateMaterialQuality(willUpdateMaterialQuality){
        let response;
        try{
            materialQualityLoading.value=true;
            response = await api.post("MaterialQuality/UpdateMaterialQuality",willUpdateMaterialQuality);
            return response.data?.value;
        }catch(error){
            console.log(error);
        }finally{
            materialQualityLoading.value=false;
        }
    }
    return{
        getMaterialQualities,
        deleteMaterialQuality,
        AddMaterialQuality,
        getMaterialQuality,
        updateMaterialQuality,
        materialQualityLoading
    };
}
export default useMaterialQualityApi;