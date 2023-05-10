import api from "./index.js";
import { ref } from "vue";
import { flatFiltersForApi, objectToQueryForApi } from "../helper.js";
export const useProcessStepsApi = () => {
  const processStepss = ref(null);
  const processStepssLoading = ref(false);
  async function getProcessSteps(processStepsId) {
    try {
      processStepssLoading.value = true;
      let response = await api.get("processSteps/getprocessSteps?processStepsId=" + processStepsId);
      console.log("get processSteps = ", response.data?.value);
      return response.data?.value;
    } catch (error) {
      console.log(error);
      processStepssLoading.value = false;
    } finally {
      processStepssLoading.value = false;
    }
  }
  async function addProcessSteps(processSteps) {
    try {
      processStepssLoading.value = true;
      let response = await api.post("processSteps/AddProcessSteps", processSteps);
    } catch (error) {
      console.log(error);
      processStepssLoading.value = false;
    } finally {
      processStepssLoading.value = false;
    }
  }
  async function getProcessStepssList(filter) {
    try {
      processStepssLoading.value = true;
      let qs = objectToQueryForApi(filter);
      let response = await api.get("processSteps/getprocessStepslist");
      processStepss.value = response.data?.value;
      return response.data?.value;
      
    } catch (error) {
      console.log(error);
      processStepssLoading.value = false;
    } finally {
      processStepssLoading.value = false;
    }
  }
  async function updateProcessSteps(willUpdateProcessSteps) {
    try {
      processStepssLoading.value = true;
      await api.post("processSteps/UpdateProcessSteps", willUpdateProcessSteps);
    } catch (error) {
      console.log(error);
      processStepssLoading.value = false;
    } finally {
      processStepssLoading.value = false;
    }
  }
  async function deleteProcessSteps(processStepsId) {
    try {
      processStepssLoading.value = true;
      await api.post("processSteps/DeleteProcessSteps?processStepsId=" + processStepsId);
    } catch (error) {
      console.log(error);
      processStepssLoading.value = false;
    } finally {
      processStepssLoading.value = false;
    }
  }
  async function getProcessStepsDataByCustomerOrderItem(customerOrderItemId) {
    try {
      processStepssLoading.value = true;
      let res;
      res = await api.get("processSteps/GetProcessStepsDataByCustomerOrderItem?customerOrderItemId=" + customerOrderItemId);
      return res.data?.result;
    } catch (error) {
      console.log(error);
      processStepssLoading.value = false;
    } finally {
      processStepssLoading.value = false;
    }
  }

  async function getProcessStepsData(processStepsId) {
    try {
      processStepssLoading.value = true;
      let res;
      res = await api.get("processSteps/getProcessStepsData?processStepsId=" + processStepsId);
      console.log(res.data);
      return res.data?.result;
    } catch (error) {
      console.log(error);
      processStepssLoading.value = false;
    } finally {
      processStepssLoading.value = false;
    }
  }
  async function getAll(data) {
    try {
      processStepssLoading.value = true;
      let res;
      res = await api.post("processSteps/ListWithDetail",flatFiltersForApi(data));
      console.log(res.data);
      return res.data?.value;
    } catch (error) {
      console.log(error);
      processStepssLoading.value = false;
    } finally {
      processStepssLoading.value = false;
    }
  }

  return {
    useProcessStepsApi,
    getProcessStepssList,
    getProcessSteps,
    addProcessSteps,
    processStepss,
    updateProcessSteps,
    deleteProcessSteps,
    getProcessStepsDataByCustomerOrderItem,
    getProcessStepsData,
    processStepssLoading,
    getAll
  };
};
export default useProcessStepsApi;
